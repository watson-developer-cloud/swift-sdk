//
//  LanguageTranslation.swift
//  LanguageTranslation
//
//  Created by Karl Weinmeister on 9/16/15.
//  Copyright © 2015 IBM Mobile Innovation Lab. All rights reserved.
//

import Foundation
import ObjectMapper

/// The IBM Watson Language Translation service translates text from one language
/// to another and identifies the language in which text is written.
public class LanguageTranslation: Service {
    private let _serviceURL = "/language-translation/api"
    
    public init() {
        super.init(serviceURL:_serviceURL)
    }
    
    /**
     Retrieves the list of identifiable languages
     
     - parameter callback: callback method that is invoked with the identifiable languages
     */
    public func getIdentifiableLanguages(callback: ([IdentifiableLanguage]?)->()) {
        let endpoint = getEndpoint("/v2/identifiable_languages")
        
        NetworkUtils.performBasicAuthRequest(endpoint, apiKey: _apiKey, completionHandler: {response in
            
            var languages : [IdentifiableLanguage] = []
            
            if case let data as Dictionary<String,AnyObject> = response.data {
                if case let rawLanguages as [AnyObject] = data[LanguageTranslationConstants.languages] {
                    for rawLanguage in rawLanguages {
                        if let language = Mapper<IdentifiableLanguage>().map(rawLanguage) {
                            languages.append(language)
                        }
                    }
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
        let endpoint = getEndpoint("/v2/identify")
        
        var params = Dictionary<String,String>()
        params.updateValue(text, forKey: "text")
        
        NetworkUtils.performBasicAuthRequest(endpoint, method: .GET, parameters: params, apiKey: _apiKey, completionHandler: {response in
            var languages:[IdentifiedLanguage] = []
            
            if case let data as Dictionary<String,AnyObject> = response.data {
                if case let rawLanguages as [AnyObject] = data[LanguageTranslationConstants.languages] {
                    for rawLanguage in rawLanguages {
                        if let language = Mapper<IdentifiedLanguage>().map(rawLanguage) {
                            languages.append(language)
                        }
                    }
                }
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
        
        let endpoint = getEndpoint("/v2/translate")
        
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
        
        NetworkUtils.performBasicAuthRequest(endpoint, method: .POST, parameters: params, encoding: ParameterEncoding.JSON, apiKey: _apiKey, completionHandler: {response in
            var translations : [String] = []
            
            if case let data as Dictionary<String,AnyObject> = response.data {
                if case let rawTranslations as [AnyObject] = data[LanguageTranslationConstants.translations] {
                    for rawTranslation in rawTranslations {
                        if case let rawTranslationDictionary as Dictionary<String,AnyObject> = rawTranslation {
                            if case let translation as String = rawTranslationDictionary[LanguageTranslationConstants.translation] {
                                translations.append(translation)
                            }
                        }
                    }
                }
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
        let endpoint = getEndpoint("/v2/models")
        
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
        
        NetworkUtils.performBasicAuthRequest(endpoint, method: .GET, parameters: params, apiKey: _apiKey, completionHandler: {response in
            var models : [TranslationModel] = []
            
            
            if case let data as Dictionary<String,AnyObject> = response.data {
                if case let rawModels as [AnyObject] = data[LanguageTranslationConstants.models] {
                    for rawModel in rawModels {
                        if let model = Mapper<TranslationModel>().map(rawModel) {
                            models.append(model)
                        }
                    }
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
        let endpoint = getEndpoint("/v2/models/" + modelID)
        
        NetworkUtils.performBasicAuthRequest(endpoint, method: .GET, parameters: [:], apiKey: _apiKey, completionHandler: {response in
            if case let data as Dictionary<String,AnyObject> = response.data {
                if case _ as String = data[LanguageTranslationConstants.modelID] {
                    return callback(Mapper<TranslationModel>().map(response.data))
                }
            }
            Log.sharedLogger.warning("No model found with given ID")
            return callback(nil)
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
        queryParams.updateValue(baseModelID, forKey: LanguageTranslationConstants.baseModelID)
        if let name = name {
            queryParams.updateValue(name, forKey: LanguageTranslationConstants.name)
        }
        
        var fileParams = Dictionary<String,NSURL>()
        fileParams.updateValue(fileURL, forKey: fileKey)
        
        let endpoint = getEndpoint("/v2/models")
        NetworkUtils.performBasicAuthFileUploadMultiPart(endpoint, fileURLs: fileParams, parameters: queryParams, apiKey: _apiKey, completionHandler: {response in
            callback(Mapper<TranslationModel>().map(response.data))
        })
    }
    
    /**
     Delete a translation model
     
     - parameter modelID:       The model identifier
     - parameter callback:     The callback method to invoke after the response is received, returns true if delete is successful
     */
    public func deleteModel(modelID: String, callback: (Bool?)->())
    {
        let endpoint = getEndpoint("/v2/models/" + modelID)
        NetworkUtils.performBasicAuthRequest(endpoint, method: .DELETE, parameters: [:], apiKey: _apiKey, completionHandler: {response in
            return callback(response.code == 200)
        })
    }
}