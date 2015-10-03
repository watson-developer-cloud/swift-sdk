//
//  LanguageTranslation.swift
//  LanguageTranslation
//
//  Created by Karl Weinmeister on 9/16/15.
//  Copyright © 2015 IBM Mobile Innovation Lab. All rights reserved.
//

import WatsonCore
import Foundation


 /// The IBM Watson Language Translation service translate text from one language
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
    public func getIdentifiableLanguages(callback: ([Language])->()) {
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
                if let rawData = response["rawData"] as! NSData? {
                    if let language = NSString(data: rawData, encoding: NSUTF8StringEncoding) as String?
                    {
                        callback(language)
                    }
                }
            }
        })
    }
    
    /**
    Translate text using source and target languages
    
    - parameter text:           The text to translate
    - parameter sourceLanguage: The language that the original text is written in
    - parameter targetLanguage: The language that the text will be translated into
    - parameter callback:       The callback method that is invoked with the translated string
    */
    public func translate(text:String,sourceLanguage:String,targetLanguage:String,callback: ([String]?)->()) {
        
        let path = _serviceURL + "/v2/translate"
        let body = buildTranslateRequestBody(sourceLanguage, targetLanguage: targetLanguage, text: text)
        let request = utils.buildRequest(path, method: HTTPMethod.POST, body: body)
        
        utils.performRequest(request!, callback: {response, error in
            if let error_message = response["error_message"] as? String
            {
                WatsonLog("translate(): " + error_message, prefix:self.TAG)
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
        WatsonDebug("buildTranslateRequestBody(): \(body)", prefix:self.TAG)
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