//
//  IdentifiedLanguage.swift
//  LanguageTranslation
//
//  Created by Karl Weinmeister on 10/19/15.
//  Copyright © 2015 Watson Developer Cloud. All rights reserved.
//

import Foundation
import ObjectMapper

public struct IdentifiedLanguage : Mappable {
    var language: String?
    var confidence: Double?
    
    public init?(_ map: Map) {}
    
    public mutating func mapping(map: Map) {
        language    <- map["language"]
        confidence  <- map["confidence"]
    }
}