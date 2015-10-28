//
//  PersonalityInsights.swift
//  PersonalityInsights
//
//  Created by Karl Weinmeister on 10/27/15.
//  Copyright © 2015 Watson Developer Cloud. All rights reserved.
//

import Foundation
import WatsonCore
import ObjectMapper

/// The Watson Personality Insights service uses linguistic analytics to extract a spectrum of cognitive and social characteristics from the text data that a person generates through blogs, tweets, forum posts, and more.
public class PersonalityInsights: Service {
    private let _serviceURL = "/personality-insights/api"
    
    public init() {
        super.init(serviceURL:_serviceURL)
    }
    
    /**
    Retrieves the list of identifiable languages
    
    - parameter callback: callback method that is invoked with the identifiable languages
    */
    public func getProfile(text:String, callback: (Profile?)->()) {
        //TODO: If not enough words, let the SDK user know
        //TODO: Figure out why description printout of the error gives a short version, i.e. 400 - bad request rather than the real error
        //TODO: Swift 7.1
        //TODO: Additional parameters, support JSON, etc.
        let endpoint = getEndpoint("/v2/profile")
        
        var params = Dictionary<String, AnyObject>()
        params.updateValue(text, forKey: "text")
        NetworkUtils.performBasicAuthRequest(endpoint, method: HTTPMethod.POST, contentType:ContentType.Text, parameters: params, apiKey: _apiKey, completionHandler: {response in
            let profile = Mapper<Profile>().map(response.data)
            callback(profile)
//            var languages : [IdentifiableLanguage] = []
//            
//            if let rawLanguages = response.data[LanguageTranslationConstants.languages] {
//                for rawLanguage in rawLanguages as! NSArray {
//                    if let language = Mapper<IdentifiableLanguage>().map(rawLanguage) {
//                        languages.append(language)
//                    }
//                }
//            }
//            callback(languages)
        })
    }
    
 }