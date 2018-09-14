/**
 * Copyright IBM Corporation 2018
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
// swiftlint:disable file_length

import Foundation
import RestKit

/**
 The IBM Watson&trade; Personality Insights service enables applications to derive insights from social media,
 enterprise data, or other digital communications. The service uses linguistic analytics to infer individuals' intrinsic
 personality characteristics, including Big Five, Needs, and Values, from digital communications such as email, text
 messages, tweets, and forum posts.
 The service can automatically infer, from potentially noisy social media, portraits of individuals that reflect their
 personality characteristics. The service can infer consumption preferences based on the results of its analysis and,
 for JSON content that is timestamped, can report temporal behavior.
 * For information about the meaning of the models that the service uses to describe personality characteristics, see
 [Personality models](https://console.bluemix.net/docs/services/personality-insights/models.html).
 * For information about the meaning of the consumption preferences, see [Consumption
 preferences](https://console.bluemix.net/docs/services/personality-insights/preferences.html).
 **Note:** Request logging is disabled for the Personality Insights service. The service neither logs nor retains data
 from requests and responses, regardless of whether the `X-Watson-Learning-Opt-Out` request header is set.
 */
public class PersonalityInsights {

    /// The base URL to use when contacting the service.
    public var serviceURL = "https://gateway.watsonplatform.net/personality-insights/api"

    /// The default HTTP headers for all requests to the service.
    public var defaultHeaders = [String: String]()

    private let session = URLSession(configuration: URLSessionConfiguration.default)
    private var authMethod: AuthenticationMethod
    private let domain = "com.ibm.watson.developer-cloud.PersonalityInsightsV3"
    private let version: String

    /**
     Create a `PersonalityInsights` object.

     - parameter username: The username used to authenticate with the service.
     - parameter password: The password used to authenticate with the service.
     - parameter version: The release date of the version of the API to use. Specify the date
       in "YYYY-MM-DD" format.
     */
    public init(username: String, password: String, version: String) {
        self.authMethod = Shared.getAuthMethod(username: username, password: password)
        self.version = version
        Shared.configureRestRequest()
    }

    /**
     Create a `PersonalityInsights` object.

     - parameter version: The release date of the version of the API to use. Specify the date
       in "YYYY-MM-DD" format.
     - parameter apiKey: An API key for IAM that can be used to obtain access tokens for the service.
     - parameter iamUrl: The URL for the IAM service.
     */
    public init(version: String, apiKey: String, iamUrl: String? = nil) {
        self.authMethod = Shared.getAuthMethod(apiKey: apiKey, iamURL: iamUrl)
        self.version = version
        Shared.configureRestRequest()
    }

    /**
     Create a `PersonalityInsights` object.

     - parameter version: The release date of the version of the API to use. Specify the date
       in "YYYY-MM-DD" format.
     - parameter accessToken: An access token for the service.
     */
    public init(version: String, accessToken: String) {
        self.authMethod = IAMAccessToken(accessToken: accessToken)
        self.version = version
        Shared.configureRestRequest()
    }

    public func accessToken(_ newToken: String) {
        if self.authMethod is IAMAccessToken {
            self.authMethod = IAMAccessToken(accessToken: newToken)
        }
    }

    /**
     If the response or data represents an error returned by the Personality Insights service,
     then return NSError with information about the error that occured. Otherwise, return nil.

     - parameter data: Raw data returned from the service that may represent an error.
     - parameter response: the URL response returned from the service.
     */
    private func errorResponseDecoder(data: Data, response: HTTPURLResponse) -> Error {

        let code = response.statusCode
        do {
            let json = try JSONDecoder().decode([String: JSON].self, from: data)
            var userInfo: [String: Any] = [:]
            if case let .some(.string(message)) = json["error"] {
                userInfo[NSLocalizedDescriptionKey] = message
            }
            if case let .some(.string(help)) = json["help"] {
                userInfo[NSLocalizedFailureReasonErrorKey] = help
            }
            return NSError(domain: domain, code: code, userInfo: userInfo)
        } catch {
            return NSError(domain: domain, code: code, userInfo: nil)
        }
    }

    /**
     Get profile.

     Generates a personality profile for the author of the input text. The service accepts a maximum of 20 MB of input
     content, but it requires much less text to produce an accurate profile; for more information, see [Providing
     sufficient input](https://console.bluemix.net/docs/services/personality-insights/input.html#sufficient). The
     service analyzes text in Arabic, English, Japanese, Korean, or Spanish and returns its results in a variety of
     languages. You can provide plain text, HTML, or JSON input by specifying the **Content-Type** parameter; the
     default is `text/plain`. Request a JSON or comma-separated values (CSV) response by specifying the **Accept**
     parameter; CSV output includes a fixed number of columns and optional headers.
     Per the JSON specification, the default character encoding for JSON content is effectively always UTF-8; per the
     HTTP specification, the default encoding for plain text and HTML is ISO-8859-1 (effectively, the ASCII character
     set). When specifying a content type of plain text or HTML, include the `charset` parameter to indicate the
     character encoding of the input text; for example: `Content-Type: text/plain;charset=utf-8`.
     For detailed information about calling the service and the responses it can generate, see [Requesting a
     profile](https://console.bluemix.net/docs/services/personality-insights/input.html), [Understanding a JSON
     profile](https://console.bluemix.net/docs/services/personality-insights/output.html), and [Understanding a CSV
     profile](https://console.bluemix.net/docs/services/personality-insights/output-csv.html).

     - parameter profileContent: A maximum of 20 MB of content to analyze, though the service requires much less text;
       for more information, see [Providing sufficient
       input](https://console.bluemix.net/docs/services/personality-insights/input.html#sufficient). For JSON input,
       provide an object of type `Content`.
     - parameter contentLanguage: The language of the input text for the request: Arabic, English, Japanese, Korean,
       or Spanish. Regional variants are treated as their parent language; for example, `en-US` is interpreted as `en`.
       The effect of the **Content-Language** parameter depends on the **Content-Type** parameter. When **Content-Type**
       is `text/plain` or `text/html`, **Content-Language** is the only way to specify the language. When
       **Content-Type** is `application/json`, **Content-Language** overrides a language specified with the `language`
       parameter of a `ContentItem` object, and content items that specify a different language are ignored; omit this
       parameter to base the language on the specification of the content items. You can specify any combination of
       languages for **Content-Language** and **Accept-Language**.
     - parameter acceptLanguage: The desired language of the response. For two-character arguments, regional variants
       are treated as their parent language; for example, `en-US` is interpreted as `en`. You can specify any
       combination of languages for the input and response content.
     - parameter rawScores: Indicates whether a raw score in addition to a normalized percentile is returned for each
       characteristic; raw scores are not compared with a sample population. By default, only normalized percentiles are
       returned.
     - parameter consumptionPreferences: Indicates whether consumption preferences are returned with the results. By
       default, no consumption preferences are returned.
     - parameter headers: A dictionary of request headers to be sent with this request.
     - parameter failure: A function executed if an error occurs.
     - parameter success: A function executed with the successful result.
     */
    public func profile(
        profileContent: ProfileContent,
        contentLanguage: String? = nil,
        acceptLanguage: String? = nil,
        rawScores: Bool? = nil,
        consumptionPreferences: Bool? = nil,
        headers: [String: String]? = nil,
        failure: ((Error) -> Void)? = nil,
        success: @escaping (Profile) -> Void)
    {
        // construct body
        guard let body = profileContent.content else {
            failure?(RestError.serializationError)
            return
        }

        // construct header parameters
        var headerParameters = defaultHeaders
        if let headers = headers {
            headerParameters.merge(headers) { (_, new) in new }
        }
        headerParameters["Accept"] = "application/json"
        headerParameters["Content-Type"] = profileContent.contentType
        if let contentLanguage = contentLanguage {
            headerParameters["Content-Language"] = contentLanguage
        }
        if let acceptLanguage = acceptLanguage {
            headerParameters["Accept-Language"] = acceptLanguage
        }

        // construct query parameters
        var queryParameters = [URLQueryItem]()
        queryParameters.append(URLQueryItem(name: "version", value: version))
        if let rawScores = rawScores {
            let queryParameter = URLQueryItem(name: "raw_scores", value: "\(rawScores)")
            queryParameters.append(queryParameter)
        }
        if let consumptionPreferences = consumptionPreferences {
            let queryParameter = URLQueryItem(name: "consumption_preferences", value: "\(consumptionPreferences)")
            queryParameters.append(queryParameter)
        }

        // construct REST request
        let request = RestRequest(
            session: session,
            authMethod: authMethod,
            errorResponseDecoder: errorResponseDecoder,
            method: "POST",
            url: serviceURL + "/v3/profile",
            headerParameters: headerParameters,
            queryItems: queryParameters,
            messageBody: body
        )

        // execute REST request
        request.responseObject {
            (response: RestResponse<Profile>) in
            switch response.result {
            case .success(let retval): success(retval)
            case .failure(let error): failure?(error)
            }
        }
    }

