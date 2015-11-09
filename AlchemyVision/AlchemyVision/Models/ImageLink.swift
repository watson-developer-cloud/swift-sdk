//
//  File.swift
//  AlchemyVision
//
//  Created by Vincent Herrin on 11/5/15.
//  Copyright © 2015 MIL. All rights reserved.
//

import Foundation

import Foundation
import WatsonCore
import ObjectMapper


public struct ImageLink: Mappable {
  
  var url: String?
  var image: String?
  
  init() {
    
  }
  
  public init?(_ map: Map) {}
  
  public mutating func mapping(map: Map) {
    url    <- map["url"]
    image   <- map["image"]
  }
}