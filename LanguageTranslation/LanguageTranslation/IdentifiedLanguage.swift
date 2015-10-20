//
//  IdentifiedLanguage.swift
//  LanguageTranslation
//
//  Created by Karl Weinmeister on 10/19/15.
//  Copyright © 2015 Watson Developer Cloud. All rights reserved.
//

import Foundation

public struct IdentifiedLanguage {
    var language:String
    var confidence:Double
    
    init(language:String, confidence:Double)
    {
        self.language = language
        self.confidence = confidence
    }
}