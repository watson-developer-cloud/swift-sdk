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
  
  /**
   Retrieves a classifier
   
   - parameter classifierId:      The classifer ID
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
  
  
  //
  //
  //  Classifier createClassifier(final String name, final String language, final List<TrainingData> trainingData)
  //
  //  Classification classify(final String classifierId, final String text)
  //
  //  deleteClassifier(classifierId)

  //
  //  List<Classifier> getClassifiers
  //

  //    
  
  
}
