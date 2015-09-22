//
//  WatsonLanguageTranslation.swift
//  WatsonLanguageTranslation
//
//  Created by Karl Weinmeister on 9/16/15.
//  Copyright © 2015 IBM Mobile Innovation Lab. All rights reserved.
//

import WatsonCore
import Foundation

//TODO: document functions

public class WatsonLanguageTranslation {
    
    private let TAG = "[WatsonLanguageTranslation] "
    private let _serviceURL = "/language-translation/api"

    private let utils = WatsonNetworkUtils()

    private var _languages:[WatsonLanguage]?
    
    public init(username:String,password:String) {
        //TODO: Handle 401 errors (no or wrong username/password)
        utils.setUsernameAndPassword(username,password:password)
        //TODO: Handle edge case where language list is not yet initialized by the time the user calls translate()
        //getIdentifiableLanguages({ self._languages = $0 })
    }
    
    public func getIdentifiableLanguages(callback: ([WatsonLanguage])->()) {
        let path = _serviceURL + "/v2/identifiable_languages"
        
        let request = utils.buildRequest(path, method: WatsonHTTPMethod.GET.rawValue, body: nil)
        utils.performRequest(request, callback: {response, error in
            
            var languages = [WatsonLanguage]()
            if let languageArray = response["languages"] as? NSArray {
                
                for languageDictionary in languageArray {
                    if let lang = languageDictionary["language"] as? String {
                        if let nm = languageDictionary["name"] as? String {
                            languages.append(WatsonLanguage(language:lang,name:nm))
                        }
                        else {
                            //TODO: error handling
                            //Missing name
                        }
                    }
                    else {
                        //Missing language
                    }
                }
                //TODO: error handling
                //TODO: Just do a return here or return a nil or empty value?
                //return
            }
            else {
                //Missing language array
            }
            
            callback(languages)
        })
    }
    
    public func identify(text:String, callback: (String?)->()) {
        
        let path = _serviceURL + "/v2/identify"
        let request = utils.buildRequest(path, method: WatsonHTTPMethod.POST.rawValue, body: text.dataUsingEncoding(NSUTF8StringEncoding), textContent: true)
        
        utils.performRequest(request, callback: {response, error in
            if let error_message = response["error_message"] as? String
            {
                self.utils.printDebug("identify(): " + error_message)
                callback(nil)
            }
            else {
                if let rawData = response["rawData"] as! NSData? {
                    if let language = NSString(data: rawData, encoding: NSUTF8StringEncoding) as String?
                    {
                        callback(language)
                    }
                }
            }
        })
    }
    
    public func translate(text:String,sourceLanguage:String,targetLanguage:String,callback: ([String]?)->()) {
        
        let path = _serviceURL + "/v2/translate"
        let body = buildTranslateRequestBody(sourceLanguage, targetLanguage: targetLanguage, text: text)
        let request = utils.buildRequest(path, method: WatsonHTTPMethod.POST.rawValue, body: body)
        
        utils.performRequest(request, callback: {response, error in
            if let error_message = response["error_message"] as? String
            {
                self.utils.printDebug("translate(): " + error_message)
                callback(nil)
            }
            else {
                if let translations = response["translations"] as? NSArray
                {
                    let firstTranslation = translations[0] as! NSDictionary
                    let translation = firstTranslation["translation"] as! String
                    callback([translation])
                }
            }
        })
    }
    
    private func buildTranslateRequestBody(sourceLanguage:String,targetLanguage:String,text:String) -> NSData?
    {
        //TODO: Use optionals
        //TODO: Validation of inputs
        //TODO: Support model objects too
        //TODO: Support arrays of text
        //TODO: Consider alternative to JSON creation below via string manipulation
        var body = "{\n"
        body += "\"source\":\"\(sourceLanguage)\",\n"
        body += "\"target\":\"\(targetLanguage)\",\n"
        body += "\"text\": [\n"
        body += "\"\(text)\"\n"
        body += "]\n"
        body += "}"
        utils.printDebug("buildTranslateRequestBody(): \(body)")
        return body.dataUsingEncoding(NSUTF8StringEncoding)
    }
    
    public func translate(text:[String],sourceLanguage:String,targetLanguage:String,callback: ([String])->()) {
        //TODO: Add support for translating multiple strings in one request
    }
    
    public func translate(model:WatsonLanguageModel,callback: ([String])->()) {
        //TODO: Add support for translating using model objects
    }
    
    //TODO: delete models
    
}