//
//  LanguageTranslationConstants.swift
//  LanguageTranslation
//
//  Created by Karl Weinmeister on 10/5/15.
//  Copyright © 2015 Watson Developer Cloud. All rights reserved.
//

import Foundation

public struct LanguageTranslationConstants {

    //Translation model
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
    
    //getModels()
    static let models = "models"
    //Can't use default for key, as this is a Swift reserved word
    static let defaultStr = "default"

    //translate()
    static let text = "text"
    static let translations = "translations"
    static let translation = "translation"

    //identify() and getIdentifiableLanguages()
    static let languages = "languages"
    
}