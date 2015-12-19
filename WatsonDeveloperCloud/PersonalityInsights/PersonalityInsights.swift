/**
 * Copyright IBM Corporation 2015
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 **/

import Foundation
import ObjectMapper

/**
 The Watson Personality Insights service uses linguistic analytics to extract a spectrum
 of cognitive and social characteristics from the text data that a person generates
 through blogs, tweets, forum posts, and more.
 */
public class PersonalityInsights: WatsonService {
    
    // The shared WatsonGateway singleton.
    let gateway = WatsonGateway.sharedInstance
    
    // The authentication strategy to obtain authorization tokens.
    var authStrategy: AuthenticationStrategy
    
    public required init(authStrategy: AuthenticationStrategy) {
        self.authStrategy = authStrategy
    }
    
    public convenience required init(username: String, password: String) {
        let authStrategy = BasicAuthenticationStrategy(tokenURL: Constants.tokenURL,
            serviceURL: Constants.serviceURL, username: username, password: password)
        self.init(authStrategy: authStrategy)
    }
    
    /**
     Analyze input text to generate a personality profile.
     
     - Parameters
        - text: The text to analyze.
        - includeRaw: If true, a raw score for each characteristic is returned in
                in addition to a normalized score. Raw scores are not compared with
                a sample population. A raw sampling error for each characteristic
                is also returned. Default: "false".
        - language: The request language. Both English ("en") and Spanish ("es") are
                supported.
        - acceptLanguage: The desired language of the response. Both English ("en")
                and Spanish ("es") are supported.
        - completionHandler: A function invoked with the response from Watson.
     */
    public func getProfile(
        text: String,
        acceptLanguage: String? = nil,
        contentLanguage: String? = nil,
        includeRaw: Bool? = nil,
        completionHandler: (Profile?, NSError?) -> Void) {
        
        // construct url query parameters
        var urlParams = [NSURLQueryItem]()
        if let includeRaw = includeRaw {
            urlParams.append(NSURLQueryItem(name: "include_raw", value: "\(includeRaw)"))
        }
            
        // construct header parameters
        var headerParams = [String: String]()
        if let acceptLanguage = acceptLanguage {
            headerParams["Accept-Language"] = acceptLanguage
        }
        if let contentLanguage = contentLanguage {
            headerParams["Content-Language"] = contentLanguage
        }
            
        // construct request
        let request = WatsonRequest(
            method: .POST,
            serviceURL: Constants.serviceURL,
            endpoint: Constants.profile,
            authStrategy: authStrategy,
            accept: .JSON,
            contentType: .Plain,
            urlParams: urlParams,
            headerParams: headerParams,
            messageBody: text.dataUsingEncoding(NSUTF8StringEncoding))
        
        // execute request
        gateway.request(request, serviceError: PersonalityInsightsError()) { data, error in
            let profile = Mapper<Profile>().mapData(data)
            completionHandler(profile, error)
        }
    }
    
    /**
     Analyze input context items to generate a personality profile.
     
     - Parameters
        - contentItems: The content items to analyze.
        - includeRaw: If true, a raw score for each characteristic is returned in
                in addition to a normalized score. Raw scores are not compared with
                a sample population. A raw sampling error for each characteristic
                is also returned. Default: "false".
        - language: The request language. Both English ("en") and Spanish ("es") are
                supported.
        - acceptLanguage: The desired language of the response. Both English ("en")
                and Spanish ("es") are supported.
        - completionHandler: A function invoked with the response from Watson.
     */
    public func getProfile(
        contentItems: [ContentItem],
        acceptLanguage: String? = nil,
        contentLanguage: String? = nil,
        includeRaw: Bool? = nil,
        completionHandler: (Profile?, NSError?) -> Void) {
            
        // construct url query parameters
        var urlParams = [NSURLQueryItem]()
        if let includeRaw = includeRaw {
            urlParams.append(NSURLQueryItem(name: "include_raw", value: "\(includeRaw)"))
        }
        
        // construct header parameters
        var headerParams = [String: String]()
        if let acceptLanguage = acceptLanguage {
            headerParams["Accept-Language"] = acceptLanguage
        }
        if let contentLanguage = contentLanguage {
            headerParams["Content-Language"] = contentLanguage
        }
        
        // construct request
        let request = WatsonRequest(
            method: .POST,
            serviceURL: Constants.serviceURL,
            endpoint: Constants.profile,
            authStrategy: authStrategy,
            accept: .JSON,
            contentType: .JSON,
            urlParams: urlParams,
            headerParams: headerParams,
            messageBody: Mapper().toJSONData(contentItems, header: "contentItems"))
        
        // execute request
        gateway.request(request, serviceError: PersonalityInsightsError()) { data, error in
            let profile = Mapper<Profile>().mapData(data)
            completionHandler(profile, error)
        }
    }
}