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
    public func classifyLocally(
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
        for classifierId in classifierIDs {
            dispatchGroup.enter()

            // get classifier model
            guard let modelURL = getCoreMLModelLocally(classifierID: classifierId) else {
                dispatchGroup.leave()
                let description = "Failed to get the Core ML model for classifier \(classifierId)"
                let userInfo = [NSLocalizedDescriptionKey: description]
                let error = NSError(domain: self.domain, code: 0, userInfo: userInfo)
                failure?(error)
                continue
            }

            guard let model = try? MLModel(contentsOf: modelURL) else {
                let description = "Could not create local CoreML model."
                let userInfo = [NSLocalizedDescriptionKey: description]
                let error = NSError(domain: self.domain, code: 0, userInfo: userInfo)
                failure?(error)
                return
            }

            // convert MLModel to VNCoreMLModel
            guard let classifier = try? VNCoreMLModel(for: model) else {
                dispatchGroup.leave()
                let description = "Could not convert MLModel to VNCoreMLModel for classifier \(classifierId)"
                let userInfo = [NSLocalizedDescriptionKey: description]
                let error = NSError(domain: self.domain, code: 0, userInfo: userInfo)
                failure?(error)
                continue
            }
            
            // construct classification request
            let request = VNCoreMLRequest(model: classifier) { request, error in
                guard error == nil else {
                    dispatchGroup.leave()
                    let description = "Classifier \(classifierId) failed with error: \(error!)"
                    let userInfo = [NSLocalizedDescriptionKey: description]
                    let error = NSError(domain: self.domain, code: 0, userInfo: userInfo)
                    failure?(error)
                    return
                }
                guard let observations = request.results as? [VNClassificationObservation] else {
                    dispatchGroup.leave()
                    let description = "Failed to parse results for classifier \(classifierId)"
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
     Update the local CoreML model by pulling down the latest available version from the IBM cloud.
     
     - parameter classifierID: The classifier id to update
     - parameter failure: A function executed if an error occurs.
     - parameter success: A function executed with the image classifications.
     */
    public func updateCoreMLModelLocally(
        classifierID: String,
        failure: ((Error) -> Void)? = nil,
        success: @escaping (URL) -> Void)
    {
        // setup date formatter '2017-12-04T19:44:27.419Z'
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSXXXXX"
        let dateFormatter = ISO8601DateFormatter()

        // get local model details
        guard let modelURL = getCoreMLModelLocally(classifierID: classifierID) else {
            // model does not exist, download the CoreML model
            self.downloadClassifier(classifierId: classifierID, failure: failure, success: success)
            return
        }

        // load model file from disk
        guard let coreMLModel = try? MLModel(contentsOf: modelURL) else {
            let description = "Could not create local CoreML model."
            let userInfo = [NSLocalizedDescriptionKey: description]
            let error = NSError(domain: self.domain, code: 0, userInfo: userInfo)
            failure?(error)
            return
        }

        let description = coreMLModel.modelDescription
        let metadata = description.metadata[MLModelMetadataKey.creatorDefinedKey] as? [String: String] ?? [:]

        guard let updated = metadata["updated"] else {
            let description = "Could not retrieve updated field from the local CoreML model."
            let userInfo = [NSLocalizedDescriptionKey: description]
            let error = NSError(domain: self.domain, code: 0, userInfo: userInfo)
            failure?(error)
            return
        }
        // get updated date for local model
        guard let coreMLModelUpdatedDate = dateFormatter.date(from: updated) else {
            let description = "Could not parse CoreML model's updated date."
            let userInfo = [NSLocalizedDescriptionKey: description]
            let error = NSError(domain: self.domain, code: 0, userInfo: userInfo)
            failure?(error)
            return
        }

        // get classifier details
        getClassifier(withID: classifierID, failure: failure) { classifier in
            // get updated date for classifier
            guard let classifierUpdateDate = dateFormatter.date(from: classifier.updated) else {
                let description = "Could not parse classifier's updated date."
                let userInfo = [NSLocalizedDescriptionKey: description]
                let error = NSError(domain: self.domain, code: 0, userInfo: userInfo)
                failure?(error)
                return
            }

            // compare local model updated date with classifier updated date
            if coreMLModelUpdatedDate < classifierUpdateDate {
                // download the most recent classifier
                self.downloadClassifier(classifierId: classifierID, failure: failure, success: success)
            } else {
                success(modelURL);
            }
        }
    }
    
    /**
     Retrieve a Core ML model that was downloaded to the local filesystem.
     
     - parameter classifierID: The classifier ID of the model to retrieve.
     - returns: The Core ML model of the given classifier, or `nil` if the model has not yet been downloaded.
     */
    public func getCoreMLModelLocally(classifierID: String) -> URL? {

        // locate application support directory
        guard let applicationSupport = try? getApplicationSupportDirectory() else {
            return nil
        }

        // construct model file path
        let modelURL = applicationSupport.appendingPathComponent(classifierID + ".mlmodelc")

        // ensure the model file exists
        guard FileManager.default.fileExists(atPath: modelURL.path) else {
            return nil
        }

        return modelURL
    }

    /**
     Downloads a CoreML model to the local file system.

     - parameter classifierId: The classifierId of the requested model.
     - parameter failure: A function executed if an error occurs.
     - parameter success: A function executed with the URL of the compiled CoreML model.
     */
    func downloadClassifier(
        classifierId: String,
        failure: ((Error) -> Void)? = nil,
        success: @escaping (URL) -> Void)
    {
        // construct query parameters
        var queryParameters = [URLQueryItem]()
        queryParameters.append(URLQueryItem(name: "api_key", value: apiKey))
        queryParameters.append(URLQueryItem(name: "version", value: version))

        // construct REST request
        let request = RestRequest(
            method: "GET",
            url: serviceURL + "/v3/classifiers/\(classifierId)/core_ml_model",
            credentials: .apiKey,
            headerParameters: defaultHeaders,
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
        let applicationSupport: URL
        do {
            applicationSupport = try getApplicationSupportDirectory()
        } catch {
            failure?(error)
            return
        }

        // specify file destinations
        let sourceModelURL = downloads.appendingPathComponent(classifierId + ".mlmodel")
        var compiledModelURL = applicationSupport.appendingPathComponent(classifierId + ".mlmodelc")

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

            success(compiledModelURL)
        }
    }

    /// List the CoreML models usable for classification.
    func listCoreMLModels() throws -> [String: URL] {
        var coreMLModels = [String: URL]()

        // locate application support directory
        let applicationSupport = try getApplicationSupportDirectory()

        // locate compiled CoreML models the user added into their app
        if let bundleCoreMLModels = Bundle.main.urls(forResourcesWithExtension: "mlmodelc", subdirectory: nil) {
            for url in bundleCoreMLModels {
                let path = url.path
                let classifierId = String(path.split(separator: ".")[0])
                coreMLModels[classifierId] = url
            }
        }

        // find all CoreML model paths
        let filePaths = try FileManager.default.contentsOfDirectory(atPath: applicationSupport.path)  // See if this returns full path
        let coreMLModelFilePaths = filePaths.filter{$0.contains(".mlmodelc")}

        // convert to URLs
        for coreMLModelFilePath in coreMLModelFilePaths {
            let classifierId = String(coreMLModelFilePath.split(separator: ".")[0])
            let url = URL(string: coreMLModelFilePath)!
            coreMLModels[classifierId] = url
        }

        return coreMLModels
    }

    /// Deletes a CoreML model from the file system.
    func deleteCoreMLModel(classifierId: String) throws {
        if let url = getCoreMLModelLocally(classifierID: classifierId) {
            do {
                try FileManager.default.removeItem(at: url)
            } catch {
                let description = "Could not delete specified CoreML model: \(error)"
                let userInfo = [NSLocalizedDescriptionKey: description]
                let error = NSError(domain: self.domain, code: 0, userInfo: userInfo)
                throw error
            }
        }
    }

    /// Gets the application support directory.
    func getApplicationSupportDirectory() throws -> URL
    {
        // Locate application support directory
        let fileManager = FileManager.default
        let applicationSupportDirectories = fileManager.urls(for: .applicationSupportDirectory, in: .userDomainMask)
        guard let applicationSupport = applicationSupportDirectories.first else {
            let description: String = "Could not get application support directory."
            let userInfo = [NSLocalizedDescriptionKey: description]
            let error = NSError(domain: self.domain, code: 0, userInfo: userInfo)
            throw error
        }

        return applicationSupport
    }


}
