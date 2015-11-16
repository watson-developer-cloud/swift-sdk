//
//  Voice.swift
//  TextToSpeech
//
//  Created by Robert Dickerson on 11/12/15.
//  Copyright © 2015 Watson Developer Cloud. All rights reserved.
//

import Foundation
import ObjectMapper

public struct Voice: Mappable {
    
    var url: String?
    var gender: String?
    var name: String?
    var language: String?
    var description: String?
    
    public init?(_ map: Map) {}
    
    public mutating func mapping(map: Map) {
        url         <- map["url"]
        gender      <- map["gender"]
        name        <- map["name"]
        language    <- map["language"]
        description <- map["description"]
    }
    
}