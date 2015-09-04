//
//  Language.swift
//  LanguageTranslationSDK
//
//  Created by Karl Weinmeister on 9/3/15.
//  Copyright (c) 2015 IBM MIL. All rights reserved.
//

import Foundation

public struct Language {
    var language:String
    var name:String
    
    init(language:String,name:String)
    {
        self.language = language
        self.name = name
    }
}
