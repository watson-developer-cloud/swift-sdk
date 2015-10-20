//
//  LanguageTranslation.swift
//  LanguageTranslation
//
//  Created by Karl Weinmeister on 9/16/15.
//  Copyright © 2015 IBM Mobile Innovation Lab. All rights reserved.
//

import WatsonCore
import Foundation
import SwiftyJSON
import Alamofire

 /// The IBM Watson Language Translation service translates text from one language
 /// to another and identifies the language in which text is written.
public class LanguageTranslation {
    
    private let TAG = "[LanguageTranslation] "
    private let _serviceURL = "/language-translation/api"

    private let utils = NetworkUtils()

    /**
    Initialize the language translation service
    
    - parameter username: username
    - parameter password: password
    
    */
    public init(username:String,password:String) {
        utils.setUsernameAndPassword(username,password:password)
    }

    /**
    Retrieves the list of identifiable languages
    
    - parameter callback: callback method that is invoked with the identifiable languages
    */
    public func getIdentifiableLanguages(callback: ([IdentifiableLanguage]?)->()) {
        let endpoint = utils.buildEndpoint(_serviceURL + "/v2/identifiable_languages")

        utils.performBasicAuthRequest(endpoint, method: .GET, parameters: [:], completionHandler: {response in
            let data = JSON(response.data)
            
            var languages : [IdentifiableLanguage] = []
            
            for (_,subJson):(String, JSON) in data["languages"] {
                if let language = subJson["language"].string, name = subJson["name"].string {
                    languages.append(IdentifiableLanguage(language: language, name: name))
                }
            }
            callback(languages)
        })
    }

    /**
    Identify the language in which text is written
    
    - parameter text:     the text to identify
    - parameter callback: the callback method to be invoked with an array of identified languages in descending order of confidence
    */
    public func identify(text:String, callback: ([IdentifiedLanguage])->()) {
        let endpoint = utils.buildEndpoint(_serviceURL + "/v2/identify")
        
        var params = Dictionary<String,String>()
        params.updateValue(text, forKey: "text")
        
        utils.performBasicAuthRequest(endpoint, method: .GET, parameters: params, completionHandler: {response in
            var languages:[IdentifiedLanguage] = []
            let json = JSON(response.data)["languages"]
            for (_,subJson):(String, JSON) in json {
                let language = subJson["language"].stringValue
                let confidence = subJson["confidence"].doubleValue
                languages.append(IdentifiedLanguage(language:language, confidence:confidence))
            }
            callback(languages)
        })
    }
    
    /**
    Translate text using source and target languages
    
    - parameter text:           The text to translate
    - parameter source: The language that the original text is written in
    - parameter target: The language that the text will be translated into
    - parameter callback:       The callback method that is invoked with the translated string
    */
    public func translate(text:[String], source:String, target:String, callback:([String])->()) {
        translate(text, source:source, target:target, modelID:nil, callback: callback)
    }

    /**
    Translate text using a model specified by modelID
    - parameter text:           The text to translate
    - parameter modelID: The ID of the model that should be used for translation parameters
    - parameter callback:       The callback method that is invoked with the translated string
    */
    public func translate(text:[String], modelID:String, callback:([String])->()) {
        translate(text, source:nil, target:nil, modelID:modelID, callback: callback)
    }
    
    /**
    Private function that translation functions using either source&target or model ID parameters flow through
    
    - parameter text:           The text to translate
    - parameter source: The language that the original text is written in
    - parameter target: The language that the text will be translated into
    - parameter modelID: The ID of the model that should be used for translation parameters
    - parameter callback:       The callback method that is invoked with the translated string
    */
    private func translate(text:[String], source:String? = nil, target:String? = nil, modelID:String? = nil, callback:([String])->()) {
        
        let endpoint = utils.buildEndpoint(_serviceURL + "/v2/translate")
        
        var params = [String : NSObject]()

        if let source = source {
            params[LanguageTranslationConstants.source] = source
        }
        if let target = target {
            params[LanguageTranslationConstants.target] = target
        }
        if let modelID = modelID {
            params[LanguageTranslationConstants.modelID] = modelID
        }
        
        params[LanguageTranslationConstants.text] = text
        
        utils.performBasicAuthRequest(endpoint, method: .POST, parameters: params, encoding: ParameterEncoding.JSON, completionHandler: {response in
            var translations : [String] = []
            let json = JSON(response.data)["translations"]
            for (_,subJson):(String, JSON) in json {
                translations.append(subJson["translation"].stringValue)
            }
            callback(translations)
        })
    }
    
