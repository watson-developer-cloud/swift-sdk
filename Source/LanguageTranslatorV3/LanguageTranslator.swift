/**
 * (C) Copyright IBM Corp. 2018, 2020.
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
 IBM Watson&trade; Language Translator translates text from one language to another. The service offers multiple IBM
 provided translation models that you can customize based on your unique terminology and language. Use Language
 Translator to take news from across the globe and present it in your language, communicate with your customers in their
 own language, and more.
 */
public class LanguageTranslator {

    /// The base URL to use when contacting the service.
    public var serviceURL: String? = "https://gateway.watsonplatform.net/language-translator/api"

    /// Service identifiers
    internal let serviceName = "LanguageTranslator"
    internal let serviceVersion = "v3"
    internal let serviceSdkName = "language_translator"

    /// The default HTTP headers for all requests to the service.
    public var defaultHeaders = [String: String]()

    var session = URLSession(configuration: URLSessionConfiguration.default)
    public let authenticator: Authenticator
    let version: String

    #if os(Linux)
    /**
     Create a `LanguageTranslator` object.

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
     Create a `LanguageTranslator` object.

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
     Use the HTTP response and data received by the Language Translator service to extract
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
     Translate.

     Translates the input text from the source language to the target language. A target language or translation model
     ID is required. The service attempts to detect the language of the source text if it is not specified.

     - parameter text: Input text in UTF-8 encoding. Multiple entries will result in multiple translations in the
       response.
     - parameter modelID: The model to use for translation. For example, `en-de` selects the IBM provided base model
       for English to German translation. A model ID overrides the source and target parameters and is required if you
       use a custom model. If no model ID is specified, you must specify a target language.
     - parameter source: Language code that specifies the language of the source document.
     - parameter target: Language code that specifies the target language for translation. Required if model ID is not
       specified.
     - parameter headers: A dictionary of request headers to be sent with this request.
     - parameter completionHandler: A function executed when the request completes with a successful result or error
     */
    public func translate(
        text: [String],
        modelID: String? = nil,
        source: String? = nil,
        target: String? = nil,
        headers: [String: String]? = nil,
        completionHandler: @escaping (WatsonResponse<TranslationResult>?, WatsonError?) -> Void)
    {
        // construct body
        let translateRequest = TranslateRequest(
            text: text,
            modelID: modelID,
            source: source,
            target: target)
        guard let body = try? JSON.encoder.encode(translateRequest) else {
            completionHandler(nil, WatsonError.serialization(values: "request body"))
            return
        }

        // construct header parameters
        var headerParameters = defaultHeaders
        if let headers = headers {
            headerParameters.merge(headers) { (_, new) in new }
        }
        let sdkHeaders = Shared.getSDKHeaders(serviceName: serviceName, serviceVersion: serviceVersion, methodName: "translate")
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
            url: serviceEndpoint + "/v3/translate",
            headerParameters: headerParameters,
            queryItems: queryParameters,
            messageBody: body
        )

