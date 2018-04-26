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
 The IBM Watson Personality Insights service enables applications to derive insights from social media, enterprise data,
 or other digital communications. The service uses linguistic analytics to infer individuals' intrinsic personality
 characteristics, including Big Five, Needs, and Values, from digital communications such as email, text messages,
 tweets, and forum posts.
 The service can automatically infer, from potentially noisy social media, portraits of individuals that reflect their
 personality characteristics. The service can infer consumption preferences based on the results of its analysis and,
 for JSON content that is timestamped, can report temporal behavior.
 For information about the meaning of the models that the service uses to describe personality characteristics, see
 [Personality models](https://console.bluemix.net/docs/services/personality-insights/models.html). For information about
 the meaning of the consumption preferences, see [Consumption
 preferences](https://console.bluemix.net/docs/services/personality-insights/preferences.html).
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
     Get profile.

     Generates a personality profile for the author of the input text. The service accepts a maximum of 20 MB of input
     content, but it requires much less text to produce an accurate profile; for more information, see [Providing
     sufficient input](https://console.bluemix.net/docs/services/personality-insights/input.html#sufficient). The
     service analyzes text in Arabic, English, Japanese, Korean, or Spanish and returns its results in a variety of
     languages. You can provide plain text, HTML, or JSON input by specifying the **Content-Type** parameter; the
     default is `text/plain`. Request a JSON or comma-separated values (CSV) response by specifying the **Accept**
     parameter; CSV output includes a fixed number of columns and optional headers.   Per the JSON specification, the
     default character encoding for JSON content is effectively always UTF-8; per the HTTP specification, the default
     encoding for plain text and HTML is ISO-8859-1 (effectively, the ASCII character set). When specifying a content
     type of plain text or HTML, include the `charset` parameter to indicate the character encoding of the input text;
     for example: `Content-Type: text/plain;charset=utf-8`.   For detailed information about calling the service and the
     responses it can generate, see (Requesting a
     profile)[https://console.bluemix.net/docs/services/personality-insights/input.html], (Understanding a JSON
     profile)[https://console.bluemix.net/docs/services/personality-insights/output.html], and (Understanding a CSV
     profile)[https://console.bluemix.net/docs/services/personality-insights/output-csv.html].

     - parameter content: A maximum of 20 MB of content to analyze, though the service requires much less text; for more information, see
     [Providing sufficient input](https://console.bluemix.net/docs/services/personality-insights/input.html#sufficient).
     For JSON input, provide an object of type `Content`.
     - parameter contentLanguage: The language of the input text for the request: Arabic, English, Japanese, Korean, or Spanish. Regional variants
     are treated as their parent language; for example, `en-US` is interpreted as `en`.   The effect of the
     **Content-Language** parameter depends on the **Content-Type** parameter. When **Content-Type** is `text/plain` or
     `text/html`, **Content-Language** is the only way to specify the language. When **Content-Type** is
     `application/json`, **Content-Language** overrides a language specified with the `language` parameter of a
     `ContentItem` object, and content items that specify a different language are ignored; omit this parameter to base
     the language on the specification of the content items. You can specify any combination of languages for
     **Content-Language** and **Accept-Language**.
     - parameter acceptLanguage: The desired language of the response. For two-character arguments, regional variants are treated as their parent
     language; for example, `en-US` is interpreted as `en`. You can specify any combination of languages for the input
     and response content.
     - parameter rawScores: Indicates whether a raw score in addition to a normalized percentile is returned for each characteristic; raw
     scores are not compared with a sample population. By default, only normalized percentiles are returned.
     - parameter consumptionPreferences: Indicates whether consumption preferences are returned with the results. By default, no consumption preferences are
     returned.
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

        // construct header parameters
        var headers = defaultHeaders
        headers["Accept"] = "application/json"
        headers["Content-Type"] = "application/json"
        if let contentLanguage = contentLanguage {
            headers["Content-Language"] = contentLanguage
        }
        if let acceptLanguage = acceptLanguage {
            headers["Accept-Language"] = acceptLanguage
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
            headerParameters: headers,
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
     Get profile.

     Generates a personality profile for the author of the input text. The service accepts a maximum of 20 MB of input
     content, but it requires much less text to produce an accurate profile; for more information, see [Providing
     sufficient input](https://console.bluemix.net/docs/services/personality-insights/input.html#sufficient). The
     service analyzes text in Arabic, English, Japanese, Korean, or Spanish and returns its results in a variety of
     languages. You can provide plain text, HTML, or JSON input by specifying the **Content-Type** parameter; the
     default is `text/plain`. Request a JSON or comma-separated values (CSV) response by specifying the **Accept**
     parameter; CSV output includes a fixed number of columns and optional headers.   Per the JSON specification, the
     default character encoding for JSON content is effectively always UTF-8; per the HTTP specification, the default
     encoding for plain text and HTML is ISO-8859-1 (effectively, the ASCII character set). When specifying a content
     type of plain text or HTML, include the `charset` parameter to indicate the character encoding of the input text;
     for example: `Content-Type: text/plain;charset=utf-8`.   For detailed information about calling the service and the
     responses it can generate, see (Requesting a
     profile)[https://console.bluemix.net/docs/services/personality-insights/input.html], (Understanding a JSON
     profile)[https://console.bluemix.net/docs/services/personality-insights/output.html], and (Understanding a CSV
     profile)[https://console.bluemix.net/docs/services/personality-insights/output-csv.html].

     - parameter text: A maximum of 20 MB of content to analyze, though the service requires much less text; for more information, see
     [Providing sufficient input](https://console.bluemix.net/docs/services/personality-insights/input.html#sufficient).
     For JSON input, provide an object of type `Content`.
     - parameter contentLanguage: The language of the input text for the request: Arabic, English, Japanese, Korean, or Spanish. Regional variants
     are treated as their parent language; for example, `en-US` is interpreted as `en`.   The effect of the
     **Content-Language** parameter depends on the **Content-Type** parameter. When **Content-Type** is `text/plain` or
     `text/html`, **Content-Language** is the only way to specify the language. When **Content-Type** is
     `application/json`, **Content-Language** overrides a language specified with the `language` parameter of a
     `ContentItem` object, and content items that specify a different language are ignored; omit this parameter to base
     the language on the specification of the content items. You can specify any combination of languages for
     **Content-Language** and **Accept-Language**.
     - parameter acceptLanguage: The desired language of the response. For two-character arguments, regional variants are treated as their parent
     language; for example, `en-US` is interpreted as `en`. You can specify any combination of languages for the input
     and response content.
     - parameter rawScores: Indicates whether a raw score in addition to a normalized percentile is returned for each characteristic; raw
     scores are not compared with a sample population. By default, only normalized percentiles are returned.
     - parameter consumptionPreferences: Indicates whether consumption preferences are returned with the results. By default, no consumption preferences are
     returned.
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

        // construct header parameters
        var headers = defaultHeaders
        headers["Accept"] = "application/json"
        headers["Content-Type"] = "text/plain"
        if let contentLanguage = contentLanguage {
            headers["Content-Language"] = contentLanguage
        }
        if let acceptLanguage = acceptLanguage {
            headers["Accept-Language"] = acceptLanguage
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
            headerParameters: headers,
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
     Get profile.

     Generates a personality profile for the author of the input text. The service accepts a maximum of 20 MB of input
     content, but it requires much less text to produce an accurate profile; for more information, see [Providing
     sufficient input](https://console.bluemix.net/docs/services/personality-insights/input.html#sufficient). The
     service analyzes text in Arabic, English, Japanese, Korean, or Spanish and returns its results in a variety of
     languages. You can provide plain text, HTML, or JSON input by specifying the **Content-Type** parameter; the
     default is `text/plain`. Request a JSON or comma-separated values (CSV) response by specifying the **Accept**
     parameter; CSV output includes a fixed number of columns and optional headers.   Per the JSON specification, the
     default character encoding for JSON content is effectively always UTF-8; per the HTTP specification, the default
     encoding for plain text and HTML is ISO-8859-1 (effectively, the ASCII character set). When specifying a content
     type of plain text or HTML, include the `charset` parameter to indicate the character encoding of the input text;
     for example: `Content-Type: text/plain;charset=utf-8`.   For detailed information about calling the service and the
     responses it can generate, see (Requesting a
     profile)[https://console.bluemix.net/docs/services/personality-insights/input.html], (Understanding a JSON
     profile)[https://console.bluemix.net/docs/services/personality-insights/output.html], and (Understanding a CSV
     profile)[https://console.bluemix.net/docs/services/personality-insights/output-csv.html].

     - parameter html: A maximum of 20 MB of content to analyze, though the service requires much less text; for more information, see
     [Providing sufficient input](https://console.bluemix.net/docs/services/personality-insights/input.html#sufficient).
     For JSON input, provide an object of type `Content`.
     - parameter contentLanguage: The language of the input text for the request: Arabic, English, Japanese, Korean, or Spanish. Regional variants
     are treated as their parent language; for example, `en-US` is interpreted as `en`.   The effect of the
     **Content-Language** parameter depends on the **Content-Type** parameter. When **Content-Type** is `text/plain` or
     `text/html`, **Content-Language** is the only way to specify the language. When **Content-Type** is
     `application/json`, **Content-Language** overrides a language specified with the `language` parameter of a
     `ContentItem` object, and content items that specify a different language are ignored; omit this parameter to base
     the language on the specification of the content items. You can specify any combination of languages for
     **Content-Language** and **Accept-Language**.
     - parameter acceptLanguage: The desired language of the response. For two-character arguments, regional variants are treated as their parent
     language; for example, `en-US` is interpreted as `en`. You can specify any combination of languages for the input
     and response content.
     - parameter rawScores: Indicates whether a raw score in addition to a normalized percentile is returned for each characteristic; raw
     scores are not compared with a sample population. By default, only normalized percentiles are returned.
     - parameter consumptionPreferences: Indicates whether consumption preferences are returned with the results. By default, no consumption preferences are
     returned.
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

        // construct header parameters
        var headers = defaultHeaders
        headers["Accept"] = "application/json"
        headers["Content-Type"] = "text/html"
        if let contentLanguage = contentLanguage {
            headers["Content-Language"] = contentLanguage
        }
        if let acceptLanguage = acceptLanguage {
            headers["Accept-Language"] = acceptLanguage
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
            headerParameters: headers,
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
     Get profile. as csv

     Generates a personality profile for the author of the input text. The service accepts a maximum of 20 MB of input
     content, but it requires much less text to produce an accurate profile; for more information, see [Providing
     sufficient input](https://console.bluemix.net/docs/services/personality-insights/input.html#sufficient). The
     service analyzes text in Arabic, English, Japanese, Korean, or Spanish and returns its results in a variety of
     languages. You can provide plain text, HTML, or JSON input by specifying the **Content-Type** parameter; the
     default is `text/plain`. Request a JSON or comma-separated values (CSV) response by specifying the **Accept**
     parameter; CSV output includes a fixed number of columns and optional headers.   Per the JSON specification, the
     default character encoding for JSON content is effectively always UTF-8; per the HTTP specification, the default
     encoding for plain text and HTML is ISO-8859-1 (effectively, the ASCII character set). When specifying a content
     type of plain text or HTML, include the `charset` parameter to indicate the character encoding of the input text;
     for example: `Content-Type: text/plain;charset=utf-8`.   For detailed information about calling the service and the
     responses it can generate, see (Requesting a
     profile)[https://console.bluemix.net/docs/services/personality-insights/input.html], (Understanding a JSON
     profile)[https://console.bluemix.net/docs/services/personality-insights/output.html], and (Understanding a CSV
     profile)[https://console.bluemix.net/docs/services/personality-insights/output-csv.html].

     - parameter content: A maximum of 20 MB of content to analyze, though the service requires much less text; for more information, see
     [Providing sufficient input](https://console.bluemix.net/docs/services/personality-insights/input.html#sufficient).
     For JSON input, provide an object of type `Content`.
     - parameter contentLanguage: The language of the input text for the request: Arabic, English, Japanese, Korean, or Spanish. Regional variants
     are treated as their parent language; for example, `en-US` is interpreted as `en`.   The effect of the
     **Content-Language** parameter depends on the **Content-Type** parameter. When **Content-Type** is `text/plain` or
     `text/html`, **Content-Language** is the only way to specify the language. When **Content-Type** is
     `application/json`, **Content-Language** overrides a language specified with the `language` parameter of a
     `ContentItem` object, and content items that specify a different language are ignored; omit this parameter to base
     the language on the specification of the content items. You can specify any combination of languages for
     **Content-Language** and **Accept-Language**.
     - parameter acceptLanguage: The desired language of the response. For two-character arguments, regional variants are treated as their parent
     language; for example, `en-US` is interpreted as `en`. You can specify any combination of languages for the input
     and response content.
     - parameter rawScores: Indicates whether a raw score in addition to a normalized percentile is returned for each characteristic; raw
     scores are not compared with a sample population. By default, only normalized percentiles are returned.
     - parameter consumptionPreferences: Indicates whether consumption preferences are returned with the results. By default, no consumption preferences are
     returned.
     - parameter csvHeaders: Indicates whether column labels are returned with a CSV response. By default, no column labels are returned.
     Applies only when the **Accept** parameter is set to `text/csv`.
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

        // construct header parameters
        var headers = defaultHeaders
        headers["Accept"] = "text/csv"
        headers["Content-Type"] = "application/json"
        if let contentLanguage = contentLanguage {
            headers["Content-Language"] = contentLanguage
        }
        if let acceptLanguage = acceptLanguage {
            headers["Accept-Language"] = acceptLanguage
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
            headerParameters: headers,
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
     Get profile. as csv

     Generates a personality profile for the author of the input text. The service accepts a maximum of 20 MB of input
     content, but it requires much less text to produce an accurate profile; for more information, see [Providing
     sufficient input](https://console.bluemix.net/docs/services/personality-insights/input.html#sufficient). The
     service analyzes text in Arabic, English, Japanese, Korean, or Spanish and returns its results in a variety of
     languages. You can provide plain text, HTML, or JSON input by specifying the **Content-Type** parameter; the
     default is `text/plain`. Request a JSON or comma-separated values (CSV) response by specifying the **Accept**
     parameter; CSV output includes a fixed number of columns and optional headers.   Per the JSON specification, the
     default character encoding for JSON content is effectively always UTF-8; per the HTTP specification, the default
     encoding for plain text and HTML is ISO-8859-1 (effectively, the ASCII character set). When specifying a content
     type of plain text or HTML, include the `charset` parameter to indicate the character encoding of the input text;
     for example: `Content-Type: text/plain;charset=utf-8`.   For detailed information about calling the service and the
     responses it can generate, see (Requesting a
     profile)[https://console.bluemix.net/docs/services/personality-insights/input.html], (Understanding a JSON
     profile)[https://console.bluemix.net/docs/services/personality-insights/output.html], and (Understanding a CSV
     profile)[https://console.bluemix.net/docs/services/personality-insights/output-csv.html].

     - parameter text: A maximum of 20 MB of content to analyze, though the service requires much less text; for more information, see
     [Providing sufficient input](https://console.bluemix.net/docs/services/personality-insights/input.html#sufficient).
     For JSON input, provide an object of type `Content`.
     - parameter contentLanguage: The language of the input text for the request: Arabic, English, Japanese, Korean, or Spanish. Regional variants
     are treated as their parent language; for example, `en-US` is interpreted as `en`.   The effect of the
     **Content-Language** parameter depends on the **Content-Type** parameter. When **Content-Type** is `text/plain` or
     `text/html`, **Content-Language** is the only way to specify the language. When **Content-Type** is
     `application/json`, **Content-Language** overrides a language specified with the `language` parameter of a
     `ContentItem` object, and content items that specify a different language are ignored; omit this parameter to base
     the language on the specification of the content items. You can specify any combination of languages for
     **Content-Language** and **Accept-Language**.
     - parameter acceptLanguage: The desired language of the response. For two-character arguments, regional variants are treated as their parent
     language; for example, `en-US` is interpreted as `en`. You can specify any combination of languages for the input
     and response content.
     - parameter rawScores: Indicates whether a raw score in addition to a normalized percentile is returned for each characteristic; raw
     scores are not compared with a sample population. By default, only normalized percentiles are returned.
     - parameter consumptionPreferences: Indicates whether consumption preferences are returned with the results. By default, no consumption preferences are
     returned.
     - parameter csvHeaders: Indicates whether column labels are returned with a CSV response. By default, no column labels are returned.
     Applies only when the **Accept** parameter is set to `text/csv`.
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

        // construct header parameters
        var headers = defaultHeaders
        headers["Accept"] = "text/csv"
        headers["Content-Type"] = "text/plain"
        if let contentLanguage = contentLanguage {
            headers["Content-Language"] = contentLanguage
        }
        if let acceptLanguage = acceptLanguage {
            headers["Accept-Language"] = acceptLanguage
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
            headerParameters: headers,
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
     Get profile. as csv

     Generates a personality profile for the author of the input text. The service accepts a maximum of 20 MB of input
     content, but it requires much less text to produce an accurate profile; for more information, see [Providing
     sufficient input](https://console.bluemix.net/docs/services/personality-insights/input.html#sufficient). The
     service analyzes text in Arabic, English, Japanese, Korean, or Spanish and returns its results in a variety of
     languages. You can provide plain text, HTML, or JSON input by specifying the **Content-Type** parameter; the
     default is `text/plain`. Request a JSON or comma-separated values (CSV) response by specifying the **Accept**
     parameter; CSV output includes a fixed number of columns and optional headers.   Per the JSON specification, the
     default character encoding for JSON content is effectively always UTF-8; per the HTTP specification, the default
     encoding for plain text and HTML is ISO-8859-1 (effectively, the ASCII character set). When specifying a content
     type of plain text or HTML, include the `charset` parameter to indicate the character encoding of the input text;
     for example: `Content-Type: text/plain;charset=utf-8`.   For detailed information about calling the service and the
     responses it can generate, see (Requesting a
     profile)[https://console.bluemix.net/docs/services/personality-insights/input.html], (Understanding a JSON
     profile)[https://console.bluemix.net/docs/services/personality-insights/output.html], and (Understanding a CSV
     profile)[https://console.bluemix.net/docs/services/personality-insights/output-csv.html].

     - parameter html: A maximum of 20 MB of content to analyze, though the service requires much less text; for more information, see
     [Providing sufficient input](https://console.bluemix.net/docs/services/personality-insights/input.html#sufficient).
     For JSON input, provide an object of type `Content`.
     - parameter contentLanguage: The language of the input text for the request: Arabic, English, Japanese, Korean, or Spanish. Regional variants
     are treated as their parent language; for example, `en-US` is interpreted as `en`.   The effect of the
     **Content-Language** parameter depends on the **Content-Type** parameter. When **Content-Type** is `text/plain` or
     `text/html`, **Content-Language** is the only way to specify the language. When **Content-Type** is
     `application/json`, **Content-Language** overrides a language specified with the `language` parameter of a
     `ContentItem` object, and content items that specify a different language are ignored; omit this parameter to base
     the language on the specification of the content items. You can specify any combination of languages for
     **Content-Language** and **Accept-Language**.
     - parameter acceptLanguage: The desired language of the response. For two-character arguments, regional variants are treated as their parent
     language; for example, `en-US` is interpreted as `en`. You can specify any combination of languages for the input
     and response content.
     - parameter rawScores: Indicates whether a raw score in addition to a normalized percentile is returned for each characteristic; raw
     scores are not compared with a sample population. By default, only normalized percentiles are returned.
     - parameter consumptionPreferences: Indicates whether consumption preferences are returned with the results. By default, no consumption preferences are
     returned.
     - parameter csvHeaders: Indicates whether column labels are returned with a CSV response. By default, no column labels are returned.
     Applies only when the **Accept** parameter is set to `text/csv`.
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

        // construct header parameters
        var headers = defaultHeaders
        headers["Accept"] = "text/csv"
        headers["Content-Type"] = "text/html"
        if let contentLanguage = contentLanguage {
            headers["Content-Language"] = contentLanguage
        }
        if let acceptLanguage = acceptLanguage {
            headers["Accept-Language"] = acceptLanguage
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
            headerParameters: headers,
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
