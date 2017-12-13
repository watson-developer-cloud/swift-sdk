/**
 * Copyright IBM Corporation 2016-2017
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 **/

import Foundation
import CoreML
import Vision

@available(iOS 11.0, macOS 10.13, tvOS 11.0, watchOS 4.0, *)
extension VisualRecognition {

    // MARK: - Core ML

    /**
     Retrieve a Core ML model from the local filesystem.

     - parameter classifierID: The ID of the classifier whose Core ML model will be retrieved.
     - returns: A Core ML model loaded from the local filesystem.
     */
    public func getLocalModel(classifierID: String) throws -> MLModel {
        return try loadModelFromDisk(classifierID: classifierID)
    }

    /**
     Download the latest Core ML model to the local filesystem, unless the latest version
     is already available locally. The classifier must have a `coreMLStatus` of `ready`
     in order to download the latest model.

     - parameter classifierID: The ID of the classifier whose Core ML model will be retrieved.
     - parameter failure: A function executed if an error occurs.
     - parameter success: A function executed after the local model has been updated.
     */
    public func updateLocalModel(
        classifierID: String,
        failure: ((Error) -> Void)? = nil,
        success: (() -> Void)? = nil)
    {
        // setup date formatter '2017-12-04T19:44:27.419Z'
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"

        // locate model on disk
        guard let model = try? loadModelFromDisk(classifierID: classifierID) else {
            downloadClassifier(classifierID: classifierID, failure: failure, success: success)
            return
        }

        // parse model's `updated` date
        let description = model.modelDescription
        let metadata = description.metadata[MLModelMetadataKey.creatorDefinedKey] as? [String: String] ?? [:]
        guard let updated = metadata["updated"], let modelDate = dateFormatter.date(from: updated) else {
            downloadClassifier(classifierID: classifierID, failure: failure, success: success)
            return
        }

        // parse classifier's `updated` date
        getClassifier(withID: classifierID, failure: failure) { classifier in
            guard let classifierDate = dateFormatter.date(from: classifier.updated) else {
                self.downloadClassifier(classifierID: classifierID, failure: failure, success: success)
                return
            }

            // download the latest model if a newer version is available
            if classifierDate > modelDate && classifier.coreMLStatus == "ready" {
                self.downloadClassifier(classifierID: classifierID, failure: failure, success: success)
            } else {
                success?();
            }
        }
    }

    /**
     List the Core ML models stored in the local filesystem.

     - returns: A list of classifier IDs with local Core ML models that are available for classification.
     */
    public func listLocalModels() throws -> [String] {
        var models = Set<String>()

        // search for models in the main bundle
        if let modelURLs = Bundle.main.urls(forResourcesWithExtension: "mlmodelc", subdirectory: nil) {
            for modelURL in modelURLs {
                let classifierID = String(modelURL.path.split(separator: ".")[0])
                models.insert(classifierID)
            }
        }

        // locate application support directory
        let fileManager = FileManager.default
        let applicationSupportDirectories = fileManager.urls(for: .applicationSupportDirectory, in: .userDomainMask)
        guard let applicationSupport = applicationSupportDirectories.first else {
            let description = "Failed to locate the application support directory."
            let userInfo = [NSLocalizedDescriptionKey: description]
            let error = NSError(domain: self.domain, code: 0, userInfo: userInfo)
            throw error
        }

        // search for models in the application support directory
        let allContents = try fileManager.contentsOfDirectory(atPath: applicationSupport.path)
        let modelPaths = allContents.filter() { $0.contains(".mlmodelc") }
        for modelPath in modelPaths {
            let classifierID = String(modelPath.split(separator: ".")[0])
            models.insert(classifierID)
        }

        return Array(models)
    }

    /**
     Delete a Core ML model from the local filesystem.

     - parameter classifierID: The ID of the classifier whose Core ML model shall be deleted.
     */
    public func deleteLocalModel(classifierID: String) throws {
        let modelURL = try locateModelOnDisk(classifierID: classifierID)
        try FileManager.default.removeItem(at: modelURL)
    }

