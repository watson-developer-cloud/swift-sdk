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
    
    //TODO: Add comments
    
    public init() {
        super.init(serviceURL:_serviceURL)
    }
    
    public func getProfile(text:String, includeRaw: Bool = false, language:String = PersonalityInsightsConstants.defaultLanguage, acceptLanguage:String = PersonalityInsightsConstants.defaultAcceptLanguage, callback: (Profile?)->()) {
        getProfile(text, contentItems: nil, includeRaw:includeRaw, language:language, acceptLanguage:acceptLanguage, callback:callback)
    }
    
    public func getProfile(contentItems:[ContentItem], includeRaw: Bool = false, language:String = PersonalityInsightsConstants.defaultLanguage, acceptLanguage:String = PersonalityInsightsConstants.defaultAcceptLanguage, callback: (Profile?)->()) {
        getProfile(nil, contentItems:contentItems, includeRaw:includeRaw, language:language, acceptLanguage:acceptLanguage, callback:callback)
    }

    private func getProfile(text:String? = nil, contentItems:[ContentItem]? = nil, includeRaw: Bool, language:String, acceptLanguage:String, callback: (Profile?)->()) {
        //TODO: If not enough words, let the SDK user know
        //TODO: Figure out why description printout of the error gives a short version, i.e. 400 - bad request rather than the real error
        let endpoint = getEndpoint("/v2/profile")
        
        var params = Dictionary<String, AnyObject>()
        
        if let text = text {
            params.updateValue(text, forKey: PersonalityInsightsConstants.text)
        } else if let contentItems = contentItems {
            
            //Create string that starts with JSON array element contentItems
            var contentItemsStr = "{\"" + PersonalityInsightsConstants.contentItems + "\":["
            
            //Iterate through each contentItem and append the item as a JSON string
            for (index, element) in contentItems.enumerate() {
                if let contentItemStr = Mapper().toJSONString(element, prettyPrint: true)
                {
                    contentItemsStr += contentItemStr
                    //Add separator to the end of all items except for the last
                    if index < contentItems.count - 1 { contentItemsStr += "," }
                }
            }
            //Close the array
            contentItemsStr += "]}"
            
            params.updateValue(contentItemsStr, forKey: PersonalityInsightsConstants.contentItems)
        }
        params.updateValue(language, forKey: PersonalityInsightsConstants.language)
        params.updateValue(acceptLanguage, forKey: PersonalityInsightsConstants.acceptLanguage)
        params.updateValue(includeRaw, forKey: PersonalityInsightsConstants.includeRaw)
        
        NetworkUtils.performBasicAuthRequest(endpoint, method: HTTPMethod.POST, contentType:ContentType.Text, parameters: params, apiKey: _apiKey, completionHandler: {response in
            callback(Mapper<Profile>().map(response.data as! String))
        })
    }    
}