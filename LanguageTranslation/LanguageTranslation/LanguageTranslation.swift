//
//  LanguageTranslationAdapter.swift
//  LanguageTranslationSDK
//
//  Created by Karl Weinmeister on 9/3/15.
//  Copyright (c) 2015 IBM MIL. All rights reserved.
//

import Foundation

//TODO: document functions

public class LanguageTranslation {
    
    private let TAG = "[LanguageTranslation] "

    //TODO: Move the GET/POST/PUT constants into a common project
    private let GET = "GET"
    private let POST = "POST"
    private let PUT = "PUT"
    
    private var _languages:[Language]?
    private let _baseURL = "https://gateway.watsonplatform.net/language-translation/api"
    private let utils = LanguageTranslationUtils()

    public init(username:String,password:String) {
        //TODO: Handle 401 errors (no or wrong username/password)
        setUsernameAndPassword(username,password:password)
        //TODO: Handle edge case where language list is not yet initialized by the time the user calls translate()
        //getIdentifiableLanguages({ self._languages = $0 })
    }

    //TODO: Move the logic below to a common project
    public func setUsernameAndPassword(username:String,password:String)
    {
        let authorizationString = username + ":" + password
        utils.apiKey = "Basic " + (authorizationString.dataUsingEncoding(NSASCIIStringEncoding)?.base64EncodedStringWithOptions(NSDataBase64EncodingOptions.Encoding76CharacterLineLength))!
    
    }
    public func getIdentifiableLanguages(callback: ([Language])->()) {
            let endpoint = _baseURL + "/v2/identifiable_languages"
            
            let request = utils.buildRequest(endpoint, method: GET, body: nil)
            utils.performRequest(request, callback: {response in

            var languages = [Language]()
                if let languageArray = response["languages"] as? NSArray {
                    
                for languageDictionary in languageArray {
                    if let lang = languageDictionary["language"] as? String {
                        if let nm = languageDictionary["name"] as? String {
                            languages.append(Language(language:lang,name:nm))
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
    
    public func translate(text:String,sourceLanguage:String,targetLanguage:String,callback: ([String]?)->()) {

        let endpoint = _baseURL + "/v2/translate"
        let body = buildTranslateRequestBody(sourceLanguage, targetLanguage: targetLanguage, text: text)
        let request = utils.buildRequest(endpoint, method: POST, body: body)

        utils.performRequest(request, callback: {response in
            if let error_message = response["error_message"] as? String
            {
                self.utils.printDebug("translate(): " + error_message)
                callback(nil)
            }
            else {
                var translatedText = [String]()
                callback(translatedText)
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

    public func translate(model:LanguageModel,callback: ([String])->()) {
        //TODO: Add support for translating using model objects
    }
    
    //TODO: delete models

}