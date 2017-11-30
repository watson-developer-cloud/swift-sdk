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


@available(iOS 11.0, *)
extension VisualRecognition {
    
    /**
     Classify an image with CoreML, given a passed model. On failure or low confidence, fallback to Watson VR cloud service
     
     - parameter image: The image as NSData
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
        image: Data,
        owners: [String]? = nil,
        classifierIDs: [String]? = nil,
        threshold: Double? = nil,
        language: String? = nil,
        failure: ((Error) -> Void)? = nil,
        success: @escaping (ClassifiedImages) -> Void)
    {
        // handle multiple local classifiers
        var allResults: [[String: Any]] = []
        var allRequests: [VNCoreMLRequest] = []
        let dispatchGroup = DispatchGroup()
        
        // default classifier if not specified
        let classifierIDs = classifierIDs ?? ["default"]
        
        // setup requests for each classifier id
        for cid in classifierIDs {
            
            // get model if available
            guard let model = getCoreMLModelLocally(classifierID: cid) else {
                continue
            }
            
            // cast to vision model
            guard let vrModel = try? VNCoreMLModel(for: model) else {
                print("Could not convert MLModel to VNCoreMLModel")
                continue
            }

            dispatchGroup.enter()
            
            // define classifier specific request and callback
            let req = VNCoreMLRequest(model: vrModel, completionHandler: {
                (request, error) in
                
                // get coreml results
                guard let res = request.results else {
                    print( "Unable to classify image.\n\(error!.localizedDescription)" )
                    dispatchGroup.leave()
                    return
                }
                var classifications = res as! [VNClassificationObservation]
                classifications = classifications.filter({$0.confidence > 0.01}) // filter out very low confidence
                
                // parse scores to form class models
                var scores = [[String: Any]]()
                for c in classifications {
                    let tempScore: [String: Any] = [
                        "class" : c.identifier,
                        "score" : Double( c.confidence )
                    ]
                    scores.append(tempScore)
                }
                
                // form classifier model
                let tempClassifier: [String: Any] = [
                    "name": "coreml",
                    "classifier_id": "",
                    "classes" : scores
                ]
                allResults.append(tempClassifier)
                
                dispatchGroup.leave()
            })
            
            req.imageCropAndScaleOption = .scaleFill // This seems wrong, but yields results in line with vision demo
            
            allRequests.append(req)
        }

        // do requests with handler in background
        for req in allRequests {
            DispatchQueue.global(qos: .userInitiated).async {
                let handler = VNImageRequestHandler(data: image)
                do {
                    try handler.perform([req])
                } catch {
                    print("Failed to perform classification.\n\(error.localizedDescription)")
                }
            }
        }

        // wait until all classifiers have returned
        dispatchGroup.notify(queue: DispatchQueue.main, execute: {
            
            // form image model
            let bodyIm: [String: Any] = [
                "source_url" : "",
                "resolved_url" : "",
                "image": "",
                "error": "",
                "classifiers": allResults
            ]
            
            // form overall results model
            let body: [String: Any] = [
                "images": [bodyIm],
                "warning": []
            ]
            
            // convert results to sdk vision models
            do {
                let converted = try ClassifiedImages( json: JSONWrapper(dictionary: body) )
                success( converted )
                return
            } catch {
                failure?( error )
                return
            }
        })
    }
    
    /**
     Update the local CoreML model by pulling down the latest available version from the IBM cloud.
     
     - parameter classifierID: The classifier id to update
     - parameter apiKey: TEMPORARY param needed to access solution kit server
     - parameter failure: A function executed if an error occurs.
     - parameter success: A function executed with the image classifications.
     */
    public func updateCoreMLModelLocally(
        classifierID: String,
        apiKey: String,
        failure: ((Error) -> Void)? = nil,
        success: (() -> Void)? = nil)
    {
        // setup urls and filepaths
        let baseUrl = "http://solution-kit-dev.mybluemix.net/api/v1.0/classifiers/"
        let urlString = baseUrl + classifierID + "/model"
        let modelFileName = classifierID + ".mlmodelc"
        let tempFileName = "temp_" + UUID().uuidString + ".mlmodel"
        guard let appSupportDir = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first else {
            print("Could not get application support directory")
            return
        }
        let tempPath = appSupportDir.appendingPathComponent(tempFileName)
        let modelPath = appSupportDir.appendingPathComponent(modelFileName)

        // setup request
        guard let requestUrl = URL(string: urlString) else { return }
        var request = URLRequest(url:requestUrl)
        request.setValue(apiKey, forHTTPHeaderField: "X-API-Key")
        
        let task = URLSession.shared.dataTask(with: request) {
            (data, response, error) in
            
            if let error = error {
                print(error)
                failure?(error)
                return
            }
            
            guard let usableData = data  else {
                print("No usable data in response")
                return
            }
            
            // store model spec to temp location
            try? FileManager.default.removeItem(at: tempPath)
            let saveSuccess = FileManager.default.createFile(atPath: tempPath.path, contents: usableData, attributes: nil)
            print("New model spec was saved to file: \(saveSuccess)")
            
            // compile spec and write to final location
            guard let compiledPath = try? MLModel.compileModel(at: tempPath) else {
                print("Error compiling new model")
                return
            }
            try? FileManager.default.removeItem(at: modelPath)
            try? FileManager.default.copyItem(at: compiledPath, to: modelPath)
            print("new Model compiled for classifier: " + classifierID)
            
            // cleanup
            try? FileManager.default.removeItem(at: tempPath)
            
            success?()
        }
        task.resume()
    }
    
    /**
     Access the local CoreML model if available in filesystem.
     
     - parameter classifierID: The classifier id to update
     - parameter failure: A function executed if an error occurs. (Needed?)
     - parameter success: A function executed with the image classifications. (Needed?)
     */
    public func getCoreMLModelLocally(
        classifierID: String)
        -> MLModel?
    {
        // form expected path to model
        let modelFileName = classifierID + ".mlmodelc"
        guard let appSupportDir = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first else {
            print("Could not get application support directory")
            return nil
        }
        let modelPath = appSupportDir.appendingPathComponent(modelFileName)
        
        // check if available
        if !FileManager.default.fileExists(atPath: modelPath.path) {
            print("No model available for classifier: " + classifierID)
            return nil
        }
        
        // load and return
        guard let model = try? MLModel(contentsOf: modelPath) else {
            print("Could not create CoreML Model")
            return nil
        }
        
        return model
    }

}
