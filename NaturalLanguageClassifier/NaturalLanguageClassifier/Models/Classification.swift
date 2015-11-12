//
//  Classification.swift
//  NaturalLanguageClassifier
//
//  Created by Vincent Herrin on 11/7/15.
//  Copyright © 2015 IBM. All rights reserved.
//

import Foundation
import ObjectMapper

public struct Classification: Mappable {

  var id: String?
  var url: String?
  var text: String?
  var topClass: String?
  var classes: [ClassifiedClass]?
  
  public init?(_ map: Map) {}
  
  public mutating func mapping(map: Map) {
    id        <- map["classifier_id"]
    text      <- map["text"]
    url       <- map["url"]
    topClass  <- map["top_class"]
    classes   <- map["classes"]
  }
}