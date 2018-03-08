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
 The IBM Watson Personality Insights service provides a Representational State Transfer (REST) Application Programming
 Interface (API) that enables applications to derive insights from social media, enterprise data, or other digital
 communications. The service uses linguistic analytics to infer individuals' intrinsic personality characteristics,
 including Big Five, Needs, and Values, from digital communications such as email, text messages, tweets, and forum
 posts. The service can automatically infer, from potentially noisy social media, portraits of individuals that reflect
 their personality characteristics. The service can report consumption preferences based on the results of its analysis,
 and for JSON content that is timestamped, it can report temporal behavior.
 ### API Usage
 The following information provides details about using the service to obtain a personality profile:
 * **The profile method:** The service offers a single `/v3/profile` method that accepts up to 20 MB of input data and
 produces results in JSON or CSV format. The service accepts input in Arabic, English, Japanese, Korean, or Spanish and
 can produce output in a variety of languages.
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

 For more information about the service, see [About Personality
 Insights](https://console.bluemix.net/docs/services/personality-insights/index.html). For information about calling the
 service and the responses it can generate, see [Requesting a
 profile](https://console.bluemix.net/docs/services/personality-insights/input.html), [Understanding a JSON
 profile](https://console.bluemix.net/docs/services/personality-insights/output.html), and [Understanding a CSV
 profile](https://console.bluemix.net/docs/services/personality-insights/output-csv.html).
 */
public class PersonalityInsights {

    /// The base URL to use when contacting the service.
    public var serviceURL = "https://gateway.watsonplatform.net/personality-insights/api"

    /// The default HTTP headers for all requests to the service.
    public var defaultHeaders = [String: String]()

    private let credentials: Credentials
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
        self.credentials = .basicAuthentication(username: username, password: password)
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
            let help = try? json.getString(at: "help")
            let userInfo = [NSLocalizedDescriptionKey: message, NSLocalizedFailureReasonErrorKey: help ?? ""]
            return NSError(domain: domain, code: code, userInfo: userInfo)
        } catch {
            return nil
        }
    }

    /**
     Generates a personality profile based on input text.

     Derives personality insights for up to 20 MB of input content written by an author, though the service requires
     much less text to produce an accurate profile; for more information, see [Providing sufficient
     input](https://console.bluemix.net/docs/services/personality-insights/input.html#sufficient). Accepts input in
     Arabic, English, Japanese, Korean, or Spanish and produces output in one of eleven languages. Provide plain text,
     HTML, or JSON content, and receive results in JSON or CSV format.

     - parameter content: A maximum of 20 MB of content to analyze, though the service requires much less text; for more information, see [Providing sufficient input](https://console.bluemix.net/docs/services/personality-insights/input.html#sufficient). A JSON request must conform to the `Content` model.
     - parameter contentLanguage: The language of the input text for the request: Arabic, English, Japanese, Korean, or Spanish. Regional variants are treated as their parent language; for example, `en-US` is interpreted as `en`. The effect of the `contentLanguage` header depends on the `Content-Type` header. When `Content-Type` is `text/plain` or `text/html`, `contentLanguage` is the only way to specify the language. When `Content-Type` is `application/json`, `contentLanguage` overrides a language specified with the `language` parameter of a `ContentItem` object, and content items that specify a different language are ignored; omit this header to base the language on the specification of the content items. You can specify any combination of languages for `contentLanguage` and `Accept-Language`.
     - parameter acceptLanguage: The desired language of the response. For two-character arguments, regional variants are treated as their parent language; for example, `en-US` is interpreted as `en`. You can specify any combination of languages for the input and response content.
     - parameter rawScores: If `true`, a raw score in addition to a normalized percentile is returned for each characteristic; raw scores are not compared with a sample population. If `false` (the default), only normalized percentiles are returned.
     - parameter consumptionPreferences: If `true`, information about consumption preferences is returned with the results; if `false` (the default), the response does not include the information.
     - parameter failure: A function executed if an error occurs.
     - parameter success: A function executed with the successful result.
    */
    public func profile(
        content: Content,
        contentLanguage: String? = nil,
        acceptLanguage: String? = nil,
        rawScores: Bool? = nil,
        consumptionPreferences: Bool? = nil,
        failure: ((Error) -> Void)? = nil,
        success: @escaping (Profile) -> Void)
    {
        // construct body
        guard let body = try? JSONEncoder().encode(content) else {
            failure?(RestError.serializationError)
            return
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
            method: "POST",
            url: serviceURL + "/v3/profile",
            credentials: credentials,
            headerParameters: defaultHeaders,
            acceptType: "application/json",
            contentType: "application/json",
            queryItems: queryParameters,
            messageBody: body
        )

        // execute REST request
        request.responseObject(responseToError: responseToError) {
            (response: RestResponse<Profile>) in
            switch response.result {
            case .success(let retval): success(retval)
            case .failure(let error): failure?(error)
            }
        }
    }

    /**
     Generates a personality profile based on input text.

     Derives personality insights for up to 20 MB of input content written by an author, though the service requires
     much less text to produce an accurate profile; for more information, see [Providing sufficient
     input](https://console.bluemix.net/docs/services/personality-insights/input.html#sufficient). Accepts input in
     Arabic, English, Japanese, Korean, or Spanish and produces output in one of eleven languages. Provide plain text,
     HTML, or JSON content, and receive results in JSON or CSV format.

     - parameter content: A maximum of 20 MB of content to analyze, though the service requires much less text; for more information, see [Providing sufficient input](https://console.bluemix.net/docs/services/personality-insights/input.html#sufficient). A JSON request must conform to the `Content` model.
     - parameter contentLanguage: The language of the input text for the request: Arabic, English, Japanese, Korean, or Spanish. Regional variants are treated as their parent language; for example, `en-US` is interpreted as `en`. The effect of the `contentLanguage` header depends on the `Content-Type` header. When `Content-Type` is `text/plain` or `text/html`, `contentLanguage` is the only way to specify the language. When `Content-Type` is `application/json`, `contentLanguage` overrides a language specified with the `language` parameter of a `ContentItem` object, and content items that specify a different language are ignored; omit this header to base the language on the specification of the content items. You can specify any combination of languages for `contentLanguage` and `Accept-Language`.
     - parameter acceptLanguage: The desired language of the response. For two-character arguments, regional variants are treated as their parent language; for example, `en-US` is interpreted as `en`. You can specify any combination of languages for the input and response content.
     - parameter rawScores: If `true`, a raw score in addition to a normalized percentile is returned for each characteristic; raw scores are not compared with a sample population. If `false` (the default), only normalized percentiles are returned.
     - parameter consumptionPreferences: If `true`, information about consumption preferences is returned with the results; if `false` (the default), the response does not include the information.
     - parameter failure: A function executed if an error occurs.
     - parameter success: A function executed with the successful result.
     */
    public func profile(
        text: String,
        contentLanguage: String? = nil,
        acceptLanguage: String? = nil,
        rawScores: Bool? = nil,
        consumptionPreferences: Bool? = nil,
        failure: ((Error) -> Void)? = nil,
        success: @escaping (Profile) -> Void)
    {
        // construct body
        guard let body = text.data(using: .utf8) else {
            failure?(RestError.serializationError)
            return
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
            method: "POST",
            url: serviceURL + "/v3/profile",
            credentials: credentials,
            headerParameters: defaultHeaders,
            acceptType: "application/json",
            contentType: "text/plain",
            queryItems: queryParameters,
            messageBody: body
        )

        // execute REST request
        request.responseObject(responseToError: responseToError) {
            (response: RestResponse<Profile>) in
            switch response.result {
            case .success(let retval): success(retval)
            case .failure(let error): failure?(error)
            }
        }
    }

    /**
     Generates a personality profile based on input text.

     Derives personality insights for up to 20 MB of input content written by an author, though the service requires
     much less text to produce an accurate profile; for more information, see [Providing sufficient
     input](https://console.bluemix.net/docs/services/personality-insights/input.html#sufficient). Accepts input in
     Arabic, English, Japanese, Korean, or Spanish and produces output in one of eleven languages. Provide plain text,
     HTML, or JSON content, and receive results in JSON or CSV format.

     - parameter content: A maximum of 20 MB of content to analyze, though the service requires much less text; for more information, see [Providing sufficient input](https://console.bluemix.net/docs/services/personality-insights/input.html#sufficient). A JSON request must conform to the `Content` model.
     - parameter contentLanguage: The language of the input text for the request: Arabic, English, Japanese, Korean, or Spanish. Regional variants are treated as their parent language; for example, `en-US` is interpreted as `en`. The effect of the `contentLanguage` header depends on the `Content-Type` header. When `Content-Type` is `text/plain` or `text/html`, `contentLanguage` is the only way to specify the language. When `Content-Type` is `application/json`, `contentLanguage` overrides a language specified with the `language` parameter of a `ContentItem` object, and content items that specify a different language are ignored; omit this header to base the language on the specification of the content items. You can specify any combination of languages for `contentLanguage` and `Accept-Language`.
     - parameter acceptLanguage: The desired language of the response. For two-character arguments, regional variants are treated as their parent language; for example, `en-US` is interpreted as `en`. You can specify any combination of languages for the input and response content.
     - parameter rawScores: If `true`, a raw score in addition to a normalized percentile is returned for each characteristic; raw scores are not compared with a sample population. If `false` (the default), only normalized percentiles are returned.
     - parameter consumptionPreferences: If `true`, information about consumption preferences is returned with the results; if `false` (the default), the response does not include the information.
     - parameter failure: A function executed if an error occurs.
     - parameter success: A function executed with the successful result.
     */
    public func profile(
        html: String,
        contentLanguage: String? = nil,
        acceptLanguage: String? = nil,
        rawScores: Bool? = nil,
        consumptionPreferences: Bool? = nil,
        failure: ((Error) -> Void)? = nil,
        success: @escaping (Profile) -> Void)
    {
        // construct body
        guard let body = html.data(using: .utf8) else {
            failure?(RestError.serializationError)
            return
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
            method: "POST",
            url: serviceURL + "/v3/profile",
            credentials: credentials,
            headerParameters: defaultHeaders,
            acceptType: "application/json",
            contentType: "text/html",
            queryItems: queryParameters,
            messageBody: body
        )

        // execute REST request
        request.responseObject(responseToError: responseToError) {
            (response: RestResponse<Profile>) in
            switch response.result {
            case .success(let retval): success(retval)
            case .failure(let error): failure?(error)
            }
        }
    }

    /**
     Generates a personality profile based on input text.

     Derives personality insights for up to 20 MB of input content written by an author, though the service requires
     much less text to produce an accurate profile; for more information, see [Providing sufficient
     input](https://console.bluemix.net/docs/services/personality-insights/input.html#sufficient). Accepts input in
     Arabic, English, Japanese, Korean, or Spanish and produces output in one of eleven languages. Provide plain text,
     HTML, or JSON content, and receive results in JSON or CSV format.

     - parameter content: A maximum of 20 MB of content to analyze, though the service requires much less text; for more information, see [Providing sufficient input](https://console.bluemix.net/docs/services/personality-insights/input.html#sufficient). A JSON request must conform to the `Content` model.
     - parameter contentLanguage: The language of the input text for the request: Arabic, English, Japanese, Korean, or Spanish. Regional variants are treated as their parent language; for example, `en-US` is interpreted as `en`. The effect of the `Content-Language` header depends on the `Content-Type` header. When `Content-Type` is `text/plain` or `text/html`, `Content-Language` is the only way to specify the language. When `Content-Type` is `application/json`, `Content-Language` overrides a language specified with the `language` parameter of a `ContentItem` object, and content items that specify a different language are ignored; omit this header to base the language on the specification of the content items. You can specify any combination of languages for `Content-Language` and `Accept-Language`.
     - parameter acceptLanguage: The desired language of the response. For two-character arguments, regional variants are treated as their parent language; for example, `en-US` is interpreted as `en`. You can specify any combination of languages for the input and response content.
     - parameter rawScores: If `true`, a raw score in addition to a normalized percentile is returned for each characteristic; raw scores are not compared with a sample population. If `false` (the default), only normalized percentiles are returned.
     - parameter csvHeaders: If `true`, column labels are returned with a CSV response; if `false` (the default), they are not. Applies only when the `Accept` header is set to `text/csv`.
     - parameter consumptionPreferences: If `true`, information about consumption preferences is returned with the results; if `false` (the default), the response does not include the information.
     - parameter failure: A function executed if an error occurs.
     - parameter success: A function executed with the successful result.
    */
    public func profileAsCsv(
        content: Content,
        contentLanguage: String? = nil,
        acceptLanguage: String? = nil,
        rawScores: Bool? = nil,
        csvHeaders: Bool? = nil,
        consumptionPreferences: Bool? = nil,
        failure: ((Error) -> Void)? = nil,
        success: @escaping (String) -> Void)
    {
        // construct body
        guard let body = try? JSONEncoder().encode(content) else {
            failure?(RestError.serializationError)
            return
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
            method: "POST",
            url: serviceURL + "/v3/profile",
            credentials: credentials,
            headerParameters: defaultHeaders,
            acceptType: "text/csv",
            contentType: "application/json",
            queryItems: queryParameters,
            messageBody: body
        )

        // execute REST request
        request.responseString(responseToError: responseToError) {
            (response: RestResponse<String>) in
            switch response.result {
            case .success(let retval): success(retval)
            case .failure(let error): failure?(error)
            }
        }
    }

    /**
     Generates a personality profile based on input text.

     Derives personality insights for up to 20 MB of input content written by an author, though the service requires
     much less text to produce an accurate profile; for more information, see [Providing sufficient
     input](https://console.bluemix.net/docs/services/personality-insights/input.html#sufficient). Accepts input in
     Arabic, English, Japanese, Korean, or Spanish and produces output in one of eleven languages. Provide plain text,
     HTML, or JSON content, and receive results in JSON or CSV format.

     - parameter content: A maximum of 20 MB of content to analyze, though the service requires much less text; for more information, see [Providing sufficient input](https://console.bluemix.net/docs/services/personality-insights/input.html#sufficient). A JSON request must conform to the `Content` model.
     - parameter contentLanguage: The language of the input text for the request: Arabic, English, Japanese, Korean, or Spanish. Regional variants are treated as their parent language; for example, `en-US` is interpreted as `en`. The effect of the `Content-Language` header depends on the `Content-Type` header. When `Content-Type` is `text/plain` or `text/html`, `Content-Language` is the only way to specify the language. When `Content-Type` is `application/json`, `Content-Language` overrides a language specified with the `language` parameter of a `ContentItem` object, and content items that specify a different language are ignored; omit this header to base the language on the specification of the content items. You can specify any combination of languages for `Content-Language` and `Accept-Language`.
     - parameter acceptLanguage: The desired language of the response. For two-character arguments, regional variants are treated as their parent language; for example, `en-US` is interpreted as `en`. You can specify any combination of languages for the input and response content.
     - parameter rawScores: If `true`, a raw score in addition to a normalized percentile is returned for each characteristic; raw scores are not compared with a sample population. If `false` (the default), only normalized percentiles are returned.
     - parameter csvHeaders: If `true`, column labels are returned with a CSV response; if `false` (the default), they are not. Applies only when the `Accept` header is set to `text/csv`.
     - parameter consumptionPreferences: If `true`, information about consumption preferences is returned with the results; if `false` (the default), the response does not include the information.
     - parameter failure: A function executed if an error occurs.
     - parameter success: A function executed with the successful result.
     */
    public func profileAsCsv(
        text: String,
        contentLanguage: String? = nil,
        acceptLanguage: String? = nil,
        rawScores: Bool? = nil,
        csvHeaders: Bool? = nil,
        consumptionPreferences: Bool? = nil,
        failure: ((Error) -> Void)? = nil,
        success: @escaping (String) -> Void)
    {
        // construct body
        guard let body = text.data(using: .utf8) else {
            failure?(RestError.serializationError)
            return
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
            method: "POST",
            url: serviceURL + "/v3/profile",
            credentials: credentials,
            headerParameters: defaultHeaders,
            acceptType: "text/csv",
            contentType: "text/plain",
            queryItems: queryParameters,
            messageBody: body
        )

        // execute REST request
        request.responseString(responseToError: responseToError) {
            (response: RestResponse<String>) in
            switch response.result {
            case .success(let retval): success(retval)
            case .failure(let error): failure?(error)
            }
        }
    }

    /**
     Generates a personality profile based on input text.

     Derives personality insights for up to 20 MB of input content written by an author, though the service requires
     much less text to produce an accurate profile; for more information, see [Providing sufficient
     input](https://console.bluemix.net/docs/services/personality-insights/input.html#sufficient). Accepts input in
     Arabic, English, Japanese, Korean, or Spanish and produces output in one of eleven languages. Provide plain text,
     HTML, or JSON content, and receive results in JSON or CSV format.

     - parameter content: A maximum of 20 MB of content to analyze, though the service requires much less text; for more information, see [Providing sufficient input](https://console.bluemix.net/docs/services/personality-insights/input.html#sufficient). A JSON request must conform to the `Content` model.
     - parameter contentLanguage: The language of the input text for the request: Arabic, English, Japanese, Korean, or Spanish. Regional variants are treated as their parent language; for example, `en-US` is interpreted as `en`. The effect of the `Content-Language` header depends on the `Content-Type` header. When `Content-Type` is `text/plain` or `text/html`, `Content-Language` is the only way to specify the language. When `Content-Type` is `application/json`, `Content-Language` overrides a language specified with the `language` parameter of a `ContentItem` object, and content items that specify a different language are ignored; omit this header to base the language on the specification of the content items. You can specify any combination of languages for `Content-Language` and `Accept-Language`.
     - parameter acceptLanguage: The desired language of the response. For two-character arguments, regional variants are treated as their parent language; for example, `en-US` is interpreted as `en`. You can specify any combination of languages for the input and response content.
     - parameter rawScores: If `true`, a raw score in addition to a normalized percentile is returned for each characteristic; raw scores are not compared with a sample population. If `false` (the default), only normalized percentiles are returned.
     - parameter csvHeaders: If `true`, column labels are returned with a CSV response; if `false` (the default), they are not. Applies only when the `Accept` header is set to `text/csv`.
     - parameter consumptionPreferences: If `true`, information about consumption preferences is returned with the results; if `false` (the default), the response does not include the information.
     - parameter failure: A function executed if an error occurs.
     - parameter success: A function executed with the successful result.
     */
    public func profileAsCsv(
        html: String,
        contentLanguage: String? = nil,
        acceptLanguage: String? = nil,
        rawScores: Bool? = nil,
        csvHeaders: Bool? = nil,
        consumptionPreferences: Bool? = nil,
        failure: ((Error) -> Void)? = nil,
        success: @escaping (String) -> Void)
    {
        // construct body
        guard let body = html.data(using: .utf8) else {
            failure?(RestError.serializationError)
            return
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
            method: "POST",
            url: serviceURL + "/v3/profile",
            credentials: credentials,
            headerParameters: defaultHeaders,
            acceptType: "text/csv",
            contentType: "text/html",
            queryItems: queryParameters,
            messageBody: body
        )

        // execute REST request
        request.responseString(responseToError: responseToError) {
            (response: RestResponse<String>) in
            switch response.result {
            case .success(let retval): success(retval)
            case .failure(let error): failure?(error)
            }
        }
    }

}
