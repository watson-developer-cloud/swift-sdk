//
//  STTResponse.swift
//  WatsonSDK
//
//  Created by Robert Dickerson on 11/20/15.
//  Copyright © 2015 IBM Watson Developer Cloud. All rights reserved.
//

import Foundation
import ObjectMapper

public struct STTResponse: Mappable
{
    var result: String?
    var state: String?
    
    public init?(_ map: Map) {}
    
    public mutating func mapping(map: Map) {
        result      <- map["result"]
        state       <- map["state"]
    }
    
}