        // execute REST request
        request.responseObject(completionHandler: completionHandler)
    }

    /**
     List identifiable languages.

     Lists the languages that the service can identify. Returns the language code (for example, `en` for English or `es`
     for Spanish) and name of each language.

     - parameter headers: A dictionary of request headers to be sent with this request.
     - parameter completionHandler: A function executed when the request completes with a successful result or error
     */
    public func listIdentifiableLanguages(
        headers: [String: String]? = nil,
        completionHandler: @escaping (WatsonResponse<IdentifiableLanguages>?, WatsonError?) -> Void)
    {
        // construct header parameters
        var headerParameters = defaultHeaders
        if let headers = headers {
            headerParameters.merge(headers) { (_, new) in new }
        }
        let sdkHeaders = Shared.getSDKHeaders(serviceName: serviceName, serviceVersion: serviceVersion, methodName: "listIdentifiableLanguages")
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
            url: serviceEndpoint + "/v3/identifiable_languages",
            headerParameters: headerParameters,
            queryItems: queryParameters
        )

        // execute REST request
        request.responseObject(completionHandler: completionHandler)
    }

    /**
     Identify language.

     Identifies the language of the input text.

     - parameter text: Input text in UTF-8 format.
     - parameter headers: A dictionary of request headers to be sent with this request.
     - parameter completionHandler: A function executed when the request completes with a successful result or error
     */
    public func identify(
        text: String,
        headers: [String: String]? = nil,
        completionHandler: @escaping (WatsonResponse<IdentifiedLanguages>?, WatsonError?) -> Void)
    {
        // construct body
        // convert body parameter to Data with UTF-8 encoding
        guard let body = text.data(using: .utf8) else {
            let error = WatsonError.serialization(values: "text could not be encoded with UTF8.")
            completionHandler(nil, error)
            return
        }

        // construct header parameters
        var headerParameters = defaultHeaders
        if let headers = headers {
            headerParameters.merge(headers) { (_, new) in new }
        }
        let sdkHeaders = Shared.getSDKHeaders(serviceName: serviceName, serviceVersion: serviceVersion, methodName: "identify")
        headerParameters.merge(sdkHeaders) { (_, new) in new }
        headerParameters["Accept"] = "application/json"
        headerParameters["Content-Type"] = "text/plain"

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
            url: serviceEndpoint + "/v3/identify",
            headerParameters: headerParameters,
            queryItems: queryParameters,
            messageBody: body
        )

        // execute REST request
        request.responseObject(completionHandler: completionHandler)
    }

    /**
     List models.

     Lists available translation models.

     - parameter source: Specify a language code to filter results by source language.
     - parameter target: Specify a language code to filter results by target language.
     - parameter `default`: If the default parameter isn't specified, the service will return all models (default and
       non-default) for each language pair. To return only default models, set this to `true`. To return only
       non-default models, set this to `false`. There is exactly one default model per language pair, the IBM provided
       base model.
     - parameter headers: A dictionary of request headers to be sent with this request.
     - parameter completionHandler: A function executed when the request completes with a successful result or error
     */
    public func listModels(
        source: String? = nil,
        target: String? = nil,
        `default`: Bool? = nil,
        headers: [String: String]? = nil,
        completionHandler: @escaping (WatsonResponse<TranslationModels>?, WatsonError?) -> Void)
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
        if let source = source {
            let queryParameter = URLQueryItem(name: "source", value: source)
            queryParameters.append(queryParameter)
        }
        if let target = target {
            let queryParameter = URLQueryItem(name: "target", value: target)
            queryParameters.append(queryParameter)
        }
        if let `default` = `default` {
            let queryParameter = URLQueryItem(name: "default", value: "\(`default`)")
            queryParameters.append(queryParameter)
        }

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
            url: serviceEndpoint + "/v3/models",
            headerParameters: headerParameters,
            queryItems: queryParameters
        )

        // execute REST request
        request.responseObject(completionHandler: completionHandler)
    }

    /**
     Create model.

     Uploads Translation Memory eXchange (TMX) files to customize a translation model.
     You can either customize a model with a forced glossary or with a corpus that contains parallel sentences. To
     create a model that is customized with a parallel corpus <b>and</b> a forced glossary, proceed in two steps:
     customize with a parallel corpus first and then customize the resulting model with a glossary. Depending on the
     type of customization and the size of the uploaded corpora, training can range from minutes for a glossary to
     several hours for a large parallel corpus. You can upload a single forced glossary file and this file must be less
     than <b>10 MB</b>. You can upload multiple parallel corpora tmx files. The cumulative file size of all uploaded
     files is limited to <b>250 MB</b>. To successfully train with a parallel corpus you must have at least <b>5,000
     parallel sentences</b> in your corpus.
     You can have a <b>maximum of 10 custom models per language pair</b>.

     - parameter baseModelID: The model ID of the model to use as the base for customization. To see available models,
       use the `List models` method. Usually all IBM provided models are customizable. In addition, all your models that
       have been created via parallel corpus customization, can be further customized with a forced glossary.
     - parameter forcedGlossary: A TMX file with your customizations. The customizations in the file completely
       overwrite the domain translaton data, including high frequency or high confidence phrase translations. You can
       upload only one glossary with a file size less than 10 MB per call. A forced glossary should contain single words
       or short phrases.
     - parameter parallelCorpus: A TMX file with parallel sentences for source and target language. You can upload
       multiple parallel_corpus files in one request. All uploaded parallel_corpus files combined, your parallel corpus
       must contain at least 5,000 parallel sentences to train successfully.
     - parameter name: An optional model name that you can use to identify the model. Valid characters are letters,
       numbers, dashes, underscores, spaces and apostrophes. The maximum length is 32 characters.
     - parameter headers: A dictionary of request headers to be sent with this request.
     - parameter completionHandler: A function executed when the request completes with a successful result or error
     */
    public func createModel(
        baseModelID: String,
        forcedGlossary: Data? = nil,
        parallelCorpus: Data? = nil,
        name: String? = nil,
        headers: [String: String]? = nil,
        completionHandler: @escaping (WatsonResponse<TranslationModel>?, WatsonError?) -> Void)
    {
        // construct body
        let multipartFormData = MultipartFormData()
        if let forcedGlossary = forcedGlossary {
            multipartFormData.append(forcedGlossary, withName: "forced_glossary", fileName: "filename")
        }
        if let parallelCorpus = parallelCorpus {
            multipartFormData.append(parallelCorpus, withName: "parallel_corpus", fileName: "filename")
        }
        guard let body = try? multipartFormData.toData() else {
            completionHandler(nil, WatsonError.serialization(values: "request multipart form data"))
            return
        }

        // construct header parameters
        var headerParameters = defaultHeaders
        if let headers = headers {
            headerParameters.merge(headers) { (_, new) in new }
        }
        let sdkHeaders = Shared.getSDKHeaders(serviceName: serviceName, serviceVersion: serviceVersion, methodName: "createModel")
        headerParameters.merge(sdkHeaders) { (_, new) in new }
        headerParameters["Accept"] = "application/json"
        headerParameters["Content-Type"] = multipartFormData.contentType

        // construct query parameters
        var queryParameters = [URLQueryItem]()
        queryParameters.append(URLQueryItem(name: "version", value: version))
        queryParameters.append(URLQueryItem(name: "base_model_id", value: baseModelID))
        if let name = name {
            let queryParameter = URLQueryItem(name: "name", value: name)
            queryParameters.append(queryParameter)
        }

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
            url: serviceEndpoint + "/v3/models",
            headerParameters: headerParameters,
            queryItems: queryParameters,
            messageBody: body
        )

        // execute REST request
        request.responseObject(completionHandler: completionHandler)
    }

    /**
     Delete model.

     Deletes a custom translation model.

     - parameter modelID: Model ID of the model to delete.
     - parameter headers: A dictionary of request headers to be sent with this request.
     - parameter completionHandler: A function executed when the request completes with a successful result or error
     */
    public func deleteModel(
        modelID: String,
        headers: [String: String]? = nil,
        completionHandler: @escaping (WatsonResponse<DeleteModelResult>?, WatsonError?) -> Void)
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
        let path = "/v3/models/\(modelID)"
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

    /**
     Get model details.

     Gets information about a translation model, including training status for custom models. Use this API call to poll
     the status of your customization request. A successfully completed training will have a status of `available`.

     - parameter modelID: Model ID of the model to get.
     - parameter headers: A dictionary of request headers to be sent with this request.
     - parameter completionHandler: A function executed when the request completes with a successful result or error
     */
    public func getModel(
        modelID: String,
        headers: [String: String]? = nil,
        completionHandler: @escaping (WatsonResponse<TranslationModel>?, WatsonError?) -> Void)
    {
        // construct header parameters
        var headerParameters = defaultHeaders
        if let headers = headers {
            headerParameters.merge(headers) { (_, new) in new }
        }
        let sdkHeaders = Shared.getSDKHeaders(serviceName: serviceName, serviceVersion: serviceVersion, methodName: "getModel")
        headerParameters.merge(sdkHeaders) { (_, new) in new }
        headerParameters["Accept"] = "application/json"

        // construct query parameters
        var queryParameters = [URLQueryItem]()
        queryParameters.append(URLQueryItem(name: "version", value: version))

        // construct REST request
        let path = "/v3/models/\(modelID)"
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
            method: "GET",
            url: serviceEndpoint + encodedPath,
            headerParameters: headerParameters,
            queryItems: queryParameters
        )

        // execute REST request
        request.responseObject(completionHandler: completionHandler)
    }

    /**
     List documents.

     Lists documents that have been submitted for translation.

     - parameter headers: A dictionary of request headers to be sent with this request.
     - parameter completionHandler: A function executed when the request completes with a successful result or error
     */
    public func listDocuments(
        headers: [String: String]? = nil,
        completionHandler: @escaping (WatsonResponse<DocumentList>?, WatsonError?) -> Void)
    {
        // construct header parameters
        var headerParameters = defaultHeaders
        if let headers = headers {
            headerParameters.merge(headers) { (_, new) in new }
        }
        let sdkHeaders = Shared.getSDKHeaders(serviceName: serviceName, serviceVersion: serviceVersion, methodName: "listDocuments")
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
            url: serviceEndpoint + "/v3/documents",
            headerParameters: headerParameters,
            queryItems: queryParameters
        )

        // execute REST request
        request.responseObject(completionHandler: completionHandler)
    }

    /**
     Translate document.

     Submit a document for translation. You can submit the document contents in the `file` parameter, or you can
     reference a previously submitted document by document ID.

     - parameter file: The contents of the source file to translate.
       [Supported file
       types](https://cloud.ibm.com/docs/language-translator?topic=language-translator-document-translator-tutorial#supported-file-formats)
       Maximum file size: **20 MB**.
     - parameter filename: The filename for file.
     - parameter fileContentType: The content type of file.
     - parameter modelID: The model to use for translation. For example, `en-de` selects the IBM provided base model
       for English to German translation. A model ID overrides the source and target parameters and is required if you
       use a custom model. If no model ID is specified, you must specify a target language.
     - parameter source: Language code that specifies the language of the source document.
     - parameter target: Language code that specifies the target language for translation. Required if model ID is not
       specified.
     - parameter documentID: To use a previously submitted document as the source for a new translation, enter the
       `document_id` of the document.
     - parameter headers: A dictionary of request headers to be sent with this request.
     - parameter completionHandler: A function executed when the request completes with a successful result or error
     */
    public func translateDocument(
        file: Data,
        filename: String,
        fileContentType: String? = nil,
        modelID: String? = nil,
        source: String? = nil,
        target: String? = nil,
        documentID: String? = nil,
        headers: [String: String]? = nil,
        completionHandler: @escaping (WatsonResponse<DocumentStatus>?, WatsonError?) -> Void)
    {
        // construct body
        let multipartFormData = MultipartFormData()
        multipartFormData.append(file, withName: "file", mimeType: fileContentType, fileName: filename)
        if let modelID = modelID {
            if let modelIDData = modelID.data(using: .utf8) {
                multipartFormData.append(modelIDData, withName: "model_id")
            }
        }
        if let source = source {
            if let sourceData = source.data(using: .utf8) {
                multipartFormData.append(sourceData, withName: "source")
            }
        }
        if let target = target {
            if let targetData = target.data(using: .utf8) {
                multipartFormData.append(targetData, withName: "target")
            }
        }
        if let documentID = documentID {
            if let documentIDData = documentID.data(using: .utf8) {
                multipartFormData.append(documentIDData, withName: "document_id")
            }
        }
        guard let body = try? multipartFormData.toData() else {
            completionHandler(nil, WatsonError.serialization(values: "request multipart form data"))
            return
        }

        // construct header parameters
        var headerParameters = defaultHeaders
        if let headers = headers {
            headerParameters.merge(headers) { (_, new) in new }
        }
        let sdkHeaders = Shared.getSDKHeaders(serviceName: serviceName, serviceVersion: serviceVersion, methodName: "translateDocument")
        headerParameters.merge(sdkHeaders) { (_, new) in new }
        headerParameters["Accept"] = "application/json"
        headerParameters["Content-Type"] = multipartFormData.contentType

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
            url: serviceEndpoint + "/v3/documents",
            headerParameters: headerParameters,
            queryItems: queryParameters,
            messageBody: body
        )

        // execute REST request
        request.responseObject(completionHandler: completionHandler)
    }

    /**
     Get document status.

     Gets the translation status of a document.

     - parameter documentID: The document ID of the document.
     - parameter headers: A dictionary of request headers to be sent with this request.
     - parameter completionHandler: A function executed when the request completes with a successful result or error
     */
    public func getDocumentStatus(
        documentID: String,
        headers: [String: String]? = nil,
        completionHandler: @escaping (WatsonResponse<DocumentStatus>?, WatsonError?) -> Void)
    {
        // construct header parameters
        var headerParameters = defaultHeaders
        if let headers = headers {
            headerParameters.merge(headers) { (_, new) in new }
        }
        let sdkHeaders = Shared.getSDKHeaders(serviceName: serviceName, serviceVersion: serviceVersion, methodName: "getDocumentStatus")
        headerParameters.merge(sdkHeaders) { (_, new) in new }
        headerParameters["Accept"] = "application/json"

        // construct query parameters
        var queryParameters = [URLQueryItem]()
        queryParameters.append(URLQueryItem(name: "version", value: version))

        // construct REST request
        let path = "/v3/documents/\(documentID)"
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
            method: "GET",
            url: serviceEndpoint + encodedPath,
            headerParameters: headerParameters,
            queryItems: queryParameters
        )

        // execute REST request
        request.responseObject(completionHandler: completionHandler)
    }

    /**
     Delete document.

     Deletes a document.

     - parameter documentID: Document ID of the document to delete.
     - parameter headers: A dictionary of request headers to be sent with this request.
     - parameter completionHandler: A function executed when the request completes with a successful result or error
     */
    public func deleteDocument(
        documentID: String,
        headers: [String: String]? = nil,
        completionHandler: @escaping (WatsonResponse<Void>?, WatsonError?) -> Void)
    {
        // construct header parameters
        var headerParameters = defaultHeaders
        if let headers = headers {
            headerParameters.merge(headers) { (_, new) in new }
        }
        let sdkHeaders = Shared.getSDKHeaders(serviceName: serviceName, serviceVersion: serviceVersion, methodName: "deleteDocument")
        headerParameters.merge(sdkHeaders) { (_, new) in new }

        // construct query parameters
        var queryParameters = [URLQueryItem]()
        queryParameters.append(URLQueryItem(name: "version", value: version))

        // construct REST request
        let path = "/v3/documents/\(documentID)"
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
        request.response(completionHandler: completionHandler)
    }

    /**
     Get translated document.

     Gets the translated document associated with the given document ID.

     - parameter documentID: The document ID of the document that was submitted for translation.
     - parameter accept: The type of the response: application/powerpoint, application/mspowerpoint,
       application/x-rtf, application/json, application/xml, application/vnd.ms-excel,
       application/vnd.openxmlformats-officedocument.spreadsheetml.sheet, application/vnd.ms-powerpoint,
       application/vnd.openxmlformats-officedocument.presentationml.presentation, application/msword,
       application/vnd.openxmlformats-officedocument.wordprocessingml.document,
       application/vnd.oasis.opendocument.spreadsheet, application/vnd.oasis.opendocument.presentation,
       application/vnd.oasis.opendocument.text, application/pdf, application/rtf, text/html, text/json, text/plain,
       text/richtext, text/rtf, or text/xml. A character encoding can be specified by including a `charset` parameter.
       For example, 'text/html;charset=utf-8'.
     - parameter headers: A dictionary of request headers to be sent with this request.
     - parameter completionHandler: A function executed when the request completes with a successful result or error
     */
    public func getTranslatedDocument(
        documentID: String,
        accept: String? = nil,
        headers: [String: String]? = nil,
        completionHandler: @escaping (WatsonResponse<Data>?, WatsonError?) -> Void)
    {
        // construct header parameters
        var headerParameters = defaultHeaders
        if let headers = headers {
            headerParameters.merge(headers) { (_, new) in new }
        }
        let sdkHeaders = Shared.getSDKHeaders(serviceName: serviceName, serviceVersion: serviceVersion, methodName: "getTranslatedDocument")
        headerParameters.merge(sdkHeaders) { (_, new) in new }
        if let accept = accept {
            headerParameters["Accept"] = accept
        }

        // construct query parameters
        var queryParameters = [URLQueryItem]()
        queryParameters.append(URLQueryItem(name: "version", value: version))

        // construct REST request
        let path = "/v3/documents/\(documentID)/translated_document"
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
            method: "GET",
            url: serviceEndpoint + encodedPath,
            headerParameters: headerParameters,
            queryItems: queryParameters
        )

        // execute REST request
        request.response(completionHandler: completionHandler)
    }

}
