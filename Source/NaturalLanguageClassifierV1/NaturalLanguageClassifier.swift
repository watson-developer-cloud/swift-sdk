/**
 * Copyright IBM Corporation 2015
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
import Alamofire
import Freddy

public class NaturalLanguageClassifierV1 {
    
    private let username: String
    private let password: String
    
    private let domain = "com.ibm.watson.developer-cloud.WatsonDeveloperCloud"
    private let serviceURL = "https://gateway.watsonplatform.net/natural-language-classifier/api"
    
    public init(username: String, password: String) {
        self.username = username
        self.password = password
    }
    
    private func dataToError(data: NSData) -> NSError? {
        do {
            let json = try JSON(data: data)
            let error = try json.string("error")
            let code = try json.int("code")
            let description = try json.string("description")
            let userInfo = [
                NSLocalizedFailureReasonErrorKey: error,
                NSLocalizedRecoverySuggestionErrorKey: description
            ]
            return NSError(domain: domain, code: code, userInfo: userInfo)
        } catch {
            return nil
        }
    }
    
    /**
     Retrieves the list of classifiers for the service instance. Returns an empty array
     if no classifiers are available.
     
     - parameter failure: A function executed if an error occurs.
     - parameter success: A function executed with the list of available standard and custom models.
     */
    public func getClassifiers(
        failure: (NSError -> Void)? = nil,
        success: [ClassifierModel] -> Void) {
        
        // construct REST request
        let request = RestRequest(
            method: .GET,
            url: serviceURL + "/v1/classifiers",
            acceptType: "application/json"
        )
        
        // execute REST request
        Alamofire.request(request)
            .authenticate(user: username, password: password)
            .responseArray(dataToError: dataToError, path: ["classifiers"]) {
                (response: Response<[ClassifierModel], NSError>) in
                switch response.result {
                case .Success(let classifiers): success(classifiers)
                case .Failure(let error): failure?(error)
                }
        }
    }
    
    /**
     Sends data to create and train a classifier and returns information about the new
     classifier. When the operation is successful, the status of the classifier is set
     to "Training". The status must be "Available" before you can use the classifier.
     
     - parameter trainingMetadata:
     - parameter trainingData:      The set of questions and their "keys" used to adapt a system to a domain (the ground truth).
     - parameter failure: A function executed if an error occurs.
     - parameter success: A function executed with the list of available standard and custom models.
     */
    public func createClassifier(
        trainingMetadata: NSURL,
        trainingData: NSURL,
        failure: (NSError -> Void)? = nil,
        success: ClassifierDetails -> Void) {
        
        // construct REST request
        let request = RestRequest(
            method: .POST,
            url: serviceURL + "/v1/classifiers",
            acceptType: "application/json"
        )
        
        // execute REST request
        Alamofire.upload(request,
            multipartFormData: { multipartFormData in
                multipartFormData.appendBodyPart(fileURL: trainingMetadata, name: "training_metadata")
                multipartFormData.appendBodyPart(fileURL: trainingData, name: "training_data")
            },
            encodingCompletion: { encodingResult in
                switch encodingResult {
                case .Success(let upload, _, _):
                    upload.authenticate(user: self.username, password: self.password)
                    upload.responseObject(dataToError: self.dataToError) {
                        (response: Response<ClassifierDetails, NSError>) in
                        switch response.result {
                        case .Success(let classifierDetails): success(classifierDetails)
                        case .Failure(let error): failure?(error)
                        }
                    }
                case .Failure:
                    let failureReason = "Files could not be encoded as form data."
                    let userInfo = [NSLocalizedFailureReasonErrorKey: failureReason]
                    let error = NSError(domain: self.domain, code: 0, userInfo: userInfo)
                    failure?(error)
                    return
                }
            }
        )
    }
    
    /**
     Returns label information for the input. The status must be "Available" before
     you can classify calls.
     
     - parameter classifierId:      Classifier ID to use
     - parameter text:              Phrase to classify
     - parameter failure: A function executed if an error occurs.
     - parameter success: A function executed with the list of available standard and custom models.
     */
    public func classify(
        classifierId: String,
        text: String,
        failure: (NSError -> Void)? = nil,
        success: Classification -> Void) {
        
        // construct query parameters
        guard let body = try? ["text": text].toJSON().serialize() else {
            let failureReason = "Classification text could not be serialized to JSON."
            let userInfo = [NSLocalizedFailureReasonErrorKey: failureReason]
            let error = NSError(domain: domain, code: 0, userInfo: userInfo)
            failure?(error)
            return
        }
        
        // construct REST request
        let request = RestRequest(
            method: .POST,
            url: serviceURL + "/v1/classifiers/\(classifierId)/classify",
            acceptType: "application/json",
            contentType: "application/json",
            messageBody: body
        )
        
        // execute REST request
        Alamofire.request(request)
            .authenticate(user: username, password: password)
            .responseObject(dataToError: dataToError) {
                (response: Response<Classification, NSError>) in
                switch response.result {
                case .Success(let classification): success(classification)
                case .Failure(let error): failure?(error)
                }
            }
    }
    
    /**
     Deletes the classifier with the classifierId
     
     - parameter classifierId:      The classifer ID used to delete the classifier
     - parameter failure: A function executed if an error occurs.
     - parameter success: A function executed with the list of available standard and custom models.
     */
    public func deleteClassifier(
        classifierId: String,
        failure:(NSError -> Void)? = nil,
        success: (Void -> Void)? = nil) {
        
        // construct REST request
        let request = RestRequest(
            method: .DELETE,
            url: serviceURL + "/v1/classifiers/\(classifierId)",
            acceptType: "application/json"
        )
        
        // execute REST request
        Alamofire.request(request)
            .authenticate(user: username, password: password)
            .responseData { response in
                switch response.result {
                case .Success(let data):
                    switch self.dataToError(data) {
                    case .Some(let error): failure?(error)
                    case .None: success?()
                    }
                case .Failure(let error):
                    failure?(error)
                }
        }
    }

    /**
     Returns the status and other information about a classifier
     
     - parameter classifierId: The classifer ID used to retrieve the classifier
     - parameter failure: A function executed if an error occurs.
     - parameter success: A function executed with the list of available standard and custom models.
     */
    public func getClassifier(
        classifierId: String,
        failure: (NSError -> Void)? = nil,
        success: ClassifierDetails -> Void) {
        
        // construct REST request
        let request = RestRequest(
            method: .GET,
            url: serviceURL + "/v1/classifiers/\(classifierId)",
            acceptType: "application/json"
        )
        
        // execute REST request
        Alamofire.request(request).authenticate(user: username, password: password).responseObject(dataToError: dataToError) {
            (response: Response<ClassifierDetails, NSError>) in
            switch response.result {
            case .Success(let classifier): success(classifier)
            case .Failure(let error): failure?(error)
            }
        }
    }
}
