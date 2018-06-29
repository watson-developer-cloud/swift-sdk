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

/**
 The IBM Watson&trade; Tone Analyzer service uses linguistic analysis to detect emotional and language tones in written
 text. The service can analyze tone at both the document and sentence levels. You can use the service to understand how
 your written communications are perceived and then to improve the tone of your communications. Businesses can use the
 service to learn the tone of their customers' communications and to respond to each customer appropriately, or to
 understand and improve their customer conversations.
 **Note:** Request logging is disabled for the Tone Analyzer service. The service neither logs nor retains data from
 requests and responses, regardless of whether the `X-Watson-Learning-Opt-Out` request header is set.
 */
public class ToneAnalyzer {

    /// The base URL to use when contacting the service.
    public var serviceURL = "https://gateway.watsonplatform.net/tone-analyzer/api"

    /// The default HTTP headers for all requests to the service.
    public var defaultHeaders = [String: String]()

    private let session = URLSession(configuration: URLSessionConfiguration.default)
    private var authMethod: AuthenticationMethod
    private let domain = "com.ibm.watson.developer-cloud.ToneAnalyzerV3"
    private let version: String

    /**
     Create a `ToneAnalyzer` object.

     - parameter username: The username used to authenticate with the service.
     - parameter password: The password used to authenticate with the service.
     - parameter version: The release date of the version of the API to use. Specify the date
       in "YYYY-MM-DD" format.
     */
    public init(username: String, password: String, version: String) {
        self.authMethod = BasicAuthentication(username: username, password: password)
        self.version = version
    }

    /**
     Create a `ToneAnalyzer` object.

     - parameter version: The release date of the version of the API to use. Specify the date
       in "YYYY-MM-DD" format.
     - parameter apiKey: An API key for IAM that can be used to obtain access tokens for the service.
     - parameter iamUrl: The URL for the IAM service.
     */
    public init(version: String, apiKey: String, iamUrl: String? = nil) {
        self.version = version
        self.authMethod = IAMAuthentication(apiKey: apiKey, url: iamUrl)
    }

    /**
     Create a `ToneAnalyzer` object.

     - parameter version: The release date of the version of the API to use. Specify the date
       in "YYYY-MM-DD" format.
     - parameter accessToken: An access token for the service.
     */
    public init(version: String, accessToken: String) {
        self.version = version
        self.authMethod = IAMAccessToken(accessToken: accessToken)
    }

    public func accessToken(_ newToken: String) {
        if self.authMethod is IAMAccessToken {
            self.authMethod = IAMAccessToken(accessToken: newToken)
        }
    }

