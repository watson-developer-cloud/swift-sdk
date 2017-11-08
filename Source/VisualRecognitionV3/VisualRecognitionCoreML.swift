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
    
    public func getLatest() {

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
    // TODO -- proper extension here
}
