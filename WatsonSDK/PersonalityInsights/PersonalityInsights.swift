//
//  PersonalityInsights.swift
//  PersonalityInsights
//
//  Created by Karl Weinmeister on 10/27/15.
//  Copyright © 2015 Watson Developer Cloud. All rights reserved.
//

import Foundation
import ObjectMapper

/// The Watson Personality Insights service uses linguistic analytics to extract a spectrum of cognitive and social characteristics from the text data that a person generates through blogs, tweets, forum posts, and more.
public class PersonalityInsights: Service {
    private let _serviceURL = "/personality-insights/api"
 
    public init() {
        super.init(serviceURL:_serviceURL)
    }
    
    /**
     Takes input text and generates a personality profile.
     
     - parameter text:           (Required) The text to analyze, plain text (the default) or HTML.
     - parameter includeRaw:     If true, a raw score for each characteristic is returned in addition to a normalized score; raw scores are not compared with a sample population. A raw sampling error for each characteristic is also returned. Default: 'false'.
     - parameter language:       The request language. Both English ("en") and Spanish ("es") are supported. Default: 'en'.
     - parameter acceptLanguage: The desired language of the response. Both English ("en") and Spanish ("es") are supported
     - parameter callback:       Method to be invoked with the populated Profile object
     */
    public func getProfile(text:String, includeRaw: Bool = false, language:String = PersonalityInsightsConstants.defaultLanguage, acceptLanguage:String = PersonalityInsightsConstants.defaultAcceptLanguage, callback: (Profile?)->()) {
        getProfile(text, contentItems: nil, includeRaw:includeRaw, language:language, acceptLanguage:acceptLanguage, callback:callback)
    }
    
    /**
     Takes content items model and generates a personality profile.
     
     - parameter contentItems:   (Required) A JSON request must conform to the ContentItem model.
     - parameter includeRaw:     If true, a raw score for each characteristic is returned in addition to a normalized score; raw scores are not compared with a sample population. A raw sampling error for each characteristic is also returned. Default: 'false'.
     - parameter language:       The request language. Both English ("en") and Spanish ("es") are supported. Default: 'en'.
     - parameter acceptLanguage: The desired language of the response. Both English ("en") and Spanish ("es") are supported
     - parameter callback:       Method to be invoked with the populated Profile object
     */
    public func getProfile(contentItems:[ContentItem], includeRaw: Bool = false, language:String = PersonalityInsightsConstants.defaultLanguage, acceptLanguage:String = PersonalityInsightsConstants.defaultAcceptLanguage, callback: (Profile?)->()) {
        getProfile(nil, contentItems:contentItems, includeRaw:includeRaw, language:language, acceptLanguage:acceptLanguage, callback:callback)
    }

    /**
     Private function that both getProfile() methods flow through for code reuse
     */
    private func getProfile(text:String? = nil, contentItems:[ContentItem]? = nil, includeRaw: Bool, language:String, acceptLanguage:String, callback: (Profile?)->()) {
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
            callback(Mapper<Profile>().map(response.data))
        })
    }    
}