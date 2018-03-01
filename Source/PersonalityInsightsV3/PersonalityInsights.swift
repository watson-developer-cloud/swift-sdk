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

/**
 The Watson Personality Insights service uses linguistic analytics to extract a spectrum
 of cognitive and social characteristics from the text data that a person generates
 through blogs, tweets, forum posts, and more.
 */
public class PersonalityInsights {

    /// The base URL to use when contacting the service.
    public var serviceURL = "https://gateway.watsonplatform.net/personality-insights/api"

    /// The default HTTP headers for all requests to the service.
    public var defaultHeaders = [String: String]()

    private let credentials: Credentials
    private let version: String
    private let domain = "com.ibm.watson.developer-cloud.PersonalityInsightsV3"

    /**
     Create a `PersonalityInsights` object.

     - parameter username: The username used to authenticate with the service.
     - parameter password: The password used to authenticate with the service.
     - parameter version: The release date of the version of the API to use. Specify the date
            in "YYYY-MM-DD" format.
     */
    public init(username: String, password: String, version: String) {
        credentials = Credentials.basicAuthentication(username: username, password: password)
        self.version = version
    }

    /**
     If the response or data represents an error returned by the Personality Insights service,
     then return NSError with information about the error that occured. Otherwise, return nil.

     - parameter response: the URL response returned from the service.
     - parameter data: Raw data returned from the service that may represent an error.
     */
    private func responseToError(response: HTTPURLResponse?, data: Data?) -> NSError? {

        // First check http status code in response
        if let response = response {
            if (200..<300).contains(response.statusCode) {
                return nil
            }
        }

        // ensure data is not nil
        guard let data = data else {
            if let code = response?.statusCode {
                return NSError(domain: domain, code: code, userInfo: nil)
            }
            return nil  // RestKit will generate error for this case
        }

        do {
            let json = try JSONWrapper(data: data)
            let code = response?.statusCode ?? 400
            let message = try json.getString(at: "error")
            var userInfo = [NSLocalizedDescriptionKey: message]
            let help = try? json.getString(at: "help")
            let description = try? json.getString(at: "description")
            if let recoverySuggestion = help ?? description {
                userInfo[NSLocalizedRecoverySuggestionErrorKey] = recoverySuggestion
            }
            return NSError(domain: domain, code: code, userInfo: userInfo)
        } catch {
            return nil
        }
    }

    /**
     Analyze text to generate a personality profile.

     - parameter fromText: The text to analyze.
     - parameter acceptLanguage: The desired language of the response.
     - parameter contentLanguage: The language of the text being analyzed.
     - parameter rawScores: If true, then a raw score for each characteristic is returned in
        addition to a normalized score. Raw scores are not compared with a sample population.
        An average Mean Absolute Error (MAE) is returned to measure the results' precision.
     - parameter consumptionPreferences: If true, then information inferred about consumption
        preferences is returned in addition to the results.
     - parameter failure: A function executed if an error occurs.
     - parameter success: A function executed with the personality profile.
     */
    public func getProfile(
        fromText text: String,
        acceptLanguage: String? = nil,
        contentLanguage: String? = nil,
        rawScores: Bool? = nil,
        consumptionPreferences: Bool? = nil,
        failure: ((Error) -> Void)? = nil,
        success: @escaping (Profile) -> Void)
    {
        guard let content = text.data(using: String.Encoding.utf8) else {
            let failureReason = "Text could not be encoded to NSData with NSUTF8StringEncoding."
            let userInfo = [NSLocalizedDescriptionKey: failureReason]
            let error = NSError(domain: domain, code: 0, userInfo: userInfo)
            failure?(error)
            return
        }

        getProfile(
            fromContent: content,
            withType: "text/plain",
            acceptLanguage: acceptLanguage,
            contentLanguage: contentLanguage,
            rawScores: rawScores,
            consumptionPreferences: consumptionPreferences,
            failure: failure,
            success: success
        )
    }

    /**
     Analyze the text of a webpage to generate a personality profile.
     The HTML tags are stripped before the text is analyzed.

     - parameter fromHTML: The HTML text to analyze.
     - parameter acceptLanguage: The desired language of the response.
     - parameter contentLanguage: The language of the text being analyzed.
     - parameter rawScores: If true, then a raw score for each characteristic is returned in
        addition to a normalized score. Raw scores are not compared with a sample population.
        An average Mean Absolute Error (MAE) is returned to measure the results' precision.
     - parameter consumptionPreferences: If true, then information inferred about consumption
        preferences is returned in addition to the results.
     - parameter failure: A function executed if an error occurs.
     - parameter success: A function executed with the personality profile.
     */
    public func getProfile(
        fromHTML html: String,
        acceptLanguage: String? = nil,
        contentLanguage: String? = nil,
        rawScores: Bool? = nil,
        consumptionPreferences: Bool? = nil,
        failure: ((Error) -> Void)? = nil,
        success: @escaping (Profile) -> Void)
    {
        guard let content = html.data(using: String.Encoding.utf8) else {
            let failureReason = "HTML could not be encoded to NSData with NSUTF8StringEncoding."
            let userInfo = [NSLocalizedDescriptionKey: failureReason]
            let error = NSError(domain: domain, code: 0, userInfo: userInfo)
            failure?(error)
            return
        }

        getProfile(
            fromContent: content,
            withType: "text/html",
            acceptLanguage: acceptLanguage,
            contentLanguage: contentLanguage,
            rawScores: rawScores,
            consumptionPreferences: consumptionPreferences,
            failure: failure,
            success: success
        )
    }

