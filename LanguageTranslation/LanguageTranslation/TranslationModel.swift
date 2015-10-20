//
//  TranslationModel.swift
//  LanguageTranslation
//
//  Created by Karl Weinmeister on 9/16/15.
//  Copyright © 2015 IBM Mobile Innovation Lab. All rights reserved.
//

import Foundation
import ObjectMapper

public struct TranslationModel : Mappable
{
    var baseModelID: String?
    var customizable: Bool?
    var defaultModel: Bool?
    var domain: String?
    var modelID: String?
    var name: String?
    var owner: String?
    var source: String?
    var status: String?
    var target: String?
    
    public init?(_ map: Map) {}

    public mutating func mapping(map: Map) {
        baseModelID     <- map["base_model_id"]
        customizable    <- map["customizable"]
        defaultModel    <- map["default_model"]
        domain          <- map["domain"]
        modelID         <- map["model_id"]
        name            <- map["name"]
        owner           <- map["owner"]
        status          <- map["status"]
        target          <- map["target"]
    }
}