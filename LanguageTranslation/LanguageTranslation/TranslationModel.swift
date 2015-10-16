//
//  TranslationModel.swift
//  LanguageTranslation
//
//  Created by Karl Weinmeister on 9/16/15.
//  Copyright © 2015 IBM Mobile Innovation Lab. All rights reserved.
//

import Foundation
import SwiftyJSON

// would be nice to have an automapper for this model
private enum TranslationEnum: String {
    case BaseModelID = "baseModelID"
    case Customizable = "customizable"
    case DefaultModel = "defaultModel"
    case Domain = "domain"
    case ModelID = "modelID"
    case Name = "name"
    case Owner = "owner"
    case Source = "source"
    case Status = "status"
    case Target = "target"
}


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
        
        self.baseModelID = data[TranslationEnum.BaseModelID.rawValue].stringValue
        self.customizable = data[TranslationEnum.Customizable.rawValue].boolValue
        self.defaultModel = data[TranslationEnum.DefaultModel.rawValue].boolValue
        self.domain = data[TranslationEnum.Domain.rawValue].stringValue
        self.source = data[TranslationEnum.Source.rawValue].stringValue
        self.target = data[TranslationEnum.Target.rawValue].stringValue
        self.modelID = data[TranslationEnum.ModelID.rawValue].stringValue
        self.name = data[TranslationEnum.Name.rawValue].stringValue
        self.owner = data[TranslationEnum.Owner.rawValue].stringValue
        self.status = data[TranslationEnum.Status.rawValue].stringValue
        
    }
}