    /**
     Classify an image using a Core ML model from the local filesystem.
     
     - parameter image: The image to classify.
     - parameter classifierIDs: A list of the classifier ids to use. "default" is the id of the
       built-in classifier.
     - parameter threshold: The minimum score a class must have to be displayed in the response.
     - parameter failure: A function executed if an error occurs.
     - parameter success: A function executed with the image classifications.
     */
    public func classifyWithLocalModel(
        image: UIImage,
        classifierIDs: [String] = ["default"],
        threshold: Double? = nil,
        failure: ((Error) -> Void)? = nil,
        success: @escaping (ClassifiedImages) -> Void)
    {
        // convert UIImage to Data
        guard let image = UIImagePNGRepresentation(image) else {
            let description = "Failed to convert image from UIImage to Data."
            let userInfo = [NSLocalizedDescriptionKey: description]
            let error = NSError(domain: self.domain, code: 0, userInfo: userInfo)
            failure?(error)
            return
        }

        // ensure a classifier id was provided
        guard !classifierIDs.isEmpty else {
            let description = "Please provide at least one classifierID."
            let userInfo = [NSLocalizedDescriptionKey: description]
            let error = NSError(domain: self.domain, code: 0, userInfo: userInfo)
            failure?(error)
            return
        }

        // construct each classification request
        var requests = [VNCoreMLRequest]()
        var results = [(MLModel, [VNClassificationObservation])]()
        let dispatchGroup = DispatchGroup()
        for classifierID in classifierIDs {
            dispatchGroup.enter()

            // get classifier model
            guard let model = try? loadModelFromDisk(classifierID: classifierID) else {
                dispatchGroup.leave()
                let description = "Failed to get the Core ML model for classifier \(classifierID)"
                let userInfo = [NSLocalizedDescriptionKey: description]
                let error = NSError(domain: self.domain, code: 0, userInfo: userInfo)
                failure?(error)
                continue
            }

            // convert MLModel to VNCoreMLModel
            guard let classifier = try? VNCoreMLModel(for: model) else {
                dispatchGroup.leave()
                let description = "Could not convert MLModel to VNCoreMLModel for classifier \(classifierID)"
                let userInfo = [NSLocalizedDescriptionKey: description]
                let error = NSError(domain: self.domain, code: 0, userInfo: userInfo)
                failure?(error)
                continue
            }
            
            // construct classification request
            let request = VNCoreMLRequest(model: classifier) { request, error in
                guard error == nil else {
                    dispatchGroup.leave()
                    let description = "Classifier \(classifierID) failed with error: \(error!)"
                    let userInfo = [NSLocalizedDescriptionKey: description]
                    let error = NSError(domain: self.domain, code: 0, userInfo: userInfo)
                    failure?(error)
                    return
                }
                guard let observations = request.results as? [VNClassificationObservation] else {
                    dispatchGroup.leave()
                    let description = "Failed to parse results for classifier \(classifierID)"
                    let userInfo = [NSLocalizedDescriptionKey: description]
                    let error = NSError(domain: self.domain, code: 0, userInfo: userInfo)
                    failure?(error)
                    return
                }
                results.append((model, observations))
                dispatchGroup.leave()
            }

            // scale image (this seems wrong but yields results in line with vision demo)
            request.imageCropAndScaleOption = .scaleFill

            requests.append(request)
        }

        // fail if no requests were constructed
        guard !requests.isEmpty else {
            return
        }

        // execute each classification request
        requests.forEach() { request in
            DispatchQueue.global(qos: .userInitiated).async {
                do {
                    let requestHandler = VNImageRequestHandler(data: image)
                    try requestHandler.perform([request])
                } catch {
                    let description = "Failed to process classification request: \(error)"
                    let userInfo = [NSLocalizedDescriptionKey: description]
                    let error = NSError(domain: self.domain, code: 0, userInfo: userInfo)
                    failure?(error)
                    return
                }
            }
        }

        // return results after all classification requests have executed
        dispatchGroup.notify(queue: DispatchQueue.global(qos: .userInitiated)) {
            guard let classifiedImages = try? self.convert(results: results, threshold: threshold) else {
                let description = "Failed to represent results as JSON."
                let userInfo = [NSLocalizedDescriptionKey: description]
                let error = NSError(domain: self.domain, code: 0, userInfo: userInfo)
                failure?(error)
                return
            }
            success(classifiedImages)
        }
    }

