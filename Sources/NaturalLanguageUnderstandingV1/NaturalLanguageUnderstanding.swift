/**
 * (C) Copyright IBM Corp. 2017, 2020.
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

/**
 * IBM OpenAPI SDK Code Generator Version: 99-SNAPSHOT-36b26b63-20201028-122900
 **/

// swiftlint:disable file_length

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif
import IBMSwiftSDKCore

public typealias WatsonError = RestError
public typealias WatsonResponse = RestResponse
/**
 Analyze various features of text content at scale. Provide text, raw HTML, or a public URL and IBM Watson Natural
 Language Understanding will give you results for the features you request. The service cleans HTML content before
 analysis by default, so the results can ignore most advertisements and other unwanted content.
 You can create [custom
 models](https://cloud.ibm.com/docs/natural-language-understanding?topic=natural-language-understanding-customizing)
 with Watson Knowledge Studio to detect custom entities and relations in Natural Language Understanding.
 */
public class NaturalLanguageUnderstanding {

    /// The base URL to use when contacting the service.
    public var serviceURL: String? = "https://api.us-south.natural-language-understanding.watson.cloud.ibm.com"

    /// Release date of the API version you want to use. Specify dates in YYYY-MM-DD format. The current version is
    /// `2020-08-01`.
    public var version: String

    /// Service identifiers
    public static let defaultServiceName = "natural-language-understanding"
    // Service info for SDK headers
    internal let serviceName = defaultServiceName
    internal let serviceVersion = "v1"
    internal let serviceSdkName = "natural_language_understanding"

    /// The default HTTP headers for all requests to the service.
    public var defaultHeaders = [String: String]()

    var session = URLSession(configuration: URLSessionConfiguration.default)
    public let authenticator: Authenticator

    #if os(Linux)
    /**
     Create a `NaturalLanguageUnderstanding` object.

     If an authenticator is not supplied, the initializer will retrieve credentials from the environment or
     a local credentials file and construct an appropriate authenticator using these credentials.
     The credentials file can be downloaded from your service instance on IBM Cloud as ibm-credentials.env.
     Make sure to add the credentials file to your project so that it can be loaded at runtime.

     If an authenticator is not supplied and credentials are not available in the environment or a local
     credentials file, initialization will fail by throwing an exception.
     In that case, try another initializer that directly passes in the credentials.

     - parameter version: Release date of the API version you want to use. Specify dates in YYYY-MM-DD format. The
       current version is `2020-08-01`.
     - parameter authenticator: The Authenticator object used to authenticate requests to the service
     - serviceName: String = defaultServiceName
     */
    public init(version: String, authenticator: Authenticator? = nil, serviceName: String = defaultServiceName) throws {
        self.version = version
        self.authenticator = try authenticator ?? ConfigBasedAuthenticatorFactory.getAuthenticator(credentialPrefix: serviceName)
        if let serviceURL = CredentialUtils.getServiceURL(credentialPrefix: serviceName) {
            self.serviceURL = serviceURL
        }
        RestRequest.userAgent = Shared.userAgent
    }
    #else
    /**
     Create a `NaturalLanguageUnderstanding` object.

     - parameter version: Release date of the API version you want to use. Specify dates in YYYY-MM-DD format. The
       current version is `2020-08-01`.
     - parameter authenticator: The Authenticator object used to authenticate requests to the service
     */
    public init(version: String, authenticator: Authenticator) {
        self.version = version
        self.authenticator = authenticator
        RestRequest.userAgent = Shared.userAgent
    }
    #endif

    #if !os(Linux)
    /**
      Allow network requests to a server without verification of the server certificate.
      **IMPORTANT**: This should ONLY be used if truly intended, as it is unsafe otherwise.
     */
    public func disableSSLVerification() {
        session = InsecureConnection.session()
    }
    #endif

