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
 The IBM Watson&trade; Tone Analyzer service uses linguistic analysis to detect emotional and language tones in written
 text. The service can analyze tone at both the document and sentence levels. You can use the service to understand how
 your written communications are perceived and then to improve the tone of your communications. Businesses can use the
 service to learn the tone of their customers' communications and to respond to each customer appropriately, or to
 understand and improve their customer conversations.
 **Note:** Request logging is disabled for the Tone Analyzer service. Regardless of whether you set the
 `X-Watson-Learning-Opt-Out` request header, the service does not log or retain data from requests and responses.
 */
public class ToneAnalyzer {

    /// The base URL to use when contacting the service.
    public var serviceURL = "https://gateway.watsonplatform.net/tone-analyzer/api"

    /// The default HTTP headers for all requests to the service.
    public var defaultHeaders = [String: String]()

    var session = URLSession(configuration: URLSessionConfiguration.default)
    var authMethod: AuthenticationMethod
    let version: String

    /**
     Create a `ToneAnalyzer` object.

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
     Create a `ToneAnalyzer` object.

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
     Create a `ToneAnalyzer` object.

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
     Use the HTTP response and data received by the Tone Analyzer service to extract
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
            // If metadata is empty, it should show up as nil in the WatsonError
            return WatsonError.http(statusCode: statusCode, message: errorMessage, metadata: !metadata.isEmpty ? metadata : nil)
        } catch {
            return WatsonError.http(statusCode: statusCode, message: nil, metadata: nil)
        }
    }

    /**
     Analyze general tone.

     Use the general purpose endpoint to analyze the tone of your input content. The service analyzes the content for
     emotional and language tones. The method always analyzes the tone of the full document; by default, it also
     analyzes the tone of each individual sentence of the content.
     You can submit no more than 128 KB of total input content and no more than 1000 individual sentences in JSON, plain
     text, or HTML format. The service analyzes the first 1000 sentences for document-level analysis and only the first
     100 sentences for sentence-level analysis.
     Per the JSON specification, the default character encoding for JSON content is effectively always UTF-8; per the
     HTTP specification, the default encoding for plain text and HTML is ISO-8859-1 (effectively, the ASCII character
     set). When specifying a content type of plain text or HTML, include the `charset` parameter to indicate the
     character encoding of the input text; for example: `Content-Type: text/plain;charset=utf-8`. For `text/html`, the
     service removes HTML tags and analyzes only the textual content.
     **See also:** [Using the general-purpose
     endpoint](https://cloud.ibm.com/docs/services/tone-analyzer/using-tone.html#using-the-general-purpose-endpoint).

     - parameter toneContent: JSON, plain text, or HTML input that contains the content to be analyzed. For JSON
       input, provide an object of type `ToneInput`.
     - parameter sentences: Indicates whether the service is to return an analysis of each individual sentence in
       addition to its analysis of the full document. If `true` (the default), the service returns results for each
       sentence.
     - parameter contentLanguage: The language of the input text for the request: English or French. Regional variants
       are treated as their parent language; for example, `en-US` is interpreted as `en`. The input content must match
       the specified language. Do not submit content that contains both languages. You can use different languages for
       **Content-Language** and **Accept-Language**.
       * **`2017-09-21`:** Accepts `en` or `fr`.
       * **`2016-05-19`:** Accepts only `en`.
     - parameter acceptLanguage: The desired language of the response. For two-character arguments, regional variants
       are treated as their parent language; for example, `en-US` is interpreted as `en`. You can use different
       languages for **Content-Language** and **Accept-Language**.
     - parameter headers: A dictionary of request headers to be sent with this request.
     - parameter completionHandler: A function executed when the request completes with a successful result or error
     */
    public func tone(
        toneContent: ToneContent,
        sentences: Bool? = nil,
        contentLanguage: String? = nil,
        acceptLanguage: String? = nil,
        headers: [String: String]? = nil,
        completionHandler: @escaping (WatsonResponse<ToneAnalysis>?, WatsonError?) -> Void)
    {
        // construct body
        guard let body = toneContent.content else {
            completionHandler(nil, WatsonError.serialization(values: "request body"))
            return
        }

        // construct header parameters
        var headerParameters = defaultHeaders
        if let headers = headers {
            headerParameters.merge(headers) { (_, new) in new }
        }
        headerParameters["Accept"] = "application/json"
        headerParameters["Content-Type"] = toneContent.contentType
        if let contentLanguage = contentLanguage {
            headerParameters["Content-Language"] = contentLanguage
        }
        if let acceptLanguage = acceptLanguage {
            headerParameters["Accept-Language"] = acceptLanguage
        }

        // construct query parameters
        var queryParameters = [URLQueryItem]()
        queryParameters.append(URLQueryItem(name: "version", value: version))
        if let sentences = sentences {
            let queryParameter = URLQueryItem(name: "sentences", value: "\(sentences)")
            queryParameters.append(queryParameter)
        }

        // construct REST request
        let request = RestRequest(
            session: session,
            authMethod: authMethod,
            errorResponseDecoder: errorResponseDecoder,
            method: "POST",
            url: serviceURL + "/v3/tone",
            headerParameters: headerParameters,
            queryItems: queryParameters,
            messageBody: body
        )

        // execute REST request
        request.responseObject(completionHandler: completionHandler)
    }

