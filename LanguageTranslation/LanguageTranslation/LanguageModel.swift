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
    var base_model_id = ""
    var customizable = false
    var default_model = false
    var domain = ""
    var model_id = ""
    var name = ""
    var owner = ""
    var source = ""
    var status = ""
    var target = ""
    
    public init(base_model_id:String, customizable:Bool, default_model:Bool, domain:String, model_id:String, name:String,owner:String, source:String, status:String, target:String)
    {
        self.base_model_id = base_model_id
        self.customizable = customizable
        self.default_model = default_model
        self.domain = domain
        self.source = source
        self.target = target
        self.model_id = model_id
        self.name = name
        self.owner = owner
        self.status = status
    }
}