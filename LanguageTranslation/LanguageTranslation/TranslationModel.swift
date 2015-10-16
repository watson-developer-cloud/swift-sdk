//
//  TranslationModel.swift
//  LanguageTranslation
//
//  Created by Karl Weinmeister on 9/16/15.
//  Copyright © 2015 IBM Mobile Innovation Lab. All rights reserved.
//

import Foundation
import SwiftyJSON

public struct TranslationModel
{
    var baseModelID = ""
    var customizable = false
    var defaultModel = false
    var domain = ""
    var modelID = ""
    var name = ""
    var owner = ""
    var source = ""
    var status = ""
    var target = ""
    
    public init(baseModelID:String, customizable:Bool, defaultModel:Bool, domain:String, modelID:String, name:String,owner:String, source:String, status:String, target:String)
    {
        self.baseModelID = baseModelID
        self.customizable = customizable
        self.defaultModel = defaultModel
        self.domain = domain
        self.source = source
        self.target = target
        self.modelID = modelID
        self.name = name
        self.owner = owner
        self.status = status
    }
    
    init(anyObject: AnyObject) {
        var data = JSON(anyObject)
        
        
    }
}