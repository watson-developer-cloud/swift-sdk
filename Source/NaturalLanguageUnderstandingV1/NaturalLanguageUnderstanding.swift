/**
 * (C) Copyright IBM Corp. 2017, 2019.
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
import IBMSwiftSDKCore

/**
 Analyze various features of text content at scale. Provide text, raw HTML, or a public URL and IBM Watson Natural
 Language Understanding will give you results for the features you request. The service cleans HTML content before
 analysis by default, so the results can ignore most advertisements and other unwanted content.
 You can create [custom
 models](https://cloud.ibm.com/docs/services/natural-language-understanding?topic=natural-language-understanding-customizing)
 with Watson Knowledge Studio to detect custom entities, relations, and categories in Natural Language Understanding.
 */
public class NaturalLanguageUnderstanding {

    /// The base URL to use when contacting the service.
    public var serviceURL: String? = "https://gateway.watsonplatform.net/natural-language-understanding/api"

    /// Service identifiers
    internal let serviceName = "NaturalLanguageUnderstanding"
    internal let serviceVersion = "v1"
    internal let serviceSdkName = "natural_language_understanding"

    /// The default HTTP headers for all requests to the service.
    public var defaultHeaders = [String: String]()

    var session = URLSession(configuration: URLSessionConfiguration.default)
    public let authenticator: Authenticator
    let version: String

    #if os(Linux)
    /**
     Create a `NaturalLanguageUnderstanding` object.

     This initializer will retrieve credentials from the environment or a local credentials file.
     The credentials file can be downloaded from your service instance on IBM Cloud as ibm-credentials.env.
     Make sure to add the credentials file to your project so that it can be loaded at runtime.

     If credentials are not available in the environment or a local credentials file, initialization will fail.
     In that case, try another initializer that directly passes in the credentials.

     - parameter version: The release date of the version of the API to use. Specify the date
       in "YYYY-MM-DD" format.
     */
    public init(version: String) throws {
        self.version = version

        let authenticator = try ConfigBasedAuthenticatorFactory.getAuthenticator(credentialPrefix: serviceSdkName)
        self.authenticator = authenticator

        if let serviceURL = CredentialUtils.getServiceURL(credentialPrefix: serviceSdkName) {
            self.serviceURL = serviceURL
        }

        RestRequest.userAgent = Shared.userAgent
    }
    #endif

    /**
     Create a `NaturalLanguageUnderstanding` object.

     - parameter version: The release date of the version of the API to use. Specify the date
       in "YYYY-MM-DD" format.
     - parameter authenticator: The Authenticator object used to authenticate requests to the service
     */
    public init(version: String, authenticator: Authenticator) {
        self.version = version
        self.authenticator = authenticator
        RestRequest.userAgent = Shared.userAgent
    }

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
    func errorResponseDecoder(data: Data, response: HTTPURLResponse) -> WatsonError {

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

        return WatsonError.http(statusCode: statusCode, message: errorMessage, metadata: metadata)
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
     - Syntax (Experimental).

     - parameter features: Specific features to analyze the document for.
     - parameter text: The plain text to analyze. One of the `text`, `html`, or `url` parameters is required.
     - parameter html: The HTML file to analyze. One of the `text`, `html`, or `url` parameters is required.
     - parameter url: The webpage to analyze. One of the `text`, `html`, or `url` parameters is required.
     - parameter clean: Set this to `false` to disable webpage cleaning. To learn more about webpage cleaning, see the
       [Analyzing
       webpages](https://cloud.ibm.com/docs/services/natural-language-understanding?topic=natural-language-understanding-analyzing-webpages)
       documentation.
     - parameter xpath: An [XPath
       query](https://cloud.ibm.com/docs/services/natural-language-understanding?topic=natural-language-understanding-analyzing-webpages#xpath)
       to perform on `html` or `url` input. Results of the query will be appended to the cleaned webpage text before it
       is analyzed. To analyze only the results of the XPath query, set the `clean` parameter to `false`.
     - parameter fallbackToRaw: Whether to use raw HTML content if text cleaning fails.
     - parameter returnAnalyzedText: Whether or not to return the analyzed text.
     - parameter language: ISO 639-1 code that specifies the language of your text. This overrides automatic language
       detection. Language support differs depending on the features you include in your analysis. See [Language
       support](https://cloud.ibm.com/docs/services/natural-language-understanding?topic=natural-language-understanding-language-support)
       for more information.
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
        let analyzeRequest = Parameters(
            features: features,
            text: text,
            html: html,
            url: url,
            clean: clean,
            xpath: xpath,
            fallbackToRaw: fallbackToRaw,
            returnAnalyzedText: returnAnalyzedText,
            language: language,
            limitTextCharacters: limitTextCharacters)
        guard let body = try? JSON.encoder.encode(analyzeRequest) else {
            completionHandler(nil, WatsonError.serialization(values: "request body"))
            return
        }

        // construct header parameters
        var headerParameters = defaultHeaders
        if let headers = headers {
            headerParameters.merge(headers) { (_, new) in new }
        }
        let sdkHeaders = Shared.getSDKHeaders(serviceName: serviceName, serviceVersion: serviceVersion, methodName: "analyze")
        headerParameters.merge(sdkHeaders) { (_, new) in new }
        headerParameters["Accept"] = "application/json"
        headerParameters["Content-Type"] = "application/json"

        // construct query parameters
        var queryParameters = [URLQueryItem]()
        queryParameters.append(URLQueryItem(name: "version", value: version))

        // construct REST request

        // ensure that serviceURL is set
        guard let serviceEndpoint = serviceURL else {
            completionHandler(nil, WatsonError.noEndpoint)
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

    /**
     List models.

     Lists Watson Knowledge Studio [custom entities and relations
     models](https://cloud.ibm.com/docs/services/natural-language-understanding?topic=natural-language-understanding-customizing)
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
        if let headers = headers {
            headerParameters.merge(headers) { (_, new) in new }
        }
        let sdkHeaders = Shared.getSDKHeaders(serviceName: serviceName, serviceVersion: serviceVersion, methodName: "listModels")
        headerParameters.merge(sdkHeaders) { (_, new) in new }
        headerParameters["Accept"] = "application/json"

        // construct query parameters
        var queryParameters = [URLQueryItem]()
        queryParameters.append(URLQueryItem(name: "version", value: version))

        // construct REST request

        // ensure that serviceURL is set
        guard let serviceEndpoint = serviceURL else {
            completionHandler(nil, WatsonError.noEndpoint)
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
        if let headers = headers {
            headerParameters.merge(headers) { (_, new) in new }
        }
        let sdkHeaders = Shared.getSDKHeaders(serviceName: serviceName, serviceVersion: serviceVersion, methodName: "deleteModel")
        headerParameters.merge(sdkHeaders) { (_, new) in new }
        headerParameters["Accept"] = "application/json"

        // construct query parameters
        var queryParameters = [URLQueryItem]()
        queryParameters.append(URLQueryItem(name: "version", value: version))

        // construct REST request
        let path = "/v1/models/\(modelID)"
        guard let encodedPath = path.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else {
            completionHandler(nil, WatsonError.urlEncoding(path: path))
            return
        }

        // ensure that serviceURL is set
        guard let serviceEndpoint = serviceURL else {
            completionHandler(nil, WatsonError.noEndpoint)
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