    /**
     Use the HTTP response and data received by the Natural Language Understanding service to extract
     information about the error that occurred.

     - parameter data: Raw data returned by the service that may represent an error.
     - parameter response: the URL response returned by the service.
     */
    func errorResponseDecoder(data: Data, response: HTTPURLResponse) -> RestError {

        let statusCode = response.statusCode
        var errorMessage: String?
        var metadata = [String: Any]()

        do {
            let json = try JSON.decoder.decode([String: JSON].self, from: data)
            metadata["response"] = json
            if case let .some(.array(errors)) = json["errors"],
                case let .some(.object(error)) = errors.first,
                case let .some(.string(message)) = error["message"] {
                errorMessage = message
            } else if case let .some(.string(message)) = json["error"] {
                errorMessage = message
            } else if case let .some(.string(message)) = json["message"] {
                errorMessage = message
            } else {
                errorMessage = HTTPURLResponse.localizedString(forStatusCode: response.statusCode)
            }
        } catch {
            metadata["response"] = data
            errorMessage = HTTPURLResponse.localizedString(forStatusCode: response.statusCode)
        }

        return RestError.http(statusCode: statusCode, message: errorMessage, metadata: metadata)
    }

    /**
     Analyze text.

     Analyzes text, HTML, or a public webpage for the following features:
     - Categories
     - Concepts
     - Emotion
     - Entities
     - Keywords
     - Metadata
     - Relations
     - Semantic roles
     - Sentiment
     - Syntax
     - Summarization (Experimental)
     If a language for the input text is not specified with the `language` parameter, the service [automatically detects
     the
     language](https://cloud.ibm.com/docs/natural-language-understanding?topic=natural-language-understanding-detectable-languages).

     - parameter features: Specific features to analyze the document for.
     - parameter text: The plain text to analyze. One of the `text`, `html`, or `url` parameters is required.
     - parameter html: The HTML file to analyze. One of the `text`, `html`, or `url` parameters is required.
     - parameter url: The webpage to analyze. One of the `text`, `html`, or `url` parameters is required.
     - parameter clean: Set this to `false` to disable webpage cleaning. For more information about webpage cleaning,
       see [Analyzing
       webpages](https://cloud.ibm.com/docs/natural-language-understanding?topic=natural-language-understanding-analyzing-webpages).
     - parameter xpath: An [XPath
       query](https://cloud.ibm.com/docs/natural-language-understanding?topic=natural-language-understanding-analyzing-webpages#xpath)
       to perform on `html` or `url` input. Results of the query will be appended to the cleaned webpage text before it
       is analyzed. To analyze only the results of the XPath query, set the `clean` parameter to `false`.
     - parameter fallbackToRaw: Whether to use raw HTML content if text cleaning fails.
     - parameter returnAnalyzedText: Whether or not to return the analyzed text.
     - parameter language: ISO 639-1 code that specifies the language of your text. This overrides automatic language
       detection. Language support differs depending on the features you include in your analysis. For more information,
       see [Language
       support](https://cloud.ibm.com/docs/natural-language-understanding?topic=natural-language-understanding-language-support).
     - parameter limitTextCharacters: Sets the maximum number of characters that are processed by the service.
     - parameter headers: A dictionary of request headers to be sent with this request.
     - parameter completionHandler: A function executed when the request completes with a successful result or error
     */
    public func analyze(
        features: Features,
        text: String? = nil,
        html: String? = nil,
        url: String? = nil,
        clean: Bool? = nil,
        xpath: String? = nil,
        fallbackToRaw: Bool? = nil,
        returnAnalyzedText: Bool? = nil,
        language: String? = nil,
        limitTextCharacters: Int? = nil,
        headers: [String: String]? = nil,
        completionHandler: @escaping (WatsonResponse<AnalysisResults>?, WatsonError?) -> Void)
    {
        // construct body
        let analyzeRequest = AnalyzeRequest(
            features: features,
            text: text,
            html: html,
            url: url,
            clean: clean,
            xpath: xpath,
            fallback_to_raw: fallbackToRaw,
            return_analyzed_text: returnAnalyzedText,
            language: language,
            limit_text_characters: limitTextCharacters)
        guard let body = try? JSON.encoder.encode(analyzeRequest) else {
            completionHandler(nil, RestError.serialization(values: "request body"))
            return
        }

        // construct header parameters
        var headerParameters = defaultHeaders
        let sdkHeaders = Shared.getSDKHeaders(serviceName: serviceName, serviceVersion: serviceVersion, methodName: "analyze")
        headerParameters.merge(sdkHeaders) { (_, new) in new }
        headerParameters["Accept"] = "application/json"
        headerParameters["Content-Type"] = "application/json"
        if let headers = headers {
            headerParameters.merge(headers) { (_, new) in new }
        }

        // construct query parameters
        var queryParameters = [URLQueryItem]()
        queryParameters.append(URLQueryItem(name: "version", value: version))

        // construct REST request

        // ensure that serviceURL is set
        guard let serviceEndpoint = serviceURL else {
            completionHandler(nil, RestError.noEndpoint)
            return
        }

        let request = RestRequest(
            session: session,
            authenticator: authenticator,
            errorResponseDecoder: errorResponseDecoder,
            method: "POST",
            url: serviceEndpoint + "/v1/analyze",
            headerParameters: headerParameters,
            queryItems: queryParameters,
            messageBody: body
        )

        // execute REST request
        request.responseObject(completionHandler: completionHandler)
    }