    // MARK: - Private Helper Functions

    /**
     Locate a Core ML model on disk. The model must be named "[classifier-id].mlmodelc" and reside in the
     application support directory or main bundle.
     */
    private func locateModelOnDisk(classifierID: String) throws -> URL {

        // locate application support directory
        let fileManager = FileManager.default
        let applicationSupportDirectories = fileManager.urls(for: .applicationSupportDirectory, in: .userDomainMask)
        guard let applicationSupport = applicationSupportDirectories.first else {
            let description = "Failed to locate application support directory."
            let userInfo = [NSLocalizedDescriptionKey: description]
            let error = NSError(domain: self.domain, code: 0, userInfo: userInfo)
            throw error
        }

        // search for model in application support directory
        let downloadedModelURL = applicationSupport.appendingPathComponent(classifierID + ".mlmodelc", isDirectory: false)
        if fileManager.fileExists(atPath: downloadedModelURL.path) {
            return downloadedModelURL
        }

        // search for model in main bundle
        let bundledModelURL = Bundle.main.url(forResource: classifierID, withExtension: ".mlmodelc")
        if let bundledModelURL = bundledModelURL {
            return bundledModelURL
        }

        // model not found -> throw an error
        let description = "Failed to locate a Core ML model on disk for classifier \(classifierID)."
        let userInfo = [NSLocalizedDescriptionKey: description]
        let error = NSError(domain: self.domain, code: 0, userInfo: userInfo)
        throw error
    }

    /**
     Load a Core ML model from disk. The model must be named "[classifier-id].mlmodelc" and reside in the
     application support directory or main bundle.
     */
    private func loadModelFromDisk(classifierID: String) throws -> MLModel {
        let modelURL = try locateModelOnDisk(classifierID: classifierID)
        return try MLModel(contentsOf: modelURL)
    }

    /// Convert results from Core ML classification requests into a `ClassifiedImages` model.
    private func convert(
        results: [(MLModel, [VNClassificationObservation])],
        threshold: Double? = nil)
        throws -> ClassifiedImages
    {
        var classifiers = [[String: Any]]()
        for (model, var observations) in results {
            if let threshold = threshold {
                observations = observations.filter() { $0.confidence > Float(threshold) }
            }
            let description = model.modelDescription
            let metadata = description.metadata[MLModelMetadataKey.creatorDefinedKey] as? [String: String] ?? [:]
            let classifierResults: [String: Any] = [
                "name": metadata["name"] ?? "",
                "classifier_id": metadata["classifier_id"] ?? "",
                "classes": observations.map() { ["class": $0.identifier, "score": Double($0.confidence)] }
            ]
            classifiers.append(classifierResults)
        }

        let classifiedImage: [String: Any] = ["classifiers": classifiers]
        let classifiedImages: [String: Any] = ["images": [classifiedImage]]
        return try ClassifiedImages(json: JSONWrapper(dictionary: classifiedImages))
    }