    /**
     If the response or data represents an error returned by the Tone Analyzer service,
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
            return NSError(domain: domain, code: code, userInfo: userInfo)
        } catch {
            return NSError(domain: domain, code: code, userInfo: nil)
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

     - parameter toneContent: JSON, plain text, or HTML input that contains the content to be analyzed. For JSON
       input, provide an object of type `ToneInput`.
     - parameter sentences: Indicates whether the service is to return an analysis of each individual sentence in
       addition to its analysis of the full document. If `true` (the default), the service returns results for each
       sentence.
     - parameter tones: **`2017-09-21`:** Deprecated. The service continues to accept the parameter for
       backward-compatibility, but the parameter no longer affects the response.
       **`2016-05-19`:** A comma-separated list of tones for which the service is to return its analysis of the input;
       the indicated tones apply both to the full document and to individual sentences of the document. You can specify
       one or more of the valid values. Omit the parameter to request results for all three tones.
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
     - parameter failure: A function executed if an error occurs.
     - parameter success: A function executed with the successful result.
     */
    public func tone(
        toneContent: ToneContent,
        sentences: Bool? = nil,
        tones: [String]? = nil,
        contentLanguage: String? = nil,
        acceptLanguage: String? = nil,
        headers: [String: String]? = nil,
        failure: ((Error) -> Void)? = nil,
        success: @escaping (ToneAnalysis) -> Void)
    {
        // construct body
        guard let body = toneContent.content else {
            failure?(RestError.serializationError)
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
        if let tones = tones {
            let queryParameter = URLQueryItem(name: "tones", value: tones.joined(separator: ","))
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
        request.responseObject {
            (response: RestResponse<ToneAnalysis>) in
            switch response.result {
            case .success(let retval): success(retval)
            case .failure(let error): failure?(error)
            }
        }
    }

    /**
     Analyze customer engagement tone.

     Use the customer engagement endpoint to analyze the tone of customer service and customer support conversations.
     For each utterance of a conversation, the method reports the most prevalent subset of the following seven tones:
     sad, frustrated, satisfied, excited, polite, impolite, and sympathetic.
     If you submit more than 50 utterances, the service returns a warning for the overall content and analyzes only the
     first 50 utterances. If you submit a single utterance that contains more than 500 characters, the service returns
     an error for that utterance and does not analyze the utterance. The request fails if all utterances have more than
     500 characters.
     Per the JSON specification, the default character encoding for JSON content is effectively always UTF-8.

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
     - parameter failure: A function executed if an error occurs.
     - parameter success: A function executed with the successful result.
     */
    public func toneChat(
        utterances: [Utterance],
        contentLanguage: String? = nil,
        acceptLanguage: String? = nil,
        headers: [String: String]? = nil,
        failure: ((Error) -> Void)? = nil,
        success: @escaping (UtteranceAnalyses) -> Void)
    {
        // construct body
        let toneChatRequest = ToneChatInput(utterances: utterances)
        guard let body = try? JSONEncoder().encode(toneChatRequest) else {
            failure?(RestError.serializationError)
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
        request.responseObject {
            (response: RestResponse<UtteranceAnalyses>) in
            switch response.result {
            case .success(let retval): success(retval)
            case .failure(let error): failure?(error)
            }
        }
    }

}

extension ToneAnalyzer {

    @available(*, deprecated, message: "This method has been deprecated in favor of the tone method that accepts a toneContent parameter.  This method will be removed in a future release.")
    public func tone(
        toneInput: ToneInput,
        sentences: Bool? = nil,
        tones: [String]? = nil,
        contentLanguage: String? = nil,
        acceptLanguage: String? = nil,
        headers: [String: String]? = nil,
        failure: ((Error) -> Void)? = nil,
        success: @escaping (ToneAnalysis) -> Void)
    {
        tone(toneContent: .toneInput(toneInput), sentences: sentences, tones: tones, contentLanguage: contentLanguage,
             acceptLanguage: acceptLanguage, headers: headers, failure: failure, success: success)
    }

    @available(*, deprecated, message: "This method has been deprecated in favor of the tone method that accepts a toneContent parameter.  This method will be removed in a future release.")
    public func tone(
        text: String,
        sentences: Bool? = nil,
        tones: [String]? = nil,
        contentLanguage: String? = nil,
        acceptLanguage: String? = nil,
        headers: [String: String]? = nil,
        failure: ((Error) -> Void)? = nil,
        success: @escaping (ToneAnalysis) -> Void)
    {
        tone(toneContent: .text(text), sentences: sentences, tones: tones, contentLanguage: contentLanguage,
             acceptLanguage: acceptLanguage, headers: headers, failure: failure, success: success)
    }

    @available(*, deprecated, message: "This method has been deprecated in favor of the tone method that accepts a toneContent parameter.  This method will be removed in a future release.")
    public func tone(
        html: String,
        sentences: Bool? = nil,
        tones: [String]? = nil,
        contentLanguage: String? = nil,
        acceptLanguage: String? = nil,
        headers: [String: String]? = nil,
        failure: ((Error) -> Void)? = nil,
        success: @escaping (ToneAnalysis) -> Void)
    {
        tone(toneContent: .html(html), sentences: sentences, tones: tones, contentLanguage: contentLanguage,
             acceptLanguage: acceptLanguage, headers: headers, failure: failure, success: success)
    }

}