    /**
     Analyze input content items to generate a personality profile.

     - parameter fromContentItems: The content items to analyze.
     - parameter acceptLanguage: The desired language of the response.
     - parameter contentLanguage: The language of the text being analyzed.
     - parameter rawScores: If true, then a raw score for each characteristic is returned in
        addition to a normalized score. Raw scores are not compared with a sample population.
        An average Mean Absolute Error (MAE) is returned to measure the results' precision.
     - parameter consumptionPreferences: If true, then information inferred about consumption
        preferences is returned in addition to the results.
     - parameter failure: A function executed if an error occurs.
     - parameter success: A function executed with the personality profile.
     */
    public func getProfile(
        fromContentItems contentItems: [ContentItem],
        acceptLanguage: String? = nil,
        contentLanguage: String? = nil,
        rawScores: Bool? = nil,
        consumptionPreferences: Bool? = nil,
        failure: ((Error) -> Void)? = nil,
        success: @escaping (Profile) -> Void)
    {
        let json = JSONWrapper(dictionary: ["contentItems": contentItems.map { $0.toJSONObject() }])
        guard let content = try? json.serialize() else {
            let failureReason = "Content items could not be serialized to JSON."
            let userInfo = [NSLocalizedDescriptionKey: failureReason]
            let error = NSError(domain: domain, code: 0, userInfo: userInfo)
            failure?(error)
            return
        }

        getProfile(
            fromContent: content,
            withType: "application/json",
            acceptLanguage: acceptLanguage,
            contentLanguage: contentLanguage,
            rawScores: rawScores,
            consumptionPreferences: consumptionPreferences,
            failure: failure,
            success: success
        )
    }

    /**
     Analyze content to generate a personality profile.

     - parameter fromContent: The content to analyze.
     - parameter withType: The MIME content-type of the content.
     - parameter acceptLanguage: The desired language of the response.
     - parameter contentLanguage: The language of the text being analyzed.
     - parameter rawScores: If true, then a raw score for each characteristic is returned in
        addition to a normalized score. Raw scores are not compared with a sample population.
        An average Mean Absolute Error (MAE) is returned to measure the results' precision.
     - parameter consumptionPreferences: If true, then information inferred about consumption
        preferences is returned in addition to the results.
     - parameter failure: A function executed if an error occurs.
     - parameter success: A function executed with the personality profile.
     */
    private func getProfile(
        fromContent content: Data?,
        withType contentType: String,
        acceptLanguage: String? = nil,
        contentLanguage: String? = nil,
        rawScores: Bool? = nil,
        consumptionPreferences: Bool? = nil,
        failure: ((Error) -> Void)? = nil,
        success: @escaping (Profile) -> Void)
    {
        // construct query parameters
        var queryParameters = [URLQueryItem]()
        queryParameters.append(URLQueryItem(name: "version", value: version))
        if let rawScores = rawScores {
            queryParameters.append(URLQueryItem(name: "raw_scores", value: "\(rawScores)"))
        }
        if let consumptionPreferences = consumptionPreferences {
            queryParameters.append(URLQueryItem(name: "consumption_preferences", value: "\(consumptionPreferences)"))
        }

        // construct header parameters
        var headerParameters = defaultHeaders
        if let acceptLanguage = acceptLanguage {
            headerParameters["Accept-Language"] = acceptLanguage
        }
        if let contentLanguage = contentLanguage {
            headerParameters["Content-Language"] = contentLanguage
        }

        // construct REST request
        let request = RestRequest(
            method: "POST",
            url: serviceURL + "/v3/profile",
            credentials: credentials,
            headerParameters: headerParameters,
            acceptType: "application/json",
            contentType: contentType,
            queryItems: queryParameters,
            messageBody: content
        )

        // execute REST request
        request.responseObject(responseToError: responseToError) {
            (response: RestResponse<Profile>) in
                switch response.result {
                case .success(let profile): success(profile)
                case .failure(let error): failure?(error)
                }
        }
    }
}
