//
//  ImageKeyWordsModel.swift
//  Alchemy
//
//  Created by Vincent Herrin on 9/30/15.
//  Copyright © 2015 MIL. All rights reserved.
//

import Foundation
import WatsonCore
import ObjectMapper


public struct ImageKeyWord: Mappable {

  var text: String?
  var score: Double?

    public init?(_ map: Map) {}
    
    public mutating func mapping(map: Map) {
        text    <- map["text"]
        score   <- (map["score"], Transformation.stringToDouble)
    }
}