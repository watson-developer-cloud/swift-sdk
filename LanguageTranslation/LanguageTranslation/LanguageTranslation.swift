//
//  LanguageTranslation.swift
//  LanguageTranslation
//
//  Created by Karl Weinmeister on 9/16/15.
//  Copyright © 2015 IBM Mobile Innovation Lab. All rights reserved.
//

import WatsonCore
import Foundation





 /// The IBM Watson Language Translation service translates text from one language
 /// to another and identifies the language in which text is written.

public class LanguageTranslation {
    
    private let TAG = "[LanguageTranslation] "
    private let _serviceURL = "/language-translation/api"

    private let utils = NetworkUtils()

    private var _languages:[Language]?

    /**
    Initialize the language translation service
    
    - parameter username: username
    - parameter password: password
    
    */
    public init(username:String,password:String) {
        //TODO: Handle 401 errors (no or wrong username/password)
        utils.setUsernameAndPassword(username,password:password)
        //TODO: Handle edge case where language list is not yet initialized by the time the user calls translate()
        //getIdentifiableLanguages({ self._languages = $0 })
    }

    /**
    Retrieves the list of identifiable languages
    
    - parameter callback: callback method that is invoked with the identifiable languages
    */
    public func getIdentifiableLanguages(callback: ([Language]?)->()) {
        let path = _serviceURL + "/v2/identifiable_languages"
        
        let request = utils.buildRequest(path, method: HTTPMethod.GET, body: nil)
        utils.performRequest(request!, callback: {response, error in
            
            var languages = [Language]()
            if let languageArray = response["languages"] as? NSArray {
                
                for languageDictionary in languageArray {
                    if let lang = languageDictionary["language"] as? String {
                        if let nm = languageDictionary["name"] as? String {
                            languages.append(Language(language:lang,name:nm))
                        }
                        else {
                            WatsonLog("getIdentifiableLanguages(): Missing name for language \(lang)", prefix:self.TAG)
                        }
                    }
                    else {
                        WatsonLog("getIdentifiableLanguages(): Expected language attribute for languages array element", prefix:self.TAG)
                    }
                }
            }
            else {
                WatsonLog("getIdentifiableLanguages(): Expected languages array in response", prefix:self.TAG)
                callback(nil)
            }
            callback(languages)
        })
    }
    
    /**
    Identify the language in which text is written
    
    - parameter text:     the text to identify
    - parameter callback: the callback method to be invoked with the identified language
    */
    public func identify(text:String, callback: (String?)->()) {
        
        let path = _serviceURL + "/v2/identify"
        let request = utils.buildRequest(path, method: HTTPMethod.POST, body: text.dataUsingEncoding(NSUTF8StringEncoding), contentType: ContentType.Text, accept: ContentType.Text)
        
        utils.performRequest(request!, callback: {response, error in
            if let error_message = response["error_message"] as? String
            {
                WatsonLog("identify(): " + error_message, prefix:self.TAG)
                callback(nil)
            }
            else {
                guard let rawData = response["rawData"] as! NSData? else {
                    WatsonLog("identify(): expected to find rawData in response", prefix:self.TAG)
                    callback(nil)
                    return
                }
                guard let language = NSString(data: rawData, encoding: NSUTF8StringEncoding) as String? else {
                    WatsonLog("identify(): error converting data to string", prefix:self.TAG)
                    callback(nil)
                    return
                }
                callback(language)
            }
        })
    }
    
    /**
    Translate text using source and target languages
    
    - parameter text:           The text to translate
    - parameter source: The language that the original text is written in
    - parameter target: The language that the text will be translated into
    - parameter callback:       The callback method that is invoked with the translated string
    */
    public func translate(text:[String], source:String, target:String, callback:([String]?)->()) {
        
        let path = _serviceURL + "/v2/translate"
        
        let dict = NSMutableDictionary()
        dict.setObject(source, forKey: "source")
        dict.setObject(target, forKey: "target")
        dict.setObject(text as NSArray, forKey: "text")
        
        let body = utils.dictionaryToJSON(dict)
        
        let request = utils.buildRequest(path, method: HTTPMethod.POST, body: body)
        
        utils.performRequest(request!, callback: {response, error in
            if let error_message = response["error_message"] as? String
            {
                WatsonLog("translate(): " + error_message, prefix:self.TAG)
                callback(nil)
            }
            else {

                guard let translations = response["translations"] as? NSArray else
                {
                    WatsonLog("translate(): expected to find translations in response", prefix:self.TAG)
                    callback(nil)
                    return
                }
                let firstTranslation = translations[0] as! NSDictionary
                let translation = firstTranslation["translation"] as! String
                callback([translation])
            }
        })
    }
    
    public func translate(model:TranslationModel,callback: ([String])->()) {
        //TODO: Add support for translating using model objects
    }
    
