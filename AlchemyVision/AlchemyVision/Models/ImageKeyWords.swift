//
//  ImageKeyWords.swift
//  AlchemyVision
//
//  Created by Vincent Herrin on 10/13/15.
//  Copyright © 2015 MIL. All rights reserved.
//

import Foundation
import WatsonCore
import ObjectMapper

public struct ImageKeyWords: Mappable {
    
    var totalTransactions: Int?
    var imageKeyWords: [ImageKeyWord] = []
    
    public init() {

    }

    public init?(_ map: Map) {}
    
    public mutating func mapping(map: Map) {
        imageKeyWords     <-   map["imageKeywords"]
        totalTransactions <-  (map["totalTransactions"], Transformation.stringToInt)
    }
    
}
