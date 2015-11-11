//
//  Classifiers.swift
//  NaturalLanguageClassifier
//
//  Created by Vincent Herrin on 11/7/15.
//  Copyright © 2015 IBM. All rights reserved.
//

import Foundation

import Foundation
import WatsonCore
import ObjectMapper


public struct Classifiers: Mappable {
  
  var classifierArray: [Classifier] = []
  
  init() {
    
  }
  
  public init?(_ map: Map) {}
  
  public mutating func mapping(map: Map) {
    classifierArray    <- map["classifier"]
  }
}
