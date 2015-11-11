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
		
		/** The available. */
		case Available = "Available"
		
		/** The failed. */
		case Failed = "Failed"
		
		/** The non existent. */
		case NonExistent = "Non Existent"
		
		/** The training. */
		case Training = "Training"
		
		/** The unavailable. */
		case Unavailable = "Unavailable"
}

public struct Classifier: Mappable {
  
  /** The created. */
  var created: NSDate = NSDate()
  
  /** The id. */
  var id: String?
  
  /** The language. */
  var language: String?
  
  /** The name. */
  var name: String?
  
  /** The status. */
  var status: Status = Status.Unavailable
  
  /** The status description. */
  var statusDescription: String?
  
  /** The url. */
  var url: String?
  
  
//    init() {
//  
//    }
  
  
  public init?(_ map: Map) {}
  
  public mutating func mapping(map: Map) {
     created            <- map["created"]
     id                 <- map["classifier_id"]
     language           <- map["language"]
     name               <- map["name"]
     url                <- map["url"]
     status             <- map["status"]
     statusDescription  <- map["status_description"]
  }
}