    /**
     Download a CoreML model to the local filesystem.

     - parameter classifierID: The classifierID of the requested model.
     - parameter failure: A function executed if an error occurs.
     - parameter success: A function executed with the local Core ML model.
     */
    private func downloadClassifier(
        classifierID: String,
        failure: ((Error) -> Void)? = nil,
        success: (() -> Void)? = nil)
    {
        // TODO: revert networking from test server to public service
        // url: serviceURL + "/v3/classifiers/\(classifierID)/core_ml_model"

        // construct query parameters
        // var queryParameters = [URLQueryItem]()
        // queryParameters.append(URLQueryItem(name: "api_key", value: apiKey))
        // queryParameters.append(URLQueryItem(name: "version", value: version))

        // construct header parameters for test server
        var headerParameters = defaultHeaders
        headerParameters["X-API-Key"] = apiKeyTestServer

        // construct REST request
        let request = RestRequest(
            method: "GET",
            url: "http://solution-kit-dev.mybluemix.net/api/v1.0/classifiers/\(classifierID)/model",
            credentials: .apiKey,
            headerParameters: headerParameters
        )

        // locate downloads directory
        let fileManager = FileManager.default
        let downloads: URL
        do {
            downloads = try fileManager.url(
                for: .downloadsDirectory,
                in: .userDomainMask,
                appropriateFor: nil,
                create: true
            )
        } catch {
            let description = "Failed to locate downloads directory: \(error.localizedDescription)"
            let userInfo = [NSLocalizedDescriptionKey: description]
            let error = NSError(domain: self.domain, code: 0, userInfo: userInfo)
            failure?(error)
            return
        }

        // locate application support directory
        let appSupport: URL
        do {
            appSupport = try fileManager.url(
                for: .applicationSupportDirectory,
                in: .userDomainMask,
                appropriateFor: nil,
                create: true
            )
        } catch {
            let description = "Failed to locate application support directory: \(error.localizedDescription)"
            let userInfo = [NSLocalizedDescriptionKey: description]
            let error = NSError(domain: self.domain, code: 0, userInfo: userInfo)
            failure?(error)
            return
        }

        // specify file destinations
        let sourceModelURL = downloads.appendingPathComponent(classifierID + ".mlmodel", isDirectory: false)
        var compiledModelURL = appSupport.appendingPathComponent(classifierID + ".mlmodelc", isDirectory: false)

        // execute REST request
        request.download(to: sourceModelURL) { response, error in
            defer { try? fileManager.removeItem(at: sourceModelURL) }

            guard error == nil else {
                failure?(error!)
                return
            }

            guard let statusCode = response?.statusCode else {
                let description = "Did not receive response."
                let userInfo = [NSLocalizedDescriptionKey: description]
                let error = NSError(domain: self.domain, code: 0, userInfo: userInfo)
                failure?(error)
                return
            }

            guard (200..<300).contains(statusCode) else {
                let description = "Status code was not acceptable: \(statusCode)."
                let userInfo = [NSLocalizedDescriptionKey: description]
                let error = NSError(domain: self.domain, code: statusCode, userInfo: userInfo)
                failure?(error)
                return
            }

            // compile model from source
            let compiledModelTemporaryURL: URL
            do {
                compiledModelTemporaryURL = try MLModel.compileModel(at: sourceModelURL)
            } catch {
                let description = "Could not compile Core ML model from source: \(error.localizedDescription)"
                let userInfo = [NSLocalizedDescriptionKey: description]
                let error = NSError(domain: self.domain, code: 0, userInfo: userInfo)
                failure?(error)
                return
            }
            defer { try? fileManager.removeItem(at: compiledModelTemporaryURL) }

            // move compiled model
            do {
                if fileManager.fileExists(atPath: compiledModelURL.path) {
                    _ = try fileManager.replaceItemAt(compiledModelURL, withItemAt: compiledModelTemporaryURL)
                } else {
                    try fileManager.copyItem(at: compiledModelTemporaryURL, to: compiledModelURL)
                }
            } catch {
                let description = "Failed to move compiled model: \(error)"
                let userInfo = [NSLocalizedDescriptionKey: description]
                let error = NSError(domain: self.domain, code: 0, userInfo: userInfo)
                failure?(error)
                return
            }

            // exclude compiled model from device backups
            var urlResourceValues = URLResourceValues()
            urlResourceValues.isExcludedFromBackup = true
            do {
                try compiledModelURL.setResourceValues(urlResourceValues)
            } catch {
                let description = "Could not exclude compiled model from backup: \(error)"
                let userInfo = [NSLocalizedDescriptionKey: description]
                let error = NSError(domain: self.domain, code: 0, userInfo: userInfo)
                failure?(error)
            }

            success?()
        }
    }
}
