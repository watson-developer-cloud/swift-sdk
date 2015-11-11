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
  
  
  public func getClassifiers(completionHandler: ([Classifiers]?)->()) {
    let endpoint = getEndpoint("/v1/classifiers")
    
    NetworkUtils.performBasicAuthRequest(endpoint, apiKey: _apiKey, completionHandler: {response in
      
      var classifiers : [Classifiers] = []
      
      if case let data as Dictionary<String,AnyObject> = response.data {
        if case let rawClassifiers as [AnyObject] = data[NLCConstants.Classifiers] {
          for rawClassifier in rawClassifiers {
            if let classifier = Mapper<Classifiers>().map(rawClassifier) {
              classifiers.append(classifier)
            }
          }
        }
      }
      completionHandler(classifiers)
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
//
//  Classifier getClassifier(classifierId)
//  
//  public func getClassifiers()->
//  
//  List<Classifier> getClassifiers
//  
//  
//  public func recognizeFaces(inputType: VisionConstants.ImageFacesType, stringURL: String? = nil, fileURL: NSURL? = nil, forceShowAll: Bool = false, knowledgeGraph: Int8 = 0, completionHandler: (returnValue: Classifier) ->() ) {
//  
//    
  
    
}