    // Private struct for the analyze request body
    private struct AnalyzeRequest: Encodable {
        // swiftlint:disable identifier_name
        let features: Features
        let text: String?
        let html: String?
        let url: String?
        let clean: Bool?
        let xpath: String?
        let fallback_to_raw: Bool?
        let return_analyzed_text: Bool?
        let language: String?
        let limit_text_characters: Int?
        // swiftlint:enable identifier_name
    }

    /**
     List models.

     Lists Watson Knowledge Studio [custom entities and relations
     models](https://cloud.ibm.com/docs/natural-language-understanding?topic=natural-language-understanding-customizing)
     that are deployed to your Natural Language Understanding service.

     - parameter headers: A dictionary of request headers to be sent with this request.
     - parameter completionHandler: A function executed when the request completes with a successful result or error
     */
    public func listModels(
        headers: [String: String]? = nil,
        completionHandler: @escaping (WatsonResponse<ListModelsResults>?, WatsonError?) -> Void)
    {
        // construct header parameters
        var headerParameters = defaultHeaders
        let sdkHeaders = Shared.getSDKHeaders(serviceName: serviceName, serviceVersion: serviceVersion, methodName: "listModels")
        headerParameters.merge(sdkHeaders) { (_, new) in new }
        headerParameters["Accept"] = "application/json"
        if let headers = headers {
            headerParameters.merge(headers) { (_, new) in new }
        }

        // construct query parameters
        var queryParameters = [URLQueryItem]()
        queryParameters.append(URLQueryItem(name: "version", value: version))

        // construct REST request

        // ensure that serviceURL is set
        guard let serviceEndpoint = serviceURL else {
            completionHandler(nil, RestError.noEndpoint)
            return
        }

        let request = RestRequest(
            session: session,
            authenticator: authenticator,
            errorResponseDecoder: errorResponseDecoder,
            method: "GET",
            url: serviceEndpoint + "/v1/models",
            headerParameters: headerParameters,
            queryItems: queryParameters
        )

        // execute REST request
        request.responseObject(completionHandler: completionHandler)
    }

    /**
     Delete model.

     Deletes a custom model.

     - parameter modelID: Model ID of the model to delete.
     - parameter headers: A dictionary of request headers to be sent with this request.
     - parameter completionHandler: A function executed when the request completes with a successful result or error
     */
    public func deleteModel(
        modelID: String,
        headers: [String: String]? = nil,
        completionHandler: @escaping (WatsonResponse<DeleteModelResults>?, WatsonError?) -> Void)
    {
        // construct header parameters
        var headerParameters = defaultHeaders
        let sdkHeaders = Shared.getSDKHeaders(serviceName: serviceName, serviceVersion: serviceVersion, methodName: "deleteModel")
        headerParameters.merge(sdkHeaders) { (_, new) in new }
        headerParameters["Accept"] = "application/json"
        if let headers = headers {
            headerParameters.merge(headers) { (_, new) in new }
        }

        // construct query parameters
        var queryParameters = [URLQueryItem]()
        queryParameters.append(URLQueryItem(name: "version", value: version))

        // construct REST request
        let path = "/v1/models/\(modelID)"
        guard let encodedPath = path.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else {
            completionHandler(nil, RestError.urlEncoding(path: path))
            return
        }

        // ensure that serviceURL is set
        guard let serviceEndpoint = serviceURL else {
            completionHandler(nil, RestError.noEndpoint)
            return
        }

        let request = RestRequest(
            session: session,
            authenticator: authenticator,
            errorResponseDecoder: errorResponseDecoder,
            method: "DELETE",
            url: serviceEndpoint + encodedPath,
            headerParameters: headerParameters,
            queryItems: queryParameters
        )

        // execute REST request
        request.responseObject(completionHandler: completionHandler)
    }

}
