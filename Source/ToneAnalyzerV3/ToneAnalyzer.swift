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

import Foundation

/**
  ### Service Overview
 The IBM Watson Tone Analyzer service uses linguistic analysis to detect emotional and language tones in written text.
 The service can analyze tone at both the document and sentence levels. You can use the service to understand how your
 written communications are perceived and then to improve the tone of your communications. Businesses can use the
 service to learn the tone of their customers' communications and to respond to each customer appropriately, or to
 understand and improve their customer conversations.
 ### API Usage
 The following information provides details about using the service to analyze tone:
 * **The tone method:** The service offers `GET` and `POST /v3/tone` methods that use the general purpose endpoint to
 analyze the tone of input content. The methods accept content in JSON, plain text, or HTML format.
 * **The tone_chat method:** The service offers a `POST /v3/tone_chat` method that uses the customer engagement endpoint
 to analyze the tone of customer service and customer support conversations. The method accepts content in JSON format.
 * **Authentication:** You authenticate to the service by using your service credentials. You can use your credentials
 to authenticate via a proxy server that resides in IBM Cloud, or you can use your credentials to obtain a token and
 contact the service directly. See [Service credentials for Watson
 services](https://console.bluemix.net/docs/services/watson/getting-started-credentials.html) and [Tokens for
 authentication](https://console.bluemix.net/docs/services/watson/getting-started-tokens.html).
 * **Request Logging:** By default, all Watson services log requests and their results. Data is collected only to
 improve the Watson services. If you do not want to share your data, set the header parameter
 `X-Watson-Learning-Opt-Out` to `true` for each request. Data is collected for any request that omits this header. See
 [Controlling request logging for Watson
 services](https://console.bluemix.net/docs/services/watson/getting-started-logging.html).

 For more information about the service, see [About Tone
 Analyzer](https://console.bluemix.net/docs/services/tone-analyzer/index.html).

 **Note:** Method descriptions apply to the latest version of the interface, `2017-09-21`. Where necessary, parameters
 and models describe differences between versions `2017-09-21` and `2016-05-19`.
 */
public class ToneAnalyzer {

    /// The base URL to use when contacting the service.
    public var serviceURL = "https://gateway.watsonplatform.net/tone-analyzer/api"

    /// The default HTTP headers for all requests to the service.
    public var defaultHeaders = [String: String]()

