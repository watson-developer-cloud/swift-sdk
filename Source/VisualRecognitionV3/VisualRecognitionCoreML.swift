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


// Model abstraction class
@available(iOS 11.0, *)
public class VisualRecognitionCoreMLModel {
    
    var documentUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    public var model: VNCoreMLModel
    var modelPath: URL
    
    // TODO: want this to rely on url and classifier properties in vr service class
    let urlString = "http://localhost:5000/api/v1.0/classifiers/demo/model"
    let modelFileName = "watson_vision_model.mlmodel"
    
    public init(model: VNCoreMLModel) {
        self.model = model
        self.modelPath = self.documentUrl.appendingPathComponent( self.modelFileName )
    }
    
    private func compileModel(with newModelAddress: URL) {
        if let compiledAddress = try? MLModel.compileModel(at: newModelAddress) {
            self.replaceFile(at: self.modelPath, withFileAt: compiledAddress)
            do {
                let newModel = try MLModel(contentsOf: self.modelPath)
                self.model = try VNCoreMLModel(for: newModel)
                print("model swapped")
            } catch let error {
                print(error)
            }
        } else {
            print("Error compiling new model")
        }
    }
    
    public func getLatest(completionHandler: (() -> Void)? = nil) {

        guard let requestUrl = URL(string: self.urlString) else { return }
        let request = URLRequest(url:requestUrl)
        let task = URLSession.shared.dataTask(with: request) {
            (data, response, error) in
            if error == nil,let usableData = data {
                self.modelPath = self.documentUrl.appendingPathComponent( self.modelFileName )
                self.deleteFile(atPath: self.modelPath)
                let saveSuccess = FileManager.default.createFile(atPath: self.modelPath.path, contents: usableData, attributes: nil)
                print("Model file was saved: \(saveSuccess)")
                self.compileModel(with: self.modelPath)
                
            } else if let error = error {
                print(error)
            }
            if (completionHandler != nil) {
                completionHandler?()
            }
        }
        task.resume()
    }
    
    // Helper functions for storing newest mlmodel file
    private func replaceFile(at path: URL, withFileAt otherPath: URL) {
        do {
            deleteFile(atPath: path)
            try FileManager.default.copyItem(at: otherPath, to: path)
        }
        catch let error {
            print(error)
        }
    }
    
    private func deleteFile(atPath path: URL) {
        print("Trying to remove item at: " + path.absoluteString)
        do {
            try FileManager.default.removeItem(at: path)
            print("File removed")
        }
        catch let error {
            print("Failed to remove item")
            print(error)
        }
    }
}

@available(iOS 11.0, *)
extension VisualRecognition {
    
    /**
     Classify an image with CoreML, given a passed model. On failure or low confidence, fallback to Watson VR cloud service
     
     - parameter image: The image as NSData
     - parameter model: CoreML model
     - parameter localThreshold: minimum local score to return results immediately
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
    public func classify(
        image: Data,
        model: VNCoreMLModel,
        localThreshold: Double? = nil,
        owners: [String]? = nil,
        classifierIDs: [String]? = nil,
        threshold: Double? = nil,
        language: String? = nil,
        failure: ((Error) -> Void)? = nil,
        success: @escaping (ClassifiedImages) -> Void)
    {
        // short-circuit coreml if local thresh is 1.0
        if localThreshold == 1.0 {
            self.classify(image: image, owners: owners, classifierIDs:classifierIDs, threshold:threshold, language:language, failure:failure, success: success)
            return
        }
        
        print ( "trying local classification on CoreML..." )
        
        // setup request
        let request = VNCoreMLRequest(model: model, completionHandler: { (request, error) in
            // define coreml callback
            guard let results = request.results else {
                print( "Unable to classify image.\n\(error!.localizedDescription)" )
                return
            }
            // The `results` will always be `VNClassificationObservation`s, as specified by the Core ML model in this project.
            var classifications = results as! [VNClassificationObservation]
            
            if let thresh = localThreshold {
                classifications = classifications.filter({ $0.confidence > Float(thresh) })
            }
            
            if classifications.isEmpty {
                print( "Nothing recognized." )
            } else {
                // Display top classifications ranked by confidence in the UI.
                let topClassifications = classifications.prefix(20)
                
                // convert results to sdk vision models
                var scores = [[String: Any]]()
                for c in topClassifications {
                    let temp: [String: Any] = [
                        "class" : c.identifier,
                        "score" : Double( c.confidence )
                    ]
                    scores.append( temp )
                }
                
                let bodyClassifier: [String: Any] = [
                    "name": "coreml",
                    "classifier_id": "",
                    "classes" : scores
                ]
                
                let bodyIm: [String: Any] = [
                    "source_url" : "",
                    "resolved_url" : "",
                    "image": "",
                    "error": "",
                    "classifiers": [bodyClassifier]
                ]
                
                let body: [String: Any] = [
                    "images" : [bodyIm],
                    "warning" :[]
                ]
                
                do {
                    let converted = try ClassifiedImages( json: JSONWrapper(dictionary: body) )
                    success( converted )
                    return
                } catch {
                    print( error )
                }
            }
            
            // hit standard VR service as fallback
            self.classify(image: image, owners: owners, classifierIDs:classifierIDs, threshold:threshold, language:language, failure:failure, success: success)
            
        })
        request.imageCropAndScaleOption = .scaleFill // This seems wrong, but yields results in line with vision demo
        
        // do request with handler in background
        DispatchQueue.global(qos: .userInitiated).async {
            let handler = VNImageRequestHandler(data: image)
            do {
                try handler.perform([request])
            } catch {
                /*
                 This handler catches general image processing errors. The `classificationRequest`'s
                 completion handler `processClassifications(_:error:)` catches errors specific
                 to processing that request.
                 */
                print("Failed to perform classification.\n\(error.localizedDescription)")
            }
        }
    }
    
}
