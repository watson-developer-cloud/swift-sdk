//
//  ClassifiedClass.swift
//  NaturalLanguageClassifier
//
//  Created by Vincent Herrin on 11/7/15.
//  Copyright © 2015 IBM. All rights reserved.
//

import Foundation
import WatsonCore
import ObjectMapper

public struct ClassifiedClass: Mappable {

  var name: String?
  var confidence: Double?
  
  public init?(_ map: Map) {}
  
  public mutating func mapping(map: Map) {
    name        <- map["class_name"]
    confidence  <- (map["confidence"])
  }
}