    /**
     Get profile as csv.

     Generates a personality profile for the author of the input text. The service accepts a maximum of 20 MB of input
     content, but it requires much less text to produce an accurate profile; for more information, see [Providing
     sufficient input](https://console.bluemix.net/docs/services/personality-insights/input.html#sufficient). The
     service analyzes text in Arabic, English, Japanese, Korean, or Spanish and returns its results in a variety of
     languages. You can provide plain text, HTML, or JSON input by specifying the **Content-Type** parameter; the
     default is `text/plain`. Request a JSON or comma-separated values (CSV) response by specifying the **Accept**
     parameter; CSV output includes a fixed number of columns and optional headers.
     Per the JSON specification, the default character encoding for JSON content is effectively always UTF-8; per the
     HTTP specification, the default encoding for plain text and HTML is ISO-8859-1 (effectively, the ASCII character
     set). When specifying a content type of plain text or HTML, include the `charset` parameter to indicate the
     character encoding of the input text; for example: `Content-Type: text/plain;charset=utf-8`.
     For detailed information about calling the service and the responses it can generate, see [Requesting a
     profile](https://console.bluemix.net/docs/services/personality-insights/input.html), [Understanding a JSON
     profile](https://console.bluemix.net/docs/services/personality-insights/output.html), and [Understanding a CSV
     profile](https://console.bluemix.net/docs/services/personality-insights/output-csv.html).

     - parameter profileContent: A maximum of 20 MB of content to analyze, though the service requires much less text;
       for more information, see [Providing sufficient
       input](https://console.bluemix.net/docs/services/personality-insights/input.html#sufficient). For JSON input,
       provide an object of type `Content`.
     - parameter contentLanguage: The language of the input text for the request: Arabic, English, Japanese, Korean,
       or Spanish. Regional variants are treated as their parent language; for example, `en-US` is interpreted as `en`.
       The effect of the **Content-Language** parameter depends on the **Content-Type** parameter. When **Content-Type**
       is `text/plain` or `text/html`, **Content-Language** is the only way to specify the language. When
       **Content-Type** is `application/json`, **Content-Language** overrides a language specified with the `language`
       parameter of a `ContentItem` object, and content items that specify a different language are ignored; omit this
       parameter to base the language on the specification of the content items. You can specify any combination of
       languages for **Content-Language** and **Accept-Language**.
     - parameter acceptLanguage: The desired language of the response. For two-character arguments, regional variants
       are treated as their parent language; for example, `en-US` is interpreted as `en`. You can specify any
       combination of languages for the input and response content.
     - parameter rawScores: Indicates whether a raw score in addition to a normalized percentile is returned for each
       characteristic; raw scores are not compared with a sample population. By default, only normalized percentiles are
       returned.
     - parameter csvHeaders: Indicates whether column labels are returned with a CSV response. By default, no column
       labels are returned. Applies only when the **Accept** parameter is set to `text/csv`.
     - parameter consumptionPreferences: Indicates whether consumption preferences are returned with the results. By
       default, no consumption preferences are returned.
     - parameter headers: A dictionary of request headers to be sent with this request.
     - parameter failure: A function executed if an error occurs.
     - parameter success: A function executed with the successful result.
     */
    public func profileAsCsv(
        profileContent: ProfileContent,
        contentLanguage: String? = nil,
        acceptLanguage: String? = nil,
        rawScores: Bool? = nil,
        csvHeaders: Bool? = nil,
        consumptionPreferences: Bool? = nil,
        headers: [String: String]? = nil,
        failure: ((Error) -> Void)? = nil,
        success: @escaping (String) -> Void)
    {
        // construct body
        guard let body = profileContent.content else {
            failure?(RestError.serializationError)
            return
        }

        // construct header parameters
        var headerParameters = defaultHeaders
        if let headers = headers {
            headerParameters.merge(headers) { (_, new) in new }
        }
        headerParameters["Accept"] = "text/csv"
        headerParameters["Content-Type"] = profileContent.contentType
        if let contentLanguage = contentLanguage {
            headerParameters["Content-Language"] = contentLanguage
        }
        if let acceptLanguage = acceptLanguage {
            headerParameters["Accept-Language"] = acceptLanguage
        }

        // construct query parameters
        var queryParameters = [URLQueryItem]()
        queryParameters.append(URLQueryItem(name: "version", value: version))
        if let rawScores = rawScores {
            let queryParameter = URLQueryItem(name: "raw_scores", value: "\(rawScores)")
            queryParameters.append(queryParameter)
        }
        if let csvHeaders = csvHeaders {
            let queryParameter = URLQueryItem(name: "csv_headers", value: "\(csvHeaders)")
            queryParameters.append(queryParameter)
        }
        if let consumptionPreferences = consumptionPreferences {
            let queryParameter = URLQueryItem(name: "consumption_preferences", value: "\(consumptionPreferences)")
            queryParameters.append(queryParameter)
        }

        // construct REST request
        let request = RestRequest(
            session: session,
            authMethod: authMethod,
            errorResponseDecoder: errorResponseDecoder,
            method: "POST",
            url: serviceURL + "/v3/profile",
            headerParameters: headerParameters,
            queryItems: queryParameters,
            messageBody: body
        )

        // execute REST request
        request.responseString {
            (response: RestResponse<String>) in
            switch response.result {
            case .success(let retval): success(retval)
            case .failure(let error): failure?(error)
            }
        }
    }

}

