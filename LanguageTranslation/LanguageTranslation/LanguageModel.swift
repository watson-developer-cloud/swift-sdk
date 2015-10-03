//
//  LanguageModel.swift
//  LanguageTranslation
//
//  Created by Karl Weinmeister on 9/16/15.
//  Copyright © 2015 IBM Mobile Innovation Lab. All rights reserved.
//

import Foundation

public struct LanguageModel
{
    var modelId = ""
    var name = ""
    var source = ""
    var target = ""
    var baseModelId = ""
    var domain = ""
    var customizable = false
    var defaultModel = false
    var owner = ""
    var status = ""
    
    public init(source:String,target:String)
    {
        self.source = source
        self.target = target
    }
}