/**
 * Copyright IBM Corporation 2016
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
import Alamofire
import Freddy
import RestKit

/**
 The Watson Personality Insights service uses linguistic analytics to extract a spectrum
 of cognitive and social characteristics from the text data that a person generates
 through blogs, tweets, forum posts, and more.
 */
public class PersonalityInsights {
    
    private let username: String
    private let password: String
    private let serviceURL: String
    private let userAgent = buildUserAgent("watson-apis-ios-sdk/0.6.0 PersonalityInsightsV2")
    private let domain = "com.ibm.watson.developer-cloud.PersonalityInsightsV2"

    /**
     Create a `PersonalityInsights` object.
     
     - parameter username: The username used to authenticate with the service.
     - parameter password: The password used to authenticate with the service.
     - parameter serviceURL: The base URL to use when contacting the service.
     */
    public init(
        username: String,
        password: String,
        serviceURL: String = "https://gateway.watsonplatform.net/personality-insights/api")
    {
        self.username = username
        self.password = password
        self.serviceURL = serviceURL
    }

    /**
     If the given data represents an error returned by the Visual Recognition service, then return
     an NSError with information about the error that occured. Otherwise, return nil.
     
     - parameter data: Raw data returned from the service that may represent an error.
     */
    private func dataToError(data: NSData) -> NSError? {
        do {
            let json = try JSON(data: data)
            let code = try json.int("code")
            let error = try json.string("error")
            let help = try json.string("help")
            let userInfo = [
                NSLocalizedFailureReasonErrorKey: error,
                NSLocalizedRecoverySuggestionErrorKey: help
            ]
            return NSError(domain: domain, code: code, userInfo: userInfo)
        } catch {
            return nil
        }
    }

    /**
     Analyze text to generate a personality profile.
 
     - parameter text: The text to analyze.
     - parameter acceptLanguage: The desired language of the response.
     - parameter contentLanguage: The language of the text being analyzed.
     - parameter includeRaw: If true, then a raw score for each characteristic is returned in
        addition to a normalized score. Raw scores are not compared with a sample population.
        A raw sampling error for each characteristic is also returned.
     - parameter failure: A function executed if an error occurs.
     - parameter success: A function executed with the personality profile.
     */
    public func getProfile(
        text text: String,
        acceptLanguage: String? = nil,
        contentLanguage: String? = nil,
        includeRaw: Bool? = nil,
        failure: (NSError -> Void)? = nil,
        success: Profile -> Void)
    {
        guard let content = text.dataUsingEncoding(NSUTF8StringEncoding) else {
            let failureReason = "Text could not be encoded to NSData with NSUTF8StringEncoding."
            let userInfo = [NSLocalizedFailureReasonErrorKey: failureReason]
            let error = NSError(domain: domain, code: 0, userInfo: userInfo)
            failure?(error)
            return
        }

        getProfile(
            content,
            contentType: "text/plain",
            acceptLanguage: acceptLanguage,
            contentLanguage: contentLanguage,
            includeRaw: includeRaw,
            failure: failure,
            success: success
        )
    }

    /**
     Analyze the text of a webpage to generate a personality profile.
     The HTML tags are stripped before the text is analyzed.

     - parameter html: The webpage that contains text to analyze.
     - parameter acceptLanguage: The desired language of the response.
     - parameter contentLanguage: The language of the text being analyzed.
     - parameter includeRaw: If true, then a raw score for each characteristic is returned in
        addition to a normalized score. Raw scores are not compared with a sample population.
        A raw sampling error for each characteristic is also returned.
     - parameter failure: A function executed if an error occurs.
     - parameter success: A function executed with the personality profile.
     */
    public func getProfile(
        html html: String,
        acceptLanguage: String? = nil,
        contentLanguage: String? = nil,
        includeRaw: Bool? = nil,
        failure: (NSError -> Void)? = nil,
        success: Profile -> Void)
    {
        guard let content = html.dataUsingEncoding(NSUTF8StringEncoding) else {
            let failureReason = "HTML could not be encoded to NSData with NSUTF8StringEncoding."
            let userInfo = [NSLocalizedFailureReasonErrorKey: failureReason]
            let error = NSError(domain: domain, code: 0, userInfo: userInfo)
            failure?(error)
            return
        }

        getProfile(
            content,
            contentType: "text/html",
            acceptLanguage: acceptLanguage,
            contentLanguage: contentLanguage,
            includeRaw: includeRaw,
            failure: failure,
            success: success
        )
    }

    /**
     Analyze input content items to generate a personality profile.
 
     - parameter contentItems: The content items to analyze.
     - parameter includeRaw: If true, then a raw score for each characteristic is returned in
        addition to a normalized score. Raw scores are not compared with a sample population.
        A raw sampling error for each characteristic is also returned.
     - parameter failure: A function executed if an error occurs.
     - parameter success: A function executed with the personality profile.
     */
    public func getProfile(
        contentItems contentItems: [ContentItem],
        acceptLanguage: String? = nil,
        contentLanguage: String? = nil,
        includeRaw: Bool? = nil,
        failure: (NSError -> Void)? = nil,
        success: Profile -> Void)
    {
        let items = contentItems.map { item in item.toJSON() }
        let body = JSON.Dictionary(["contentItems": JSON.Array(items)])
        guard let content = try? body.serialize() else {
            let failureReason = "Content items could not be serialized to JSON."
            let userInfo = [NSLocalizedFailureReasonErrorKey: failureReason]
            let error = NSError(domain: domain, code: 0, userInfo: userInfo)
            failure?(error)
            return
        }

        getProfile(
            content,
            contentType: "application/json",
            acceptLanguage: acceptLanguage,
            contentLanguage: contentLanguage,
            includeRaw: includeRaw,
            failure: failure,
            success: success
        )
    }


    /**
     Analyze content to generate a personality profile.
 
     - parameter content: The content to analyze.
     - parameter contentType: The MIME content-type of the content.
     - parameter acceptLanguage: The desired language of the response.
     - parameter contentLanguage: The language of the text being analyzed.
     - parameter includeRaw: If true, then a raw score for each characteristic is returned in
        addition to a normalized score. Raw scores are not compared with a sample population.
        A raw sampling error for each characteristic is also returned.
     - parameter failure: A function executed if an error occurs.
     - parameter success: A function executed with the personality profile.
     */
    private func getProfile(
        content: NSData?,
        contentType: String,
        acceptLanguage: String? = nil,
        contentLanguage: String? = nil,
        includeRaw: Bool? = nil,
        failure: (NSError -> Void)? = nil,
        success: Profile -> Void)
    {
        // construct query parameters
        var queryParameters = [NSURLQueryItem]()
        if let includeRaw = includeRaw {
            let queryParameter = NSURLQueryItem(name: "include_raw", value: "\(includeRaw)")
            queryParameters.append(queryParameter)
        }

        // construct header parameters
        var headerParameters = [String: String]()
        if let acceptLanguage = acceptLanguage {
            headerParameters["Accept-Language"] = acceptLanguage
        }
        if let contentLanguage = contentLanguage {
            headerParameters["Content-Language"] = contentLanguage
        }

        // construct REST request
        let request = RestRequest(
            method: .POST,
            url: serviceURL + "/v2/profile",
            acceptType: "application/json",
            contentType: contentType,
            userAgent: userAgent,
            queryParameters: queryParameters,
            headerParameters: headerParameters,
            messageBody: content
        )

        // execute REST request
        Alamofire.request(request)
            .authenticate(user: username, password: password)
            .responseObject(dataToError: dataToError) {
                (response: Response<Profile, NSError>) in
                switch response.result {
                case .Success(let profile): success(profile)
                case .Failure(let error): failure?(error)
                }
        }
    }
}
