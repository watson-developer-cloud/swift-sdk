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
import ObjectMapper

public class NaturalLanguageClassifier : Service {
    
    public init() {
        super.init(serviceURL:NLCConstants.serviceURL)
    }
    
    /**
     Retrieves the list of classifiers for the service instance. Returns an empty array if no classifiers are available.
     
     - parameter completionHandler: Callback with [Classifier]?
     */
    public func getClassifiers(completionHandler: ([Classifier]?, NSError?)->()) {
        let endpoint = getEndpoint(NLCConstants.v1ClassifiersURI)
        
        NetworkUtils.performBasicAuthRequest(endpoint, apiKey: _apiKey, completionHandler: {response in
            var classifiers : [Classifier] = []
            
            if case let data as Dictionary<String,AnyObject> = response.data {
                if case let rawClassifiers as [AnyObject] = data[NLCConstants.classifiers] {
                    for rawClassifier in rawClassifiers {
                        if let classifier = Mapper<Classifier>().map(rawClassifier) {
                            classifiers.append(classifier)
                        }
                    }
                }
            }
            completionHandler(classifiers, response.error)
        })
    }
    
    /**
     Returns label information for the input. The status must be "Available" before you can classify calls
     
     - parameter classifierId:      Classifier ID to use
     - parameter text:              Phrase to classify
     - parameter completionHandler: Callback with Classification?
     */
    public func classify(classifierId: String, text: String, completionHandler: (Classification?, NSError?)->()) {
        
        let endpoint = getEndpoint("\(NLCConstants.v1ClassifiersURI)/\(classifierId)/classify")
        
        var errorDescription = ""
        guard (!classifierId.isEmpty) else {
            errorDescription = "ClassifierId input is empty"
            Log.sharedLogger.error("\(errorDescription)")
            let error = NSError.createWatsonError(400, description: errorDescription)
            completionHandler(nil, error)
            return
        }
        guard (!text.isEmpty) else {
            errorDescription = "Text input is empty"
            Log.sharedLogger.error("\(errorDescription)")
            let error = NSError.createWatsonError(400, description: errorDescription)
            completionHandler(nil, error)
            return
        }
        
        var params = Dictionary<String, AnyObject>()
        params.updateValue(text, forKey: "text")
        
        NetworkUtils.performBasicAuthRequest(endpoint, method: .GET, parameters: params, apiKey: _apiKey, completionHandler: {response in
            var classification:Classification? = nil
            if case let data as Dictionary<String,AnyObject> = response.data {
                classification = Mapper<Classification>().map(data)
            }
            completionHandler(classification, response.error)
        })
    }
    
    /**
     Returns the status of a classifier
     
     - parameter classifierId:      The classifer ID used to retrieve the classifier
     - parameter completionHandler: Callback with Classifer?
     */
    public func getClassifier( classifierId: String, completionHandler: (Classifier?, NSError?)->()) {
        let endpoint = getEndpoint("\(NLCConstants.v1ClassifiersURI)/\(classifierId)")
        
        NetworkUtils.performBasicAuthRequest(endpoint, method: .GET, parameters: [:], apiKey: _apiKey, completionHandler: {response in
            var classifier:Classifier? = nil
            if case let data as Dictionary<String,AnyObject> = response.data {
                classifier = Mapper<Classifier>().map(data)
            }
            completionHandler(classifier, response.error)
        })
    }
    
    /**
     Deletes the classifier with the classifierId
     
     - parameter classifierId:      The classifer ID used to delete the classifier
     - parameter completionHandler: Bool return with true as success
     */
    public func deleteClassifier(classifierId: String, completionHandler: (Bool)->()) {
        let endpoint = getEndpoint("\(NLCConstants.v1ClassifiersURI)/\(classifierId)")
        
        NetworkUtils.performBasicAuthRequest(endpoint, method: .DELETE, parameters: [:], apiKey: _apiKey, completionHandler: {response in
            completionHandler(response.code == 200)
        })
    }
    
    /**
     Sends data to create and train a classifier and returns information about the new classifier. When the operation is successful,
     the status of the classifier is set to "Training". The status must be "Available" before you can use the classifier.
     
     - parameter name:              The classifier name
     - parameter language:          IETF primary language for the classifier
     - parameter trainerURL:        The set of questions and their "keys" used to adapt a system to a domain (the ground truth)
     - parameter completionHandler: Callback with Classifier?
     */
    public func createClassifier(trainerMetaURL: NSURL, trainerURL: NSURL, completionHandler: (classifier: Classifier?, error: NSError?)->()) {
        let endpoint = getEndpoint(NLCConstants.v1ClassifiersURI)
        
        var params = Dictionary<String, NSURL>()
        
        params.updateValue(trainerMetaURL, forKey: NLCConstants.TrainerProperty.TrainingMeta.rawValue)
        params.updateValue(trainerURL, forKey: NLCConstants.TrainerProperty.TrainingData.rawValue)
        
        NetworkUtils.performBasicAuthFileUploadMultiPart(endpoint, fileURLs: params, parameters: [:], apiKey: _apiKey, contentType: ContentType.JSON, accept: ContentType.JSON, completionHandler: {response in
            var classifier:Classifier? = nil
            if let mapClassifier = Mapper<Classifier>().map(response.data) {
                classifier = mapClassifier
            }
            completionHandler(classifier: classifier, error: response.error)
        })
    }
}
