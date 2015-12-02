//
//  IdentifiableLanguage.swift
//  LanguageTranslation
//
//  Created by Karl Weinmeister on 9/16/15.
//  Copyright © 2015 IBM Mobile Innovation Lab. All rights reserved.
//

import Foundation
import ObjectMapper

public struct IdentifiableLanguage: Mappable {
    var language:String?
    var name:String?
    
    public init?(_ map: Map) {}
    
    public mutating func mapping(map: Map) {
        language    <- map["language"]
        name        <- map["name"]
    }
}
