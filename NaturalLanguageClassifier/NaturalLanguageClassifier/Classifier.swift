//
//  Classifier.swift
//  NaturalLanguageClassifier
//
//  Created by Vincent Herrin on 11/10/15.
//  Copyright © 2015 IBM. All rights reserved.
//

import Foundation
import WatsonCore
import ObjectMapper


/**
 * The Enum Status.
 */
public enum Status: String {
		case Available = "Available"
		case Failed = "Failed"
		case NonExistent = "Non Existent"
		case Training = "Training"
		case Unavailable = "Unavailable"
}

public struct Classifier: Mappable {
  var created: NSDate = NSDate()
  var id: String?
  var language: String?
  var name: String?
  var status: Status = Status.NonExistent
  var statusDescription: String?
  var url: String?
  
  public init?(_ map: Map) {}
  
  public mutating func mapping(map: Map) {
    created            <- (map["created"], DateTransform())
    id                 <- (map["classifier_id"])
    language           <- map["language"]
    name               <- map["name"]
    url                <- map["url"]
    status             <- (map["status"], EnumTransform())
    statusDescription  <- map["status_description"]
  }
}















