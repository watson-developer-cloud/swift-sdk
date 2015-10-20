//
//  LanguageTranslationConstants.swift
//  LanguageTranslation
//
//  Created by Karl Weinmeister on 10/5/15.
//  Copyright © 2015 Watson Developer Cloud. All rights reserved.
//

import Foundation

public struct LanguageTranslationConstants {
    /// Constants used for key/value pairs in the Watson service
    static let baseModelID = "base_model_id"
    static let customizable = "customizable"
    static let defaultModel = "default_model"
    static let domain = "domain"
    static let modelID = "model_id"
    static let name = "name"
    static let owner = "owner"
    static let source = "source"
    static let status = "status"
    static let target = "target"
    
    //Used for getModels() query - can't use default for key, as this is a Swift reserved word
    static let defaultStr = "default"

    //Used for translate() query
    static let text = "text"

}