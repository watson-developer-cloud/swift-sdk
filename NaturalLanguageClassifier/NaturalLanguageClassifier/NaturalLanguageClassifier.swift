//
//  NaturalLanguageClassifier.swift
//  NaturalLanguageClassifier
//
//  Created by Vincent Herrin on 11/9/15.
//  Copyright © 2015 IBM. All rights reserved.
//

import Foundation
import WatsonCore
import ObjectMapper

public class NaturalLanguageClassifier : Service {
  
  public init() {
    super.init(serviceURL:NLCConstants.serviceURL)
  }
  
  /**
   Retrieves the list of classifiers for the service instance. Returns an empty array if no classifiers are available.
   
   - parameter completionHandler: Callback with [Classifier]?
   */
  public func getClassifiers(completionHandler: ([Classifier]?)->()) {
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
      completionHandler(classifiers)
    })
  }
  
  /**
   Returns label information for the input. The status must be "Available" before you can classify calls
   
   - parameter classifierId:      Classifier ID to use
   - parameter text:              Phrase to classify
   - parameter completionHandler: Callback with Classification?
   */
  public func classify(classifierId: String, text: String, completionHandler: (Classification?)->()) {
    let endpoint = getEndpoint("\(NLCConstants.v1ClassifiersURI)/\(classifierId)/classify")

    guard (classifierId.characters.count > 0) else {
      Log.sharedLogger.error("ClassifierId is empty")
      completionHandler(nil)
      return
    }
    guard (text.characters.count > 0) else {
      Log.sharedLogger.error("text input is empty")
      completionHandler(nil)
      return
    }
    
    var params = Dictionary<String, AnyObject>()
    params.updateValue(text, forKey: "text")
    
    NetworkUtils.performBasicAuthRequest(endpoint, method: .GET, parameters: params, apiKey: _apiKey, completionHandler: {response in
      if response.code == 200 {
        if case let data as Dictionary<String,AnyObject> = response.data {
          return completionHandler(Mapper<Classification>().map(data))
        }
      }
      Log.sharedLogger.warning("No classifier found with given ID")
      return completionHandler(nil)
    })
  }
  
  /**
   Returns the status of a classifier
   
   - parameter classifierId:      The classifer ID used to retrieve the classifier
   - parameter completionHandler: Callback with Classifer?
   */
  public func getClassifier( classifierId: String, completionHandler: (Classifier?)->()) {
    let endpoint = getEndpoint("\(NLCConstants.v1ClassifiersURI)/\(classifierId)")
    
    NetworkUtils.performBasicAuthRequest(endpoint, method: .GET, parameters: [:], apiKey: _apiKey, completionHandler: {response in
      if response.code == 200 {
        if case let data as Dictionary<String,AnyObject> = response.data {
          return completionHandler(Mapper<Classifier>().map(data))
        }
      }
      Log.sharedLogger.warning("No classifier found with given ID")
      return completionHandler(nil)
    })
  }
  
  public func deleteClassifier( classifierId: String, completionHandler: (Bool?)->()) {
    let endpoint = getEndpoint("\(NLCConstants.v1ClassifiersURI)/\(classifierId)")
    
    NetworkUtils.performBasicAuthRequest(endpoint, method: .DELETE, parameters: [:], apiKey: _apiKey, completionHandler: {response in
      return completionHandler(response.code == 200)
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
  public func createClassifier(name: String? = nil, language: String = "en", trainerURL: NSURL, completionHandler: (Classifier?)->()) {
    let endpoint = getEndpoint(NLCConstants.v1ClassifiersURI)
    
    var params = Dictionary<String, AnyObject>()
    var csv = Dictionary<String, String>()
    
    csv.updateValue(language, forKey: NLCConstants.TrainerProperty.Language.rawValue)
    
    if let name = name  {
      csv.updateValue(name, forKey: NLCConstants.TrainerProperty.Name.rawValue)
    }
    
    let training_metadata = JSONStringify(csv)
    Log.sharedLogger.debug(training_metadata)
    
    //TODO: Add guard
    params.updateValue(training_metadata, forKey: NLCConstants.TrainerProperty.TrainingMeta.rawValue)
    
    NetworkUtils.performBasicAuthFileUpload(endpoint, fileURL: trainerURL, parameters: params, apiKey: _apiKey, completionHandler: {response in
      completionHandler(Mapper<Classifier>().map(response.data))
    })
    // completionHandler(nil)
  }
  
  /**
   Function that turns JSON into a string
   
   - parameter value:         Object to convert to Strig
   - parameter prettyPrinted: Pretty the print of the string
   
   - returns: String
   */
  private func JSONStringify(value: AnyObject,prettyPrinted:Bool = false) -> String{
    let options = prettyPrinted ? NSJSONWritingOptions.PrettyPrinted : NSJSONWritingOptions(rawValue: 0)
    
    if NSJSONSerialization.isValidJSONObject(value) {
      
      do{
        let data = try NSJSONSerialization.dataWithJSONObject(value, options: options)
        if let string = NSString(data: data, encoding: NSUTF8StringEncoding) {
          return string as String
        }
      }catch {
        Log.sharedLogger.error("Failed to create json params")
      }
      
    }
    return ""
  }
  
}
