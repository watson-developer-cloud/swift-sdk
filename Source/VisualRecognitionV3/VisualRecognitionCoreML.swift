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

    // MARK: - Public API

    /// The lookup policy to use when retrieving a Core ML model. Depending on the lookup policy,
    /// one or more network requests may be made to the Visual Recognition service.
    public enum LookupPolicy {

        /// Search the local filesystem for a Core ML model. If the model is not found, then the lookup will fail.
        /// No network requests will be made to the Visual Recognition service.
        case onlyLocal

        /// Search the local filesystem for a Core ML model. If the model is not found, then download it from the
        /// Visual Recognition service. If the model is already available on the local filesystem, then no
        /// network request will be made to the Visual Recognition service.
        case preferLocal

        /// Download the latest Core ML model from the Visual Recognition service, unless it is already available
        /// in the local filesystem. A network request will be made to the Visual Recognition service to check
        /// the latest version of the model. If the local model is out-of-date or not available, then the
        /// latest version of the model will be downloaded from the service.
        case preferRemote

        // TODO: add automatic after adding support for determining the _access_ date of a classifier
    }

    /**
     Retrieve a Core ML model for the given classifier.

     - parameter classifierID: The ID of the classifier whose Core ML model will be retrieved.
     - parameter policy: The policy to use when retrieving the Core ML model. Depending on the lookup policy, one or
       more network requests may be made to the Visual Recognition service.
     - parameter failure: A function executed if an error occurs.
     - parameter success: A function executed with the local Core ML model.
     */
    public func getCoreMLModel(
        classifierID: String,
        policy: LookupPolicy,
        failure: ((Error) -> Void)? = nil,
        success: ((MLModel) -> Void)? = nil)
    {
        switch policy {
        case .onlyLocal: getCoreMLModelOnlyLocal(classifierID: classifierID, failure: failure, success: success)
        case .preferLocal: getCoreMLModelPreferLocal(classifierID: classifierID, failure: failure, success: success)
        case .preferRemote: getCoreMLModelPreferRemote(classifierID: classifierID, failure: failure, success: success)
        }
    }

    /**
     List the Core ML models stored in the local filesystem.

     - returns: A list of classifier IDs with local Core ML models that are available for classification.
     */
    public func listCoreMLModels() throws -> [String] {
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
    public func deleteCoreMLModel(classifierID: String) throws {
        let modelURL = try locateModelOnDisk(classifierID: classifierID)
        try FileManager.default.removeItem(at: modelURL)
    }

    /**
     Classify an image using a local Core ML model.
     
     - parameter image: The image to classify.
     - parameter owners: A list of the classifiers to run. Acceptable values are "IBM" and "me".
     - parameter classifierIDs: A list of the classifier ids to use. "default" is the id of the
       built-in classifier.
     - parameter threshold: The minimum score a class must have to be displayed in the response.
     - parameter language: The language of the output class names. Can be "en" (English), "es"
       (Spanish), "ar" (Arabic), or "ja" (Japanese). Classes for which no translation is available
       are omitted.
     - parameter failure: A function executed if an error occurs.
     - parameter success: A function executed with the image classifications.
     */
    public func classifyCoreML(
        image: UIImage,
        owners: [String]? = nil,
        classifierIDs: [String]? = nil,
        threshold: Double? = nil,
        language: String? = nil,
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

        // use default classifier if none specified
        let classifierIDs = classifierIDs ?? ["default"]

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
        dispatchGroup.notify(queue: DispatchQueue.main) {
            guard let classifiedImages = try? self.convert(results: results) else {
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
     Retrieve a Core ML model for the given classifier, using the `onlyLocal` lookup policy.

     - parameter classifierID: The ID of the classifier whose Core ML model will be retrieved.
     - parameter failure: A function executed if an error occurs.
     - parameter success: A function executed with the local Core ML model.
     */
    private func getCoreMLModelOnlyLocal(
        classifierID: String,
        failure: ((Error) -> Void)? = nil,
        success: ((MLModel) -> Void)? = nil)
    {
        do {
            let modelURL = try loadModelFromDisk(classifierID: classifierID)
            success?(modelURL)
        } catch {
            failure?(error)
        }
    }

    /**
     Retrieve a Core ML model for the given classifier, using the `preferLocal` lookup policy.

     - parameter classifierID: The ID of the classifier whose Core ML model will be retrieved.
     - parameter failure: A function executed if an error occurs.
     - parameter success: A function executed with the local Core ML model.
     */
    private func getCoreMLModelPreferLocal(
        classifierID: String,
        failure: ((Error) -> Void)? = nil,
        success: ((MLModel) -> Void)? = nil)
    {
        do {
            let modelURL = try loadModelFromDisk(classifierID: classifierID)
            success?(modelURL)
        } catch {
            downloadClassifier(classifierID: classifierID, failure: failure, success: success)
        }
    }

    /**
     Retrieve a Core ML model for the given classifier, using the `preferRemote` lookup policy.

     - parameter classifierID: The ID of the classifier whose Core ML model will be retrieved.
     - parameter failure: A function executed if an error occurs.
     - parameter success: A function executed with the local Core ML model.
     */
    private func getCoreMLModelPreferRemote(
        classifierID: String,
        failure: ((Error) -> Void)? = nil,
        success: ((MLModel) -> Void)? = nil)
    {
        // setup date formatter '2017-12-04T19:44:27.419Z'
        let dateFormatter = ISO8601DateFormatter()

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
                let description = "Failed to parse the classifier's date."
                let userInfo = [NSLocalizedDescriptionKey: description]
                let error = NSError(domain: self.domain, code: 0, userInfo: userInfo)
                failure?(error)
                return
            }

            // download the latest model if a newer version is available
            if classifierDate > modelDate && classifier.coreMLStatus == "ready" {
                self.downloadClassifier(classifierID: classifierID, failure: failure, success: success)
            } else {
                success?(model);
            }
        }
    }

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
        let downloadedModelURL = applicationSupport.appendingPathComponent(classifierID + ".mlmodelc")
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
    private func convert(results: [(MLModel, [VNClassificationObservation])]) throws -> ClassifiedImages {
        var classifiers = [[String: Any]]()
        for (model, observations) in results {
            let observations = observations.filter() { $0.confidence > 0.01 }
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
     Download a CoreML model to the local file system.

     - parameter classifierID: The classifierID of the requested model.
     - parameter failure: A function executed if an error occurs.
     - parameter success: A function executed with the local Core ML model.
     */
    private func downloadClassifier(
        classifierID: String,
        failure: ((Error) -> Void)? = nil,
        success: ((MLModel) -> Void)? = nil)
    {
        // construct query parameters
        var queryParameters = [URLQueryItem]()
        queryParameters.append(URLQueryItem(name: "api_key", value: apiKey))
        queryParameters.append(URLQueryItem(name: "version", value: version))

        // construct header parameters for test server
        // TODO: remove before release
        var headerParameters = defaultHeaders
        headerParameters["X-API-Key"] = apiKeyTestServer

        // construct REST request
        // TODO: remove test server url and headers before release
        let request = RestRequest(
            method: "GET",
            url: "http://solution-kit-dev.mybluemix.net/api/v1.0/classifiers/\(classifierID)/model", // serviceURL + "/v3/classifiers/\(classifierID)/core_ml_model"
            credentials: .apiKey,
            headerParameters: headerParameters, // defaultHeaders,
            queryItems: queryParameters
        )

        // locate downloads directory
        let fileManager = FileManager.default
        let downloadDirectories = fileManager.urls(for: .downloadsDirectory, in: .userDomainMask)
        guard let downloads = downloadDirectories.first else {
            let description = "Cannot locate downloads directory."
            let userInfo = [NSLocalizedDescriptionKey: description]
            let error = NSError(domain: self.domain, code: 0, userInfo: userInfo)
            failure?(error)
            return
        }

        // locate application support directory
        let applicationSupportDirectories = fileManager.urls(for: .applicationSupportDirectory, in: .userDomainMask)
        guard let applicationSupport = applicationSupportDirectories.first else {
            let description = "Failed to locate application support directory."
            let userInfo = [NSLocalizedDescriptionKey: description]
            let error = NSError(domain: self.domain, code: 0, userInfo: userInfo)
            failure?(error)
            return
        }

        // specify file destinations
        let sourceModelURL = downloads.appendingPathComponent(classifierID + ".mlmodel")
        var compiledModelURL = applicationSupport.appendingPathComponent(classifierID + ".mlmodelc")

        // execute REST request
        request.download(to: sourceModelURL) { response, error in
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
                let description = "Could not compile Core ML model from source: \(error)"
                let userInfo = [NSLocalizedDescriptionKey: description]
                let error = NSError(domain: self.domain, code: 0, userInfo: userInfo)
                failure?(error)
                return
            }

            // move compiled model and clean up files
            do {
                if fileManager.fileExists(atPath: compiledModelURL.absoluteString) {
                    try fileManager.removeItem(at: compiledModelURL)
                }
                try fileManager.copyItem(at: compiledModelTemporaryURL, to: compiledModelURL)
                try fileManager.removeItem(at: compiledModelTemporaryURL)
                try fileManager.removeItem(at: sourceModelURL)
            } catch {
                let description = "Failed to move compiled model and clean up files: \(error)"
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

            // load model from disk
            guard let model = try? MLModel(contentsOf: compiledModelURL) else {
                let description = "Failed to load model from disk."
                let userInfo = [NSLocalizedDescriptionKey: description]
                let error = NSError(domain: self.domain, code: 0, userInfo: userInfo)
                failure?(error)
                return
            }

            success?(model)
        }
    }
}
