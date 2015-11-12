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
  private let _serviceURL = "/natural-language-classifier/api"
  
  public init() {
    super.init(serviceURL:_serviceURL)
  }
  
  /**
   This function will get an array of classifiers
   
   - parameter completionHandler: [Classifier]
   */
  public func getClassifiers(completionHandler: ([Classifier]?)->()) {
    let endpoint = getEndpoint("/v1/classifiers")
    
    NetworkUtils.performBasicAuthRequest(endpoint, apiKey: _apiKey, completionHandler: {response in
      
      var classifiers : [Classifier] = []
      
      if case let data as Dictionary<String,AnyObject> = response.data {
        if case let rawClassifiers as [AnyObject] = data[NLCConstants.Classifiers] {
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
  
  public func classify(classifierId: String, text: String, completionHandler: (Classification?)->()) {
    let endpoint = getEndpoint("/v1/classifiers/" + classifierId + "/classify")
    
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
    
    NetworkUtils.performBasicAuthRequest(endpoint, method: .POST, parameters: [:], apiKey: _apiKey, completionHandler: {response in
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
   Retrieves a classifier
   
   - parameter classifierId:      The classifer ID used to retrieve the classifier
   - parameter completionHandler: Classifer?
   */
  public func getClassifier( classifierId: String, completionHandler: (Classifier?)->()) {
    let endpoint = getEndpoint("/v1/classifiers/" + classifierId)
    
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
  
  public enum TrainerProperty: String {
    case Language     = "language"
    case Name         = "name"
    case TrainingMeta = "training_metadata"
    case TrainingData = "training_data"
  }
  
  public func deleteClassifier( classifierId: String, completionHandler: (Bool?)->()) {
    let endpoint = getEndpoint("/v1/classifiers/" + classifierId)
    
    NetworkUtils.performBasicAuthRequest(endpoint, method: .DELETE, parameters: [:], apiKey: _apiKey, completionHandler: {response in
      return completionHandler(response.code == 200)
    })
  }
  
  
  public func createClassifier(name: String? = nil, language: String = "en", trainerURL: NSURL, completionHandler: (Classifier?)->()) {
    let endpoint = getEndpoint("/v1/classifiers")
    
    var params = Dictionary<String, AnyObject>()
    var csv = Dictionary<String, String>()
    
    csv.updateValue(language, forKey: TrainerProperty.Language.rawValue)
    
    if let name = name  {
      csv.updateValue(name, forKey: TrainerProperty.Name.rawValue)
    }
    
    var training_metadata = JSONStringify(csv)
    Log.sharedLogger.debug(training_metadata)
    
    //TODO: Add guard
    params.updateValue(training_metadata, forKey: TrainerProperty.TrainingMeta.rawValue)
      

      NetworkUtils.performBasicAuthFileUpload(endpoint, fileURL: trainerURL, parameters: params, apiKey: _apiKey, completionHandler: {response in
        completionHandler(Mapper<Classifier>().map(response.data))
      })
     // completionHandler(nil)
    }

  
  
  
    //  Classifier createClassifier(final String name, final String language, final List<TrainingData> trainingData)
    //
  //  Classification classify(final String classifierId, final String text)
  //
  //  deleteClassifier(classifierId)
  
  //
  //  List<Classifier> getClassifiers
  //
  
  //
  
  
  func JSONStringify(value: AnyObject,prettyPrinted:Bool = false) -> String{
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
