//
//  TrainingData.swift
//  NaturalLanguageClassifier
//
//  Created by Vincent Herrin on 11/7/15.
//  Copyright © 2015 IBM. All rights reserved.
//

import Foundation
import ObjectMapper

public struct TraingingData: Mappable {
  
//  private var text:String = ""
//  private var classes: [String] = {
//    get {
//      let centerX = origin.x + (size.width / 2)
//      let centerY = origin.y + (size.height / 2)
//      return Point(x: centerX, y: centerY)
//    }
//    set(newCenter) {
//      origin.x = newCenter.x - (size.width / 2)
//      origin.y = newCenter.y - (size.height / 2)
//    }
//  }
  
  init() {
    
  }
  
  public init?(_ map: Map) {}
  
  public mutating func mapping(map: Map) {
    //classifierArray    <- map["classifier"]
  }
}