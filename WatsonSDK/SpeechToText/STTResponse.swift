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
    var results: [STTResults]?
    var state: String?
    
    public init?(_ map: Map) {}
    
    public mutating func mapping(map: Map) {
        results         <- map["results"]
        state           <- map["state"]
    }
    
}

public struct STTResults: Mappable
{
    var alternatives: [Alternative]?
    
    public init?(_ map: Map) {}
    
    public mutating func mapping(map: Map) {
        alternatives        <- map["alternatives"]
    }

}

public struct Alternative: Mappable
{
    var transcript: String?
    var confidence: Double?
    
    public init?(_ map: Map) {}
    
    public mutating func mapping(map: Map) {
        transcript          <- map["transcript"]
        confidence          <- map["confidence"]
        
    }
}
