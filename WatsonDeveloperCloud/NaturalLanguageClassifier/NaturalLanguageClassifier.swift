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
import ObjectMapper

/// The IBM Watson™ Natural Language Classifier service uses machine learning algorithms to return the top matching predefined classes for short text inputs.
public class NaturalLanguageClassifier: WatsonService {
    
    // The shared WatsonGateway singleton.
    let gateway = WatsonGateway.sharedInstance
    
    // The authentication strategy to obtain authorization tokens.
    var authStrategy: AuthenticationStrategy
    
    public required init(authStrategy: AuthenticationStrategy) {
        self.authStrategy = authStrategy
    }
    
    public convenience required init(username: String, password: String) {
        let authStrategy = BasicAuthenticationStrategy(tokenURL: Constants.tokenURL,
            serviceURL: Constants.serviceURL, username: username, password: password)
        self.init(authStrategy: authStrategy)
    }
    
    /**
     Retrieves the list of classifiers for the service instance. Returns an empty array
     if no classifiers are available.
     
     - parameter completionHandler: Callback with [Classifier]?
     */
    public func getClassifiers(completionHandler: ([Classifier]?, NSError?) -> Void) {
        
        // construct request
        let request = WatsonRequest(
            method: .GET,
            serviceURL: Constants.serviceURL,
            endpoint: Constants.classifiers,
            authStrategy: authStrategy,
            accept: .JSON)
        
        // execute request
        gateway.request(request, serviceError: NLCError()) { data, error in
            let classifiers = Mapper<Classifier>().mapDataArray(data, keyPath: "classifiers")
            completionHandler(classifiers, error)
        }
    }
    
    /**
     Returns label information for the input. The status must be "Available" before
     you can classify calls.
     
     - parameter classifierId:      Classifier ID to use
     - parameter text:              Phrase to classify
     - parameter completionHandler: Callback with Classification?
     */
    public func classify(classifierId: String, text: String,
        completionHandler: (Classification?, NSError?) -> Void) {
        
        // construct request
        let request = WatsonRequest(
            method: .GET,
            serviceURL: Constants.serviceURL,
            endpoint: Constants.classify(classifierId),
            authStrategy: authStrategy,
            accept: .JSON,
            urlParams: [NSURLQueryItem(name: "text", value: text)])
            
        // execute request
        gateway.request(request, serviceError: NLCError()) { data, error in
            let classification = Mapper<Classification>().mapData(data)
            completionHandler(classification, error)
        }
    }
    
    /**
     Returns the status of a classifier
     
     - parameter classifierId:      The classifer ID used to retrieve the classifier
     - parameter completionHandler: Callback with Classifer?
     */
    public func getClassifier(classifierId: String,
        completionHandler: (Classifier?, NSError?) -> Void) {
            
        // construct request
        let request = WatsonRequest(
            method: .GET,
            serviceURL: Constants.serviceURL,
            endpoint: Constants.classifier(classifierId),
            authStrategy: authStrategy,
            accept: .JSON)
        
        // execute request
        gateway.request(request, serviceError: NLCError()) { data, error in
            let classifier = Mapper<Classifier>().mapData(data)
            completionHandler(classifier, error)
        }
    }
    
    /**
     Deletes the classifier with the classifierId
     
     - parameter classifierId:      The classifer ID used to delete the classifier
     - parameter completionHandler: Bool return with true as success
     */
    public func deleteClassifier(classifierId: String, completionHandler: NSError? -> Void) {
        
        // construct request
        let request = WatsonRequest(
            method: .DELETE,
            serviceURL: Constants.serviceURL,
            endpoint: Constants.classifier(classifierId),
            authStrategy: authStrategy)
        
        // execute request
        gateway.request(request, serviceError: NLCError()) { data, error in
            completionHandler(error)
        }
    }
    
    /**
     Sends data to create and train a classifier and returns information about the new
     classifier. When the operation is successful, the status of the classifier is set
     to "Training". The status must be "Available" before you can use the classifier.
     
     - parameter name:              The classifier name
     - parameter language:          IETF primary language for the classifier
     - parameter trainerURL:        The set of questions and their "keys" used to adapt a
                                        system to a domain (the ground truth)
     - parameter completionHandler: Callback with Classifier?
     */
    public func createClassifier(trainerMetaURL: NSURL, trainerURL: NSURL,
        completionHandler: (Classifier?, NSError?) -> Void) {
        
        // force token to refresh
        // TODO: can remove this after its handled by WatsonGateway
        authStrategy.refreshToken() { error in
        
            // add token to header params
            // TODO: can remove this after its handled by WatsonGateway
            var headerParams = [String: String]()
            if let token = self.authStrategy.token {
                headerParams["X-Watson-Authorization-Token"] = token
            }
                
            // construct request
            let request = WatsonRequest(
                method: .POST,
                serviceURL: Constants.serviceURL,
                endpoint: Constants.classifiers,
                authStrategy: self.authStrategy,
                accept: .JSON,
                headerParams: headerParams)
            
            // execute request
            Alamofire.upload(request,
                multipartFormData: { multipartFormData in
                    // encode files as form data
                    multipartFormData.appendBodyPart(fileURL: trainerMetaURL, name: "training_metadata")
                    multipartFormData.appendBodyPart(fileURL:
                        trainerURL, name: "training_data")
                },
                encodingCompletion: { encodingResult in
                    switch encodingResult {
                    case .Success(let upload, _, _):
                        // execute encoded request
                        upload.responseObject {
                            (response: Response<Classifier, NSError>) in
                            validate(response, serviceError: NLCError(),
                                completionHandler: completionHandler)
                        }
                    case .Failure:
                        // construct and return error
                        let nsError = NSError(
                            domain: "com.alamofire.error",
                            code: -6008,
                            userInfo: [NSLocalizedDescriptionKey:
                                "Unable to encode data as multipart form."])
                        completionHandler(nil, nsError)
                    }
                })
        }
    }
}
