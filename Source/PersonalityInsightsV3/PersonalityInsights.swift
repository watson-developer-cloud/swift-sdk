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
 [Personality models](https://cloud.ibm.com/docs/services/personality-insights/models.html).
 * For information about the meaning of the consumption preferences, see [Consumption
 preferences](https://cloud.ibm.com/docs/services/personality-insights/preferences.html).
 **Note:** Request logging is disabled for the Personality Insights service. Regardless of whether you set the
 `X-Watson-Learning-Opt-Out` request header, the service does not log or retain data from requests and responses.
 */
public class PersonalityInsights {

    /// The base URL to use when contacting the service.
    public var serviceURL = "https://gateway.watsonplatform.net/personality-insights/api"

    /// The default HTTP headers for all requests to the service.
    public var defaultHeaders = [String: String]()

    var session = URLSession(configuration: URLSessionConfiguration.default)
    var authMethod: AuthenticationMethod
    let version: String

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
     Use the HTTP response and data received by the Personality Insights service to extract
     information about the error that occurred.

     - parameter data: Raw data returned by the service that may represent an error.
     - parameter response: the URL response returned by the service.
     */
    func errorResponseDecoder(data: Data, response: HTTPURLResponse) -> WatsonError {

        let statusCode = response.statusCode
        var errorMessage: String?
        var metadata = [String: Any]()

        do {
            let json = try JSONDecoder().decode([String: JSON].self, from: data)
            metadata = [:]
            if case let .some(.string(message)) = json["error"] {
                errorMessage = message
            }
            if case let .some(.string(help)) = json["help"] {
                metadata["help"] = help
            }
            // If metadata is empty, it should show up as nil in the WatsonError
            return WatsonError.http(statusCode: statusCode, message: errorMessage, metadata: !metadata.isEmpty ? metadata : nil)
        } catch {
            return WatsonError.http(statusCode: statusCode, message: nil, metadata: nil)
        }
    }

    /**
     Get profile.

     Generates a personality profile for the author of the input text. The service accepts a maximum of 20 MB of input
     content, but it requires much less text to produce an accurate profile. The service can analyze text in Arabic,
     English, Japanese, Korean, or Spanish. It can return its results in a variety of languages.
     **See also:**
     * [Requesting a profile](https://cloud.ibm.com/docs/services/personality-insights/input.html)
     * [Providing sufficient input](https://cloud.ibm.com/docs/services/personality-insights/input.html#sufficient)
     ### Content types
      You can provide input content as plain text (`text/plain`), HTML (`text/html`), or JSON (`application/json`) by
     specifying the **Content-Type** parameter. The default is `text/plain`.
     * Per the JSON specification, the default character encoding for JSON content is effectively always UTF-8.
     * Per the HTTP specification, the default encoding for plain text and HTML is ISO-8859-1 (effectively, the ASCII
     character set).
     When specifying a content type of plain text or HTML, include the `charset` parameter to indicate the character
     encoding of the input text; for example, `Content-Type: text/plain;charset=utf-8`.
     **See also:** [Specifying request and response formats](https://cloud.ibm.com/docs/services/personality-insights/input.html#formats)
     ### Accept types
      You must request a response as JSON (`application/json`) or comma-separated values (`text/csv`) by specifying the
     **Accept** parameter. CSV output includes a fixed number of columns. Set the **csv_headers** parameter to `true` to
     request optional column headers for CSV output.
     **See also:**
     * [Understanding a JSON profile](https://cloud.ibm.com/docs/services/personality-insights/output.html)
     * [Understanding a CSV profile](https://cloud.ibm.com/docs/services/personality-insights/output-csv.html).

     - parameter profileContent: A maximum of 20 MB of content to analyze, though the service requires much less text;
       for more information, see [Providing sufficient
       input](https://cloud.ibm.com/docs/services/personality-insights/input.html#sufficient). For JSON input, provide an object of type
       `Content`.
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
     - parameter completionHandler: A function executed when the request completes with a successful result or error
     */
    public func profile(
        profileContent: ProfileContent,
        contentLanguage: String? = nil,
        acceptLanguage: String? = nil,
        rawScores: Bool? = nil,
        consumptionPreferences: Bool? = nil,
        headers: [String: String]? = nil,
        completionHandler: @escaping (WatsonResponse<Profile>?, WatsonError?) -> Void)
    {
        // construct body
        guard let body = profileContent.content else {
            completionHandler(nil, WatsonError.serialization(values: "request body"))
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
        request.responseObject(completionHandler: completionHandler)
    }

    /**
     Get profile as csv.

     Generates a personality profile for the author of the input text. The service accepts a maximum of 20 MB of input
     content, but it requires much less text to produce an accurate profile. The service can analyze text in Arabic,
     English, Japanese, Korean, or Spanish. It can return its results in a variety of languages.
     **See also:**
     * [Requesting a profile](https://cloud.ibm.com/docs/services/personality-insights/input.html)
     * [Providing sufficient input](https://cloud.ibm.com/docs/services/personality-insights/input.html#sufficient)
     ### Content types
      You can provide input content as plain text (`text/plain`), HTML (`text/html`), or JSON (`application/json`) by
     specifying the **Content-Type** parameter. The default is `text/plain`.
     * Per the JSON specification, the default character encoding for JSON content is effectively always UTF-8.
     * Per the HTTP specification, the default encoding for plain text and HTML is ISO-8859-1 (effectively, the ASCII
     character set).
     When specifying a content type of plain text or HTML, include the `charset` parameter to indicate the character
     encoding of the input text; for example, `Content-Type: text/plain;charset=utf-8`.
     **See also:** [Specifying request and response formats](https://cloud.ibm.com/docs/services/personality-insights/input.html#formats)
     ### Accept types
      You must request a response as JSON (`application/json`) or comma-separated values (`text/csv`) by specifying the
     **Accept** parameter. CSV output includes a fixed number of columns. Set the **csv_headers** parameter to `true` to
     request optional column headers for CSV output.
     **See also:**
     * [Understanding a JSON profile](https://cloud.ibm.com/docs/services/personality-insights/output.html)
     * [Understanding a CSV profile](https://cloud.ibm.com/docs/services/personality-insights/output-csv.html).

     - parameter profileContent: A maximum of 20 MB of content to analyze, though the service requires much less text;
       for more information, see [Providing sufficient
       input](https://cloud.ibm.com/docs/services/personality-insights/input.html#sufficient). For JSON input, provide an object of type
       `Content`.
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
       labels are returned. Applies only when the response type is CSV (`text/csv`).
     - parameter consumptionPreferences: Indicates whether consumption preferences are returned with the results. By
       default, no consumption preferences are returned.
     - parameter headers: A dictionary of request headers to be sent with this request.
     - parameter completionHandler: A function executed when the request completes with a successful result or error
     */
    public func profileAsCSV(
        profileContent: ProfileContent,
        contentLanguage: String? = nil,
        acceptLanguage: String? = nil,
        rawScores: Bool? = nil,
        csvHeaders: Bool? = nil,
        consumptionPreferences: Bool? = nil,
        headers: [String: String]? = nil,
        completionHandler: @escaping (WatsonResponse<String>?, WatsonError?) -> Void)
    {
        // construct body
        guard let body = profileContent.content else {
            completionHandler(nil, WatsonError.serialization(values: "request body"))
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
        request.response(completionHandler: completionHandler)
    }

}