extension PersonalityInsights {

    @available(*, deprecated, message: "This method has been deprecated in favor of the profile method that accepts a profileContent parameter.  This method will be removed in a future release.")
    public func profile(
        content: Content,
        contentLanguage: String? = nil,
        acceptLanguage: String? = nil,
        rawScores: Bool? = nil,
        consumptionPreferences: Bool? = nil,
        headers: [String: String]? = nil,
        failure: ((Error) -> Void)? = nil,
        success: @escaping (Profile) -> Void)
    {
        profile(profileContent: .content(content), contentLanguage: contentLanguage, acceptLanguage: acceptLanguage,
                rawScores: rawScores, consumptionPreferences: consumptionPreferences, headers: headers,
                failure: failure, success: success)
    }

    @available(*, deprecated, message: "This method has been deprecated in favor of the profile method that accepts a profileContent parameter.  This method will be removed in a future release.")
    public func profile(
        text: String,
        contentLanguage: String? = nil,
        acceptLanguage: String? = nil,
        rawScores: Bool? = nil,
        consumptionPreferences: Bool? = nil,
        headers: [String: String]? = nil,
        failure: ((Error) -> Void)? = nil,
        success: @escaping (Profile) -> Void)
    {
        profile(profileContent: .text(text), contentLanguage: contentLanguage, acceptLanguage: acceptLanguage,
                rawScores: rawScores, consumptionPreferences: consumptionPreferences, headers: headers,
                failure: failure, success: success)
    }

    @available(*, deprecated, message: "This method has been deprecated in favor of the profile method that accepts a profileContent parameter.  This method will be removed in a future release.")
    public func profile(
        html: String,
        contentLanguage: String? = nil,
        acceptLanguage: String? = nil,
        rawScores: Bool? = nil,
        consumptionPreferences: Bool? = nil,
        headers: [String: String]? = nil,
        failure: ((Error) -> Void)? = nil,
        success: @escaping (Profile) -> Void)
    {
        profile(profileContent: .html(html), contentLanguage: contentLanguage, acceptLanguage: acceptLanguage,
                rawScores: rawScores, consumptionPreferences: consumptionPreferences, headers: headers,
                failure: failure, success: success)
    }

    @available(*, deprecated, message: "This method has been deprecated in favor of the profileAsCsv method that accepts a profileContent parameter.  This method will be removed in a future release.")
    public func profileAsCsv(
        content: Content,
        contentLanguage: String? = nil,
        acceptLanguage: String? = nil,
        rawScores: Bool? = nil,
        csvHeaders: Bool? = nil,
        consumptionPreferences: Bool? = nil,
        headers: [String: String]? = nil,
        failure: ((Error) -> Void)? = nil,
        success: @escaping (String) -> Void)
    {
        profileAsCsv(profileContent: .content(content), contentLanguage: contentLanguage, acceptLanguage: acceptLanguage,
                     rawScores: rawScores, csvHeaders: csvHeaders, consumptionPreferences: consumptionPreferences, headers: headers,
                     failure: failure, success: success)
    }

    @available(*, deprecated, message: "This method has been deprecated in favor of the profileAsCsv method that accepts a profileContent parameter.  This method will be removed in a future release.")
    public func profileAsCsv(
        text: String,
        contentLanguage: String? = nil,
        acceptLanguage: String? = nil,
        rawScores: Bool? = nil,
        csvHeaders: Bool? = nil,
        consumptionPreferences: Bool? = nil,
        headers: [String: String]? = nil,
        failure: ((Error) -> Void)? = nil,
        success: @escaping (String) -> Void)
    {
        profileAsCsv(profileContent: .text(text), contentLanguage: contentLanguage, acceptLanguage: acceptLanguage,
                     rawScores: rawScores, csvHeaders: csvHeaders, consumptionPreferences: consumptionPreferences, headers: headers,
                     failure: failure, success: success)
    }

    @available(*, deprecated, message: "This method has been deprecated in favor of the profileAsCsv method that accepts a profileContent parameter.  This method will be removed in a future release.")
    public func profileAsCsv(
        html: String,
        contentLanguage: String? = nil,
        acceptLanguage: String? = nil,
        rawScores: Bool? = nil,
        csvHeaders: Bool? = nil,
        consumptionPreferences: Bool? = nil,
        headers: [String: String]? = nil,
        failure: ((Error) -> Void)? = nil,
        success: @escaping (String) -> Void)
    {
        profileAsCsv(profileContent: .html(html), contentLanguage: contentLanguage, acceptLanguage: acceptLanguage,
                     rawScores: rawScores, csvHeaders: csvHeaders, consumptionPreferences: consumptionPreferences, headers: headers,
                     failure: failure, success: success)
    }
}