    private let credentials: Credentials
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
        self.credentials = .basicAuthentication(username: username, password: password)
        self.version = version
    }

    /**
     If the response or data represents an error returned by the Tone Analyzer service,
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
            let userInfo = [NSLocalizedDescriptionKey: message]
            return NSError(domain: domain, code: code, userInfo: userInfo)
        } catch {
            return nil
        }
    }

    /**
     Analyze general purpose tone.

          Uses the general purpose endpoint to analyze the tone of your input content. The service analyzes the content for
     emotional and language tones. The method always analyzes the tone of the full document; by default, it also
     analyzes the tone of each individual sentence of the content.   You can submit no more than 128 KB of total input
     content and no more than 1000 individual sentences in JSON, plain text, or HTML format. The service analyzes the
     first 1000 sentences for document-level analysis and only the first 100 sentences for sentence-level analysis.
     Use the `POST` request method to analyze larger amounts of content in any of the available formats. Use the `GET`
     request method to analyze smaller quantities of plain text content.   Per the JSON specification, the default
     character encoding for JSON content is effectively always UTF-8; per the HTTP specification, the default encoding
     for plain text and HTML is ISO-8859-1 (effectively, the ASCII character set). When specifying a content type of
     plain text or HTML, include the `charset` parameter to indicate the character encoding of the input text; for
     example: `Content-Type: text/plain;charset=utf-8`. For `text/html`, the service removes HTML tags and analyzes only
     the textual content.

     - parameter toneInput: JSON, plain text, or HTML input that contains the content to be analyzed. For JSON input, provide an object of type `ToneInput`.
     - parameter contentType: The type of the input: application/json, text/plain, or text/html. A character encoding can be specified by including a `charset` parameter. For example, 'text/plain;charset=utf-8'.
     - parameter sentences: Indicates whether the service is to return an analysis of each individual sentence in addition to its analysis of the full document. If `true` (the default), the service returns results for each sentence.
     - parameter tones: **`2017-09-21`:** Deprecated. The service continues to accept the parameter for backward-compatibility, but the parameter no longer affects the response.   **`2016-05-19`:** A comma-separated list of tones for which the service is to return its analysis of the input; the indicated tones apply both to the full document and to individual sentences of the document. You can specify one or more of the valid values. Omit the parameter to request results for all three tones.
     - parameter contentLanguage: The language of the input text for the request: English or French. Regional variants are treated as their parent language; for example, `en-US` is interpreted as `en`. The input content must match the specified language. Do not submit content that contains both languages. You can specify any combination of languages for `contentLanguage` and `Accept-Language`. * **`2017-09-21`:** Accepts `en` or `fr`. * **`2016-05-19`:** Accepts only `en`.
     - parameter acceptLanguage: The desired language of the response. For two-character arguments, regional variants are treated as their parent language; for example, `en-US` is interpreted as `en`. You can specify any combination of languages for `Content-Language` and `acceptLanguage`.
     - parameter failure: A function executed if an error occurs.
     - parameter success: A function executed with the successful result.
    */
    public func tone(
        toneInput: ToneInput,
        contentType: String,
        sentences: Bool? = nil,
        tones: [String]? = nil,
        contentLanguage: String? = nil,
        acceptLanguage: String? = nil,
        failure: ((Error) -> Void)? = nil,
        success: @escaping (ToneAnalysis) -> Void)
    {
        // construct body
        guard let body = try? JSONEncoder().encode(toneInput) else {
            failure?(RestError.serializationError)
            return
        }

        // construct query parameters
        var queryParameters = [URLQueryItem]()
        queryParameters.append(URLQueryItem(name: "version", value: version))
        if let sentences = sentences {
            let queryParameter = URLQueryItem(name: "sentences", value: "\(sentences)")
            queryParameters.append(queryParameter)
        }
        if let tones = tones {
            let queryParameter = URLQueryItem(name: "tones", value: "\(tones)")
            queryParameters.append(queryParameter)
        }

        // construct REST request
        let request = RestRequest(
            method: "POST",
            url: serviceURL + "/v3/tone",
            credentials: credentials,
            headerParameters: defaultHeaders,
            acceptType: "application/json",
            contentType: "application/json",
            queryItems: queryParameters,
            messageBody: body
        )

        // execute REST request
        request.responseObject(responseToError: responseToError) {
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
     sad, frustrated, satisfied, excited, polite, impolite, and sympathetic.   If you submit more than 50 utterances,
     the service returns a warning for the overall content and analyzes only the first 50 utterances. If you submit a
     single utterance that contains more than 500 characters, the service returns an error for that utterance and does
     not analyze the utterance. The request fails if all utterances have more than 500 characters.   Per the JSON
     specification, the default character encoding for JSON content is effectively always UTF-8.

     - parameter utterances: An array of `Utterance` objects that provides the input content that the service is to analyze.
     - parameter acceptLanguage: The desired language of the response. For two-character arguments, regional variants are treated as their parent language; for example, `en-US` is interpreted as `en`.
     - parameter failure: A function executed if an error occurs.
     - parameter success: A function executed with the successful result.
    */
    public func toneChat(
        utterances: [Utterance],
        acceptLanguage: String? = nil,
        failure: ((Error) -> Void)? = nil,
        success: @escaping (UtteranceAnalyses) -> Void)
    {
        // construct body
        let toneChatRequest = ToneChatInput(utterances: utterances)
        guard let body = try? JSONEncoder().encode(toneChatRequest) else {
            failure?(RestError.serializationError)
            return
        }

        // construct query parameters
        var queryParameters = [URLQueryItem]()
        queryParameters.append(URLQueryItem(name: "version", value: version))

        // construct REST request
        let request = RestRequest(
            method: "POST",
            url: serviceURL + "/v3/tone_chat",
            credentials: credentials,
            headerParameters: defaultHeaders,
            acceptType: "application/json",
            contentType: "application/json",
            queryItems: queryParameters,
            messageBody: body
        )

        // execute REST request
        request.responseObject(responseToError: responseToError) {
            (response: RestResponse<UtteranceAnalyses>) in
            switch response.result {
            case .success(let retval): success(retval)
            case .failure(let error): failure?(error)
            }
        }
    }

}