    /**
     Analyze customer engagement tone.

     Use the customer engagement endpoint to analyze the tone of customer service and customer support conversations.
     For each utterance of a conversation, the method reports the most prevalent subset of the following seven tones:
     sad, frustrated, satisfied, excited, polite, impolite, and sympathetic.
     If you submit more than 50 utterances, the service returns a warning for the overall content and analyzes only the
     first 50 utterances. If you submit a single utterance that contains more than 500 characters, the service returns
     an error for that utterance and does not analyze the utterance. The request fails if all utterances have more than
     500 characters. Per the JSON specification, the default character encoding for JSON content is effectively always
     UTF-8.
     **See also:** [Using the customer-engagement
     endpoint](https://cloud.ibm.com/docs/services/tone-analyzer/using-tone-chat.html#using-the-customer-engagement-endpoint).

     - parameter utterances: An array of `Utterance` objects that provides the input content that the service is to
       analyze.
     - parameter contentLanguage: The language of the input text for the request: English or French. Regional variants
       are treated as their parent language; for example, `en-US` is interpreted as `en`. The input content must match
       the specified language. Do not submit content that contains both languages. You can use different languages for
       **Content-Language** and **Accept-Language**.
       * **`2017-09-21`:** Accepts `en` or `fr`.
       * **`2016-05-19`:** Accepts only `en`.
     - parameter acceptLanguage: The desired language of the response. For two-character arguments, regional variants
       are treated as their parent language; for example, `en-US` is interpreted as `en`. You can use different
       languages for **Content-Language** and **Accept-Language**.
     - parameter headers: A dictionary of request headers to be sent with this request.
     - parameter completionHandler: A function executed when the request completes with a successful result or error
     */
    public func toneChat(
        utterances: [Utterance],
        contentLanguage: String? = nil,
        acceptLanguage: String? = nil,
        headers: [String: String]? = nil,
        completionHandler: @escaping (WatsonResponse<UtteranceAnalyses>?, WatsonError?) -> Void)
    {
        // construct body
        let toneChatRequest = ToneChatInput(
            utterances: utterances)
        guard let body = try? JSONEncoder().encode(toneChatRequest) else {
            completionHandler(nil, WatsonError.serialization(values: "request body"))
            return
        }

        // construct header parameters
        var headerParameters = defaultHeaders
        if let headers = headers {
            headerParameters.merge(headers) { (_, new) in new }
        }
        headerParameters["Accept"] = "application/json"
        headerParameters["Content-Type"] = "application/json"
        if let contentLanguage = contentLanguage {
            headerParameters["Content-Language"] = contentLanguage
        }
        if let acceptLanguage = acceptLanguage {
            headerParameters["Accept-Language"] = acceptLanguage
        }

        // construct query parameters
        var queryParameters = [URLQueryItem]()
        queryParameters.append(URLQueryItem(name: "version", value: version))

        // construct REST request
        let request = RestRequest(
            session: session,
            authMethod: authMethod,
            errorResponseDecoder: errorResponseDecoder,
            method: "POST",
            url: serviceURL + "/v3/tone_chat",
            headerParameters: headerParameters,
            queryItems: queryParameters,
            messageBody: body
        )

        // execute REST request
        request.responseObject(completionHandler: completionHandler)
    }

}
