/**
 * (C) Copyright IBM Corp. 2016, 2019.
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
import IBMSwiftSDKCore

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
     - parameter completionHandler: A function executed when the request completes with a successful result or error.
       If both the response and error are `nil`, then the Core ML model already exists locally.
     */
    public func updateLocalModel(
        classifierID: String,
        completionHandler: @escaping (WatsonResponse<Classifier>?, WatsonError?) -> Void) {
        // setup date formatter '2017-12-04T19:44:27.419Z'
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"

        // load model from disk
        guard let model = try? loadModelFromDisk(classifierID: classifierID) else {
            downloadClassifier(classifierID: classifierID, completionHandler: completionHandler)
            return
        }

        // parse the date on which the local model was last updated
        let description = model.modelDescription
        let metadata = description.metadata[MLModelMetadataKey.creatorDefinedKey] as? [String: String] ?? [:]
        guard let updated = metadata["retrained"] ?? metadata["created"], let modelDate = dateFormatter.date(from: updated) else {
            downloadClassifier(classifierID: classifierID, completionHandler: completionHandler)
            return
        }

        // parse the date on which the classifier was last updated
        getClassifier(classifierID: classifierID) { response, error in
            guard let classifier = response?.result else {
                completionHandler(nil, error)
                return
            }
            guard let classifierDate = classifier.retrained ?? classifier.created else {
                self.downloadClassifier(classifierID: classifierID, completionHandler: completionHandler)
                return
            }

            // download the latest model if a newer version is available
            if classifierDate > modelDate && classifier.status == "ready" {
                self.downloadClassifier(classifierID: classifierID, completionHandler: completionHandler)
            } else {
                completionHandler(nil, nil)
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
     - parameter completionHandler: A function executed when the request completes with a successful result or error
     */
    public func classifyWithLocalModel(
        imageData: Data,
        classifierIDs: [String] = ["default"],
        threshold: Double? = nil,
        completionHandler: @escaping (ClassifiedImages?, WatsonError?) -> Void) {
        // ensure a classifier id was provided
        guard !classifierIDs.isEmpty else {
            let error = WatsonError.other(message: "Please provide at least one classifierID.", metadata: nil)
            completionHandler(nil, error)
            return
        }

        // construct and execute each classification request
        var results = [(MLModel, [VNClassificationObservation])]()
        var errors = [WatsonError]()
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
                    let error = WatsonError.other(message: "Failed to load model for classifier \(classifierID): \(error.localizedDescription)", metadata: nil)
                    errors.append(error)
                    dispatchGroup.leave()
                    return
                }

                // convert MLModel to VNCoreMLModel
                let classifier: VNCoreMLModel
                do {
                    classifier = try VNCoreMLModel(for: model)
                } catch {
                    let error = WatsonError.other(message: "Failed to convert model for classifier \(classifierID): \(error.localizedDescription)", metadata: nil)
                    errors.append(error)
                    dispatchGroup.leave()
                    return
                }

                // construct classification request
                let request = VNCoreMLRequest(model: classifier) { request, error in
                    defer { dispatchGroup.leave() }
                    if let error = error {
                        let error = WatsonError.other(message: "Classifier \(classifierID) failed with error: \(error)", metadata: nil)
                        errors.append(error)
                        return
                    }
                    guard let observations = request.results as? [VNClassificationObservation] else {
                        let error = WatsonError.other(message: "Failed to parse results for classifier \(classifierID)", metadata: nil)
                        errors.append(error)
                        return
                    }
                    results.append((model, observations))
                }

                // scale image (yields results in line with vision demo)
                request.imageCropAndScaleOption = .scaleFill

                // execute classification request
                do {
                    let requestHandler = VNImageRequestHandler(data: imageData)
                    try requestHandler.perform([request])
                } catch {
                    let error = WatsonError.other(message: "Failed to process classification request: \(error.localizedDescription)", metadata: nil)
                    errors.append(error)
                    dispatchGroup.leave()
                    return
                }
            }
        }

        // return results after all classification requests have executed
        dispatchGroup.notify(queue: DispatchQueue.global(qos: .userInitiated)) {
            let classifiedImages: ClassifiedImages?
            if !results.isEmpty {
                do {
                    classifiedImages = try self.convert(results: results, threshold: threshold)
                } catch {
                    let error = WatsonError.other(message: "Failed to represent results as JSON: \(error.localizedDescription)", metadata: nil)
                    completionHandler(nil, error)
                    return
                }
            } else {
                classifiedImages = nil
            }
            var error: WatsonError?
            if !errors.isEmpty {
                error = WatsonError.other(message: "Local classification failed: \(errors[0].localizedDescription)", metadata: nil)
            }
            completionHandler(classifiedImages, error)
        }
    }

    // MARK: - Private Helper Functions

    /**
     Locate a Core ML model on disk. The model must be named "[classifier-id].mlmodelc" and reside in the
     application support directory or main bundle.
     */
    internal func locateModelOnDisk(classifierID: String) throws -> URL {

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
        let error = WatsonError.other(message: "Failed to locate a Core ML model on disk for classifier \(classifierID).", metadata: nil)
        throw error
    }

    /**
     Load a Core ML model from disk. The model must be named "[classifier-id].mlmodelc" and reside in the
     application support directory or main bundle.
     */
    private func loadModelFromDisk(classifierID: String) throws -> MLModel {
        let modelURL = try locateModelOnDisk(classifierID: classifierID)

        // must build with Xcode 10 or later in order to use `MLModelConfiguration`.
        // use the version of Swift to infer the Xcode version since this can’t be checked explicitly.
        #if swift(>=4.1.50) || (swift(>=3.4) && !swift(>=4.0))
        // temporary workaround for compatibility issue with new A12 based devices
        if #available(iOS 12.0, *) {
            let modelConfig = MLModelConfiguration()
            modelConfig.computeUnits = .cpuAndGPU
            return try MLModel(contentsOf: modelURL, configuration: modelConfig)
        } else {
            return try MLModel(contentsOf: modelURL)
        }
        #else
        return try MLModel(contentsOf: modelURL)
        #endif
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
        guard let data = json.data(using: .utf8) else { throw WatsonError.serialization(values: "Core ML classification") }
        return try JSONDecoder().decode(ClassifiedImages.self, from: data)
    }

    // swiftlint:disable function_body_length

    /**
     Download a Core ML model to the local filesystem. The model is compiled and moved to the application support
     directory with a filename of `[classifier-id].mlmodelc`.

     - parameter classifierID: The classifierID of the model to download.
     - parameter completionHandler: A function executed when the request completes with a successful result or error.
       If both the response and error are `nil`, then the Core ML model already exists locally.
     */
    internal func downloadClassifier(
        classifierID: String,
        completionHandler: @escaping (WatsonResponse<Classifier>?, WatsonError?) -> Void) {
        // construct header parameters
        var headerParameters = defaultHeaders
        headerParameters["Accept"] = "application/octet-stream"

        // construct query parameters
        var queryParameters = [URLQueryItem]()
        queryParameters.append(URLQueryItem(name: "version", value: version))

        guard let serviceURL = serviceURL else {
            completionHandler(nil, WatsonError.noEndpoint)
            return
        }

        // construct REST request
        let request = RestRequest(
            session: session,
            authenticator: authenticator,
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
            let error = WatsonError.other(message: "Failed to create temporary downloads directory: \(error.localizedDescription)", metadata: nil)
            completionHandler(nil, error)
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
            let error = WatsonError.other(message: "Failed to locate application support directory: \(error.localizedDescription)", metadata: nil)
            completionHandler(nil, error)
            return
        }

        // specify file destinations
        let sourceModelURL = downloads.appendingPathComponent(classifierID + ".mlmodel", isDirectory: false)
        var compiledModelURL = appSupport.appendingPathComponent(classifierID + ".mlmodelc", isDirectory: false)

        // execute REST request
        request.download(to: sourceModelURL) { response, error in
            defer { try? fileManager.removeItem(at: sourceModelURL) }

            guard error == nil else {
                completionHandler(nil, error)
                return
            }

            guard let statusCode = response?.statusCode else {
                let error = WatsonError.noResponse
                completionHandler(nil, error)
                return
            }

            guard (200..<300).contains(statusCode) else {
                let error = WatsonError.http(statusCode: statusCode, message: nil, metadata: nil)
                completionHandler(nil, error)
                return
            }

            // compile model from source
            var compiledModelTemporaryURL: URL
            do {
                compiledModelTemporaryURL = try MLModel.compileModel(at: sourceModelURL)
            } catch {
                let error = WatsonError.other(message: "Could not compile Core ML model from source: \(error.localizedDescription)", metadata: nil)
                completionHandler(nil, error)
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
                let error = WatsonError.other(message: "Failed to move compiled model: \(error.localizedDescription)", metadata: nil)
                completionHandler(nil, error)
                return
            }

            // exclude compiled model from device backups
            var urlResourceValues = URLResourceValues()
            urlResourceValues.isExcludedFromBackup = true
            do {
                try compiledModelURL.setResourceValues(urlResourceValues)
            } catch {
                let error = WatsonError.other(message: "Could not exclude compiled model from backup: \(error.localizedDescription)", metadata: nil)
                completionHandler(nil, error)
            }

            completionHandler(nil, nil)
        }
    }

    // swiftlint:enable function_body_length
}

#endif
