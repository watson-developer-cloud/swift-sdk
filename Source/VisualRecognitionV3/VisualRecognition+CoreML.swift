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

#if os(iOS) || os(macOS) || os(tvOS) || os(watchOS)

import Foundation
import CoreML
import Vision
import RestKit

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

        // load model from disk
        guard let model = try? loadModelFromDisk(classifierID: classifierID) else {
            downloadClassifier(classifierID: classifierID, failure: failure, success: success)
            return
        }

        // parse the date on which the local model was last updated
        let description = model.modelDescription
        let metadata = description.metadata[MLModelMetadataKey.creatorDefinedKey] as? [String: String] ?? [:]
        guard let updated = metadata["retrained"] ?? metadata["created"], let modelDate = dateFormatter.date(from: updated) else {
            downloadClassifier(classifierID: classifierID, failure: failure, success: success)
            return
        }

        // parse the date on which the classifier was last updated
        getClassifier(classifierID: classifierID, failure: failure) { classifier in
            guard let dateString = classifier.retrained ?? classifier.created, let classifierDate = dateFormatter.date(from: dateString) else {
                self.downloadClassifier(classifierID: classifierID, failure: failure, success: success)
                return
            }

            // download the latest model if a newer version is available
            if classifierDate > modelDate && classifier.status == "ready" {
                self.downloadClassifier(classifierID: classifierID, failure: failure, success: success)
            } else {
                success?()
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

        // search for models in the application support directory
        let fileManager = FileManager.default
        if let appSupport = fileManager.urls(for: .applicationSupportDirectory, in: .userDomainMask).first {
            if fileManager.fileExists(atPath: appSupport.path) {
                let allContents = try fileManager.contentsOfDirectory(atPath: appSupport.path)
                let modelPaths = allContents.filter { $0.contains(".mlmodelc") }
                for modelPath in modelPaths {
                    let classifierID = String(modelPath.split(separator: ".")[0])
                    models.insert(classifierID)
                }
            }
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

     - parameter imageData: The image to classify.
     - parameter classifierIDs: A list of the classifier ids to use. "default" is the id of the
       built-in classifier.
     - parameter threshold: The minimum score a class must have to be displayed in the response.
     - parameter failure: A function executed if an error occurs.
     - parameter success: A function executed with the image classifications.
     */
    public func classifyWithLocalModel(
        imageData: Data,
        classifierIDs: [String] = ["default"],
        threshold: Double? = nil,
        failure: ((Error) -> Void)? = nil,
        success: @escaping (ClassifiedImages) -> Void)
    {
        // ensure a classifier id was provided
        guard !classifierIDs.isEmpty else {
            let description = "Please provide at least one classifierID."
            let userInfo = [NSLocalizedDescriptionKey: description]
            let error = NSError(domain: self.domain, code: 0, userInfo: userInfo)
            failure?(error)
            return
        }

        // construct and execute each classification request
        var results = [(MLModel, [VNClassificationObservation])]()
        let dispatchGroup = DispatchGroup()
        for classifierID in classifierIDs {
            dispatchGroup.enter()

            // run classification request in background to avoid blocking
            DispatchQueue.global(qos: .userInitiated).async {

                // get classifier model
                let model: MLModel
                do {
                    model = try self.loadModelFromDisk(classifierID: classifierID)
                } catch {
                    dispatchGroup.leave()
                    let description = "Failed to load model for classifier \(classifierID): \(error.localizedDescription)"
                    let userInfo = [NSLocalizedDescriptionKey: description]
                    let error = NSError(domain: self.domain, code: 0, userInfo: userInfo)
                    failure?(error)
                    return
                }

                // convert MLModel to VNCoreMLModel
                let classifier: VNCoreMLModel
                do {
                    classifier = try VNCoreMLModel(for: model)
                } catch {
                    dispatchGroup.leave()
                    let description = "Failed to convert model for classifier \(classifierID): \(error.localizedDescription)"
                    let userInfo = [NSLocalizedDescriptionKey: description]
                    let error = NSError(domain: self.domain, code: 0, userInfo: userInfo)
                    failure?(error)
                    return
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

                // scale image (yields results in line with vision demo)
                request.imageCropAndScaleOption = .scaleFill

                // execute classification request
                do {
                    let requestHandler = VNImageRequestHandler(data: imageData)
                    try requestHandler.perform([request])
                } catch {
                    dispatchGroup.leave()
                    let description = "Failed to process classification request: \(error.localizedDescription)"
                    let userInfo = [NSLocalizedDescriptionKey: description]
                    let error = NSError(domain: self.domain, code: 0, userInfo: userInfo)
                    failure?(error)
                    return
                }
            }
        }

        // return results after all classification requests have executed
        dispatchGroup.notify(queue: DispatchQueue.global(qos: .userInitiated)) {
            guard !results.isEmpty else { return }
            let classifiedImages: ClassifiedImages
            do {
                classifiedImages = try self.convert(results: results, threshold: threshold)
            } catch {
                let description = "Failed to represent results as JSON: \(error.localizedDescription)"
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

        // search for model in application support directory
        let fileManager = FileManager.default
        if let appSupport = fileManager.urls(for: .applicationSupportDirectory, in: .userDomainMask).first {
            let modelURL = appSupport.appendingPathComponent(classifierID + ".mlmodelc", isDirectory: false)
            if fileManager.fileExists(atPath: modelURL.path) {
                return modelURL
            }
        }

        // search for model in main bundle
        if let modelURL = Bundle.main.url(forResource: classifierID, withExtension: ".mlmodelc") {
            return modelURL
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
        var classifiers = [String]()
        for (model, var observations) in results {
            if let threshold = threshold {
                observations = observations.filter { $0.confidence > Float(threshold) }
            }
            let description = model.modelDescription
            let metadata = description.metadata[MLModelMetadataKey.creatorDefinedKey] as? [String: String] ?? [:]
            let name = metadata["name"] ?? ""
            let classifierID = metadata["classifier_id"] ?? ""
            let classes = observations.map { classs in
                """
                { "class": "\(classs.identifier)", "score": \(Double(classs.confidence)) }
                """
            }.joined(separator: ",")
            let classifierResults =
                """
                { "name": "\(name)", "classifier_id": "\(classifierID)", "classes": [\(classes)] }
                """
            classifiers.append(classifierResults)
        }
        let json = """
            { "images": [{ "classifiers": [ \(classifiers.joined(separator: ",")) ] }] }
        """
        guard let data = json.data(using: .utf8) else { throw RestError.serializationError }
        return try JSONDecoder().decode(ClassifiedImages.self, from: data)
    }

    // swiftlint:disable function_body_length

    /**
     Download a Core ML model to the local filesystem. The model is compiled and moved to the application support
     directory with a filename of `[classifier-id].mlmodelc`.

     - parameter classifierID: The classifierID of the model to download.
     - parameter failure: A function executed if an error occurs.
     - parameter success: A function executed after the Core ML model has been downloaded and compiled.
     */
    private func downloadClassifier(
        classifierID: String,
        failure: ((Error) -> Void)? = nil,
        success: (() -> Void)? = nil)
    {
        // construct header parameters
        var headerParameters = defaultHeaders
        headerParameters["Accept"] = "application/octet-stream"

        // construct query parameters
        var queryParameters = [URLQueryItem]()
        queryParameters.append(URLQueryItem(name: "version", value: version))

        // construct REST request
        let request = RestRequest(
            session: session,
            authMethod: authMethod,
            errorResponseDecoder: errorResponseDecoder,
            method: "GET",
            url: serviceURL + "/v3/classifiers/\(classifierID)/core_ml_model",
            headerParameters: headerParameters,
            queryItems: queryParameters
        )

        // create temporary downloads directory
        let fileManager = FileManager.default
        let downloads: URL
        do {
            downloads = try fileManager.url(
                for: .itemReplacementDirectory,
                in: .userDomainMask,
                appropriateFor: FileManager.default.temporaryDirectory,
                create: true
            )
        } catch {
            let description = "Failed to create temporary downloads directory: \(error.localizedDescription)"
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
            var compiledModelTemporaryURL: URL
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
                let description = "Failed to move compiled model: \(error.localizedDescription)"
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
                let description = "Could not exclude compiled model from backup: \(error.localizedDescription)"
                let userInfo = [NSLocalizedDescriptionKey: description]
                let error = NSError(domain: self.domain, code: 0, userInfo: userInfo)
                failure?(error)
            }

            success?()
        }
    }

    // swiftlint:enable function_body_length
}

#endif