    /**
    Lists available standard and custom models by source or target language
    
    - parameter source:       Filter models by source language.
    - parameter target:       Filter models by target language.
    - parameter defaultModel: Valid values are leaving it unset, 'true' and 'false'. When 'true', it filters models to return the default model or models. When 'false' it returns the non-default model or models. If not set, all models (default and non-default) return.
    - parameter callback:     The callback method to invoke after the response is received
    */
    public func getModels(source: String? = nil, target: String? = nil, defaultModel: Bool? = nil, callback: ([TranslationModel?]?)->())
    {
        let path = _serviceURL + "/v2/models"
        
        //TODO: Pass in source, target, and default parameters if non-nil to service
        
        let request = utils.buildRequest(path, method: HTTPMethod.GET, body: nil)
        utils.performRequest(request!, callback: {response, error in
            guard let modelDictionaries:NSArray = response["models"] as! NSArray? else {
                return
            }
            let models: [TranslationModel?] = modelDictionaries.map {
                (let dictionary) -> TranslationModel? in
                return self.dictionaryToModel(dictionary as! NSDictionary)
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
        let path = _serviceURL + "/v2/models/\(modelID)"
        
        let request = utils.buildRequest(path, method: HTTPMethod.GET, body: nil)
        utils.performRequest(request!, callback: {response, error in
            if let error_message = response["error_message"] as? String
            {
                WatsonLog("translate(): " + error_message, prefix:self.TAG)
            }
            else if let dictionary = response as NSDictionary? {
                return callback(self.dictionaryToModel(dictionary))
            }
            callback(nil)
        })
    }
  
//    /**
//    Uploads a TMX glossary file on top of a domain to customize a translation model.
//    
//    - parameter baseModelID:        (Required). Specifies the domain model that is used as the base for the training.
//    - parameter name:               The model name. Valid characters are letters, numbers, -, and _. No spaces.
//    - parameter forcedGlossaryPath: (Required). A TMX file with your customizations. Anything specified in this file will completely overwrite the domain data translation.
//    - parameter callback:           Returns the created model
//    */
//    public func createModel(baseModelID: String, name: String? = nil, forcedGlossaryPath: String, callback: (String?)->())
//    {
//        //TODO: Return a model rather than a model ID
//        let path = _serviceURL + "/v2/models"
//        
//        let queryParams = NSMutableDictionary()
//        queryParams.setObject(baseModelID, forKey: "base_model_id")
//        if let name = name {
//            queryParams.setObject(name, forKey: "name")
//        }
//
//        //let dict = NSMutableDictionary()
//        //dict.setObject(readForcedGlossary(forcedGlossaryPath)!, forKey: "forced_glossary")
//        
//        //let body = utils.dictionaryToJSON(dict)
//        let body = readForcedGlossary(forcedGlossaryPath)!
//        
//        let request = utils.buildRequest(path, method: HTTPMethod.POST, body: body, queryParams: queryParams)
//        utils.performRequest(request!, callback: {response, error in
//            if let error_message = response["error_message"] as? String
//            {
//                WatsonLog("createModel(): " + error_message, prefix:self.TAG)
//            }
//            else if let response = response as NSDictionary? {
//                return callback(response["model_id"] as! String?)
//            }
//            callback(nil)
//        })
//    }
    
    private func readForcedGlossary(path:String) -> String? {
        do {
            let data = try NSData(contentsOfFile: path)
            let encodedContent = data?.base64EncodedStringWithOptions(NSDataBase64EncodingOptions.Encoding64CharacterLineLength)
            return encodedContent
//            let fileContent = try NSString(contentsOfFile: path, encoding: NSUTF8StringEncoding)
            //return fileContent as String
        } catch {
            
        }
        return nil
    }
    
    
    /**
    Converts a dictionary of strings returned by the Watson service to a native model object
    
    - parameter dictionary: a dictionary of key/value pairs
    
    - returns: A populated language model object
    */
    private func dictionaryToModel(dictionary: NSDictionary) -> TranslationModel?
    {
        if let source = dictionary[LanguageTranslationConstants.source] as? String,
        modelID = dictionary[LanguageTranslationConstants.modelID] as? String,
        target = dictionary[LanguageTranslationConstants.target] as? String,
        baseModelID = dictionary[LanguageTranslationConstants.baseModelID] as? String,
        domain = dictionary[LanguageTranslationConstants.domain] as? String,
        defaultModel = dictionary[LanguageTranslationConstants.defaultModel] as? Bool,
        owner = dictionary[LanguageTranslationConstants.owner] as? String,
        status = dictionary[LanguageTranslationConstants.status] as? String,
        customizable = dictionary[LanguageTranslationConstants.customizable] as? Bool,
        name = dictionary[LanguageTranslationConstants.name] as? String
        {
            return TranslationModel(baseModelID:baseModelID, customizable:customizable, defaultModel:defaultModel, domain:domain, modelID:modelID, name:name, owner:owner, source:source, status:status, target:target)
        } else {
            WatsonLog("Value missing from dictionary. Unable to convert to a Language model", prefix:self.TAG)
            return nil
        }
    }
    
    //TODO: delete models
    
}