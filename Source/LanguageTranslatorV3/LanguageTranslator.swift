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
 IBM Watson&trade; Language Translator translates text from one language to another. The service offers multiple IBM
 provided translation models that you can customize based on your unique terminology and language. Use Language
 Translator to take news from across the globe and present it in your language, communicate with your customers in their
 own language, and more.
 */
public class LanguageTranslator {

    /// The base URL to use when contacting the service.
    public var serviceURL = "https://gateway.watsonplatform.net/language-translator/api"

    /// The default HTTP headers for all requests to the service.
    public var defaultHeaders = [String: String]()

    var session = URLSession(configuration: URLSessionConfiguration.default)
    var authMethod: AuthenticationMethod
    let version: String

    /**
     Create a `LanguageTranslator` object.

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
     Create a `LanguageTranslator` object.

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
     Create a `LanguageTranslator` object.

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
     Translate.

     Translates the input text from the source language to the target language.

     - parameter text: Input text in UTF-8 encoding. Multiple entries will result in multiple translations in the
       response.
     - parameter modelID: A globally unique string that identifies the underlying model that is used for translation.
     - parameter source: Translation source language code.
     - parameter target: Translation target language code.
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
        guard let body = try? JSONEncoder().encode(translateRequest) else {
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

        // construct query parameters
        var queryParameters = [URLQueryItem]()
        queryParameters.append(URLQueryItem(name: "version", value: version))

        // construct REST request
        let request = RestRequest(
            session: session,
            authMethod: authMethod,
            errorResponseDecoder: errorResponseDecoder,
            method: "POST",
            url: serviceURL + "/v3/translate",
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
        headerParameters["Accept"] = "application/json"

        // construct query parameters
        var queryParameters = [URLQueryItem]()
        queryParameters.append(URLQueryItem(name: "version", value: version))

        // construct REST request
        let request = RestRequest(
            session: session,
            authMethod: authMethod,
            errorResponseDecoder: errorResponseDecoder,
            method: "GET",
            url: serviceURL + "/v3/identifiable_languages",
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
        headerParameters["Accept"] = "application/json"
        headerParameters["Content-Type"] = "text/plain"

        // construct query parameters
        var queryParameters = [URLQueryItem]()
        queryParameters.append(URLQueryItem(name: "version", value: version))

        // construct REST request
        let request = RestRequest(
            session: session,
            authMethod: authMethod,
            errorResponseDecoder: errorResponseDecoder,
            method: "POST",
            url: serviceURL + "/v3/identify",
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
     - parameter defaultModels: If the default parameter isn't specified, the service will return all models (default
       and non-default) for each language pair. To return only default models, set this to `true`. To return only
       non-default models, set this to `false`. There is exactly one default model per language pair, the IBM provided
       base model.
     - parameter headers: A dictionary of request headers to be sent with this request.
     - parameter completionHandler: A function executed when the request completes with a successful result or error
     */
    public func listModels(
        source: String? = nil,
        target: String? = nil,
        defaultModels: Bool? = nil,
        headers: [String: String]? = nil,
        completionHandler: @escaping (WatsonResponse<TranslationModels>?, WatsonError?) -> Void)
    {
        // construct header parameters
        var headerParameters = defaultHeaders
        if let headers = headers {
            headerParameters.merge(headers) { (_, new) in new }
        }
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
        if let defaultModels = defaultModels {
            let queryParameter = URLQueryItem(name: "default", value: "\(defaultModels)")
            queryParameters.append(queryParameter)
        }

        // construct REST request
        let request = RestRequest(
            session: session,
            authMethod: authMethod,
            errorResponseDecoder: errorResponseDecoder,
            method: "GET",
            url: serviceURL + "/v3/models",
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
     You can have a <b>maxium of 10 custom models per language pair</b>.

     - parameter baseModelID: The model ID of the model to use as the base for customization. To see available models,
       use the `List models` method. Usually all IBM provided models are customizable. In addition, all your models that
       have been created via parallel corpus customization, can be further customized with a forced glossary.
     - parameter name: An optional model name that you can use to identify the model. Valid characters are letters,
       numbers, dashes, underscores, spaces and apostrophes. The maximum length is 32 characters.
     - parameter forcedGlossary: A TMX file with your customizations. The customizations in the file completely
       overwrite the domain translaton data, including high frequency or high confidence phrase translations. You can
       upload only one glossary with a file size less than 10 MB per call. A forced glossary should contain single words
       or short phrases.
     - parameter parallelCorpus: A TMX file with parallel sentences for source and target language. You can upload
       multiple parallel_corpus files in one request. All uploaded parallel_corpus files combined, your parallel corpus
       must contain at least 5,000 parallel sentences to train successfully.
     - parameter headers: A dictionary of request headers to be sent with this request.
     - parameter completionHandler: A function executed when the request completes with a successful result or error
     */
    public func createModel(
        baseModelID: String,
        name: String? = nil,
        forcedGlossary: URL? = nil,
        parallelCorpus: URL? = nil,
        headers: [String: String]? = nil,
        completionHandler: @escaping (WatsonResponse<TranslationModel>?, WatsonError?) -> Void)
    {
        // construct body
        let multipartFormData = MultipartFormData()
        if let forcedGlossary = forcedGlossary {
            do {
                try multipartFormData.append(file: forcedGlossary, withName: "forced_glossary")
            } catch {
                completionHandler(nil, WatsonError.serialization(values: "file \(forcedGlossary.path)"))
                return
            }
        }
        if let parallelCorpus = parallelCorpus {
            do {
                try multipartFormData.append(file: parallelCorpus, withName: "parallel_corpus")
            } catch {
                completionHandler(nil, WatsonError.serialization(values: "file \(parallelCorpus.path)"))
                return
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
        let request = RestRequest(
            session: session,
            authMethod: authMethod,
            errorResponseDecoder: errorResponseDecoder,
            method: "POST",
            url: serviceURL + "/v3/models",
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
        let request = RestRequest(
            session: session,
            authMethod: authMethod,
            errorResponseDecoder: errorResponseDecoder,
            method: "DELETE",
            url: serviceURL + encodedPath,
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
        let request = RestRequest(
            session: session,
            authMethod: authMethod,
            errorResponseDecoder: errorResponseDecoder,
            method: "GET",
            url: serviceURL + encodedPath,
            headerParameters: headerParameters,
            queryItems: queryParameters
        )

        // execute REST request
        request.responseObject(completionHandler: completionHandler)
    }

}
