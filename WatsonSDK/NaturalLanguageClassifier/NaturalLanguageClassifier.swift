//
//  NaturalLanguageClassifier.swift
//  NaturalLanguageClassifier
//
//  Created by Vincent Herrin on 11/9/15.
//  Copyright © 2015 IBM. All rights reserved.
//

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
    public func getClassifiers(completionHandler: ([Classifier]?, error: NSError?)->()) {
        let endpoint = getEndpoint(NLCConstants.v1ClassifiersURI)
        
        NetworkUtils.performBasicAuthRequest(endpoint, apiKey: _apiKey, completionHandler: {response in
            var classifiers : [Classifier] = []
            
            if(response.code == 200) {
                if case let data as Dictionary<String,AnyObject> = response.data {
                    if case let rawClassifiers as [AnyObject] = data[NLCConstants.classifiers] {
                        for rawClassifier in rawClassifiers {
                            if let classifier = Mapper<Classifier>().map(rawClassifier) {
                                classifiers.append(classifier)
                            }
                        }
                    }
                }
                completionHandler(classifiers, error: nil)
            } else {
                completionHandler(nil, error: response.error)
            }
        })
    }
    
    /**
     Returns label information for the input. The status must be "Available" before you can classify calls
     
     - parameter classifierId:      Classifier ID to use
     - parameter text:              Phrase to classify
     - parameter completionHandler: Callback with Classification?
     */
    public func classify(classifierId: String, text: String, completionHandler: (classification: Classification?, error: NSError?)->()) {

        let endpoint = getEndpoint("\(NLCConstants.v1ClassifiersURI)/\(classifierId)/classify")
        
        var errorDescription = ""
        guard (!classifierId.isEmpty) else {
            errorDescription = "ClassifierId input is empty"
            Log.sharedLogger.error("\(errorDescription)")
            let error = NSError.createWatsonError(400, description: errorDescription)
            completionHandler(classification: nil, error: error)
            return
        }
        guard (!text.isEmpty) else {
            errorDescription = "Text input is empty"
            Log.sharedLogger.error("\(errorDescription)")
            let error = NSError.createWatsonError(400, description: errorDescription)
            completionHandler(classification: nil, error: error)
            return
        }
        
        var params = Dictionary<String, AnyObject>()
        params.updateValue(text, forKey: "text")
        
        NetworkUtils.performBasicAuthRequest(endpoint, method: .GET, parameters: params, apiKey: _apiKey, completionHandler: {response in
            if response.code == 200 {
                if case let data as Dictionary<String,AnyObject> = response.data {
                    completionHandler(classification: Mapper<Classification>().map(data), error: nil)
                    return
                }
            }
            Log.sharedLogger.warning("No classifier found with given ID")
            completionHandler(classification: nil, error: response.error)
        })
    }
    
    /**
     Returns the status of a classifier
     
     - parameter classifierId:      The classifer ID used to retrieve the classifier
     - parameter completionHandler: Callback with Classifer?
     */
    public func getClassifier( classifierId: String, completionHandler: (classifier: Classifier?, error: NSError?)->()) {
        let endpoint = getEndpoint("\(NLCConstants.v1ClassifiersURI)/\(classifierId)")
        
        NetworkUtils.performBasicAuthRequest(endpoint, method: .GET, parameters: [:], apiKey: _apiKey, completionHandler: {response in
            if response.code == 200 {
                if case let data as Dictionary<String,AnyObject> = response.data {
                    completionHandler(classifier: Mapper<Classifier>().map(data), error: nil)
                }
                else {
                    completionHandler(classifier: nil, error: response.error)
                }
            }
            else {
                Log.sharedLogger.warning("No classifier found with given ID")
                completionHandler(classifier: nil, error: response.error)
            }
        })
    }
    
    /**
     Deletes the classifier based on the classifiyID passed in
     
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
            if let classifier = Mapper<Classifier>().map(response.data) {
                if let _ = classifier.id {
                    completionHandler(classifier: classifier, error: response.error)
                    return
                }
            }
            completionHandler(classifier: nil, error: response.error)
        })
    }
}