    /**
    Lists available standard and custom models by source or target language
    
    - parameter source:       Filter models by source language.
    - parameter target:       Filter models by target language.
    - parameter defaultModel: Valid values are leaving it unset, 'true' and 'false'. When 'true', it filters models to return the default model or models. When 'false' it returns the non-default model or models. If not set, all models (default and non-default) return.
    - parameter callback:     The callback method to invoke after the response is received
    */
    public func getModels(source: String? = nil, target: String? = nil, defaultModel: Bool? = nil, callback: ([TranslationModel])->())
    {
        let endpoint = utils.buildEndpoint(_serviceURL + "/v2/models")
        
        var params = Dictionary<String,String>()
        if let source = source {
            params.updateValue(source, forKey: LanguageTranslationConstants.source)
        }
        if let target = target {
            params.updateValue(target, forKey: LanguageTranslationConstants.target)
        }
        if let defaultModel = defaultModel {
            params.updateValue(String(stringInterpolationSegment: defaultModel), forKey: LanguageTranslationConstants.defaultStr)
        }
        
        utils.performBasicAuthRequest(endpoint, method: .GET, parameters: params, completionHandler: {response in
            var models : [TranslationModel] = []
            let json = JSON(response.data)["models"]
            for (_,subJson):(String, JSON) in json {
                if let model = self.dictionaryToModel(subJson) {
                    models.append(model)
                }
            }
            callback(models)
        })
    }
    
    /**
    Retrieve a translation model
    
    - parameter modelID:       The model identifier
    - parameter callback:     The callback method to invoke after the response is received
    */
    public func getModel(modelID: String, callback: (TranslationModel?)->())
    {
        let endpoint = utils.buildEndpoint(_serviceURL + "/v2/models/\(modelID)")
        
        utils.performBasicAuthRequest(endpoint, method: .GET, parameters: [:], completionHandler: {response in
            return callback(self.dictionaryToModel(JSON(response.data)))
        })
    }
    
    /**
    Uploads a TMX glossary file on top of a domain to customize a translation model.
    
    - parameter baseModelID:        (Required). Specifies the domain model that is used as the base for the training.
    - parameter name:               The model name. Valid characters are letters, numbers, -, and _. No spaces.
    - parameter forcedGlossaryPath: (Required). A TMX file with your customizations. Anything specified in this file will completely overwrite the domain data translation.
    - parameter callback:           Returns the created model
    */
    public func createModel(baseModelID: String, name: String? = nil, fileKey: String, fileURL: NSURL, callback: (TranslationModel?)->())
    {
        var queryParams = Dictionary<String,String>()
        queryParams.updateValue(baseModelID, forKey: "base_model_id")
        if let name = name {
            queryParams.updateValue(name, forKey: "name")
        }

        let request = utils.buildEndpoint(_serviceURL + "/v2/models")
        utils.performBasicAuthFileUploadMultiPart(request, fileURLKey: fileKey, fileURL: fileURL, parameters: queryParams, completionHandler: {response in
            callback(self.dictionaryToModel(JSON(response.data)))
        })
    }
        
    /**
    Delete a translation model
    
    - parameter modelID:       The model identifier
    - parameter callback:     The callback method to invoke after the response is received, returns true if delete is successful
    */
    public func deleteModel(modelID: String, callback: (Bool?)->())
    {
        let endpoint = utils.buildEndpoint(_serviceURL + "/v2/models/\(modelID)")
        
        utils.performBasicAuthRequest(endpoint, method: .DELETE, parameters: [:], completionHandler: {response in
            return callback(response.statusInfo == CoreResponseEnum.Ok.rawValue)
        })
    }
    
    /**
    Converts a dictionary of strings returned by the Watson service to a native model object
    
    - parameter dictionary: a dictionary of key/value pairs
    
    - returns: A populated language model object
    */
    private func dictionaryToModel(json: JSON) -> TranslationModel?
    {
        //TODO: Investigate using mapping library
        if let source = json[LanguageTranslationConstants.source].string,
        modelID = json[LanguageTranslationConstants.modelID].string,
        target = json[LanguageTranslationConstants.target].string,
        baseModelID = json[LanguageTranslationConstants.baseModelID].string,
        domain = json[LanguageTranslationConstants.domain].string,
        defaultModel = json[LanguageTranslationConstants.defaultModel].bool,
        owner = json[LanguageTranslationConstants.owner].string,
        status = json[LanguageTranslationConstants.status].string,
        customizable = json[LanguageTranslationConstants.customizable].bool,
        name = json[LanguageTranslationConstants.name].string
        {
            return TranslationModel(baseModelID:baseModelID, customizable:customizable, defaultModel:defaultModel, domain:domain, modelID:modelID, name:name, owner:owner, source:source, status:status, target:target)
        } else {
            Log.sharedLogger.warning("\(self.TAG) Value missing from dictionary. Unable to convert to a Language model")
            return nil
        }
    }

}