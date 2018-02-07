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
   Language Translator translates text from one language to another. The service offers multiple
  domain-specific models that you can customize based on your unique terminology and language. Use
  Language Translator to take news from across the globe and present it in your language,
  communicate with your customers in their own language, and more.
 */
public class LanguageTranslator {

    /// The base URL to use when contacting the service.
    public var serviceURL = "https://gateway.watsonplatform.net/language-translator/api"

    /// The default HTTP headers for all requests to the service.
    public var defaultHeaders = [String: String]()

    private let credentials: Credentials
    private let domain = "com.ibm.watson.developer-cloud.LanguageTranslatorV2"

    /**
     Create a `LanguageTranslator` object.

     - parameter username: The username used to authenticate with the service.
     - parameter password: The password used to authenticate with the service.
     */
    public init(username: String, password: String) {
        self.credentials = .basicAuthentication(username: username, password: password)
    }

    /**
     If the response or data represents an error returned by the Language Translator service,
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
            let message = try json.getString(at: "error_message")
            let userInfo = [NSLocalizedDescriptionKey: message]
            return NSError(domain: domain, code: code, userInfo: userInfo)
        } catch {
            return nil
        }
    }

    /**
     Translates the input text from the source language to the target language.

     - parameter request: The translate request containing the text, with optional source, target, and model_id.
     - parameter failure: A function executed if an error occurs.
     - parameter success: A function executed with the successful result.
    */
    public func translate(
        request: TranslateRequest,
        failure: ((Error) -> Void)? = nil,
        success: @escaping (TranslationResult) -> Void)
    {
        // construct body
        guard let body = try? JSONEncoder().encode(request) else {
            failure?(RestError.serializationError)
            return
        }

        // construct REST request
        let request = RestRequest(
            method: "POST",
            url: serviceURL + "/v2/translate",
            credentials: credentials,
            headerParameters: defaultHeaders,
            acceptType: "application/json",
            contentType: "application/json",
            queryItems: nil,
            messageBody: body
        )

        // execute REST request
        request.responseObject(responseToError: responseToError) {
            (response: RestResponse<TranslationResult>) in
            switch response.result {
            case .success(let retval): success(retval)
            case .failure(let error): failure?(error)
            }
        }
    }

    /**
     Identifies the language of the input text.

     - parameter text: Input text in UTF-8 format.
     - parameter failure: A function executed if an error occurs.
     - parameter success: A function executed with the successful result.
    */
    public func identify(
        text: String,
        failure: ((Error) -> Void)? = nil,
        success: @escaping (IdentifiedLanguages) -> Void)
    {
        // construct body
        // convert body parameter to NSData with UTF-8 encoding
        guard let body = text.data(using: String.Encoding.utf8) else {
            let message = "text could not be encoded to NSData with NSUTF8StringEncoding."
            let userInfo = [NSLocalizedDescriptionKey: message]
            let error = NSError(domain: domain, code: 0, userInfo: userInfo)
            failure?(error)
            return
        }

        // construct REST request
        let request = RestRequest(
            method: "POST",
            url: serviceURL + "/v2/identify",
            credentials: credentials,
            headerParameters: defaultHeaders,
            acceptType: "application/json",
            contentType: "text/plain",
            queryItems: nil,
            messageBody: body
        )

        // execute REST request
        request.responseObject(responseToError: responseToError) {
            (response: RestResponse<IdentifiedLanguages>) in
            switch response.result {
            case .success(let retval): success(retval)
            case .failure(let error): failure?(error)
            }
        }
    }

    /**
     Lists all languages that can be identified by the API.

     Lists all languages that the service can identify. Returns the two-letter code (for example, `en` for English or `es` for Spanish) and name of each language.

     - parameter failure: A function executed if an error occurs.
     - parameter success: A function executed with the successful result.
    */
    public func listIdentifiableLanguages(
        failure: ((Error) -> Void)? = nil,
        success: @escaping (IdentifiableLanguages) -> Void)
    {
        // construct REST request
        let request = RestRequest(
            method: "GET",
            url: serviceURL + "/v2/identifiable_languages",
            credentials: credentials,
            headerParameters: defaultHeaders,
            acceptType: "application/json",
            contentType: nil,
            queryItems: nil,
            messageBody: nil
        )

        // execute REST request
        request.responseObject(responseToError: responseToError) {
            (response: RestResponse<IdentifiableLanguages>) in
            switch response.result {
            case .success(let retval): success(retval)
            case .failure(let error): failure?(error)
            }
        }
    }

    /**
     Uploads a TMX glossary file on top of a domain to customize a translation model.

     Depending on the size of the file, training can range from minutes for a glossary to several hours for a large parallel corpus. Glossary files must be less than 10 MB. The cumulative file size of all uploaded glossary and corpus files is limited to 250 MB.

     - parameter baseModelID: Specifies the domain model that is used as the base for the training. To see current supported domain models, use the GET /v2/models parameter.
     - parameter name: The model name. Valid characters are letters, numbers, -, and _. No spaces.
     - parameter forcedGlossary: A TMX file with your customizations. The customizations in the file completely overwrite the domain data translation, including high frequency or high confidence phrase translations. You can upload only one glossary with a file size less than 10 MB per call.
     - parameter parallelCorpus: A TMX file that contains entries that are treated as a parallel corpus instead of a glossary.
     - parameter monolingualCorpus: A UTF-8 encoded plain text file that is used to customize the target language model.
     - parameter failure: A function executed if an error occurs.
     - parameter success: A function executed with the successful result.
    */
    public func createModel(
        baseModelID: String,
        name: String? = nil,
        forcedGlossary: URL? = nil,
        parallelCorpus: URL? = nil,
        monolingualCorpus: URL? = nil,
        failure: ((Error) -> Void)? = nil,
        success: @escaping (TranslationModel) -> Void)
    {
        // construct body
        let multipartFormData = MultipartFormData()
        if let forcedGlossary = forcedGlossary {
            multipartFormData.append(forcedGlossary, withName: "forced_glossary")
        }
        if let parallelCorpus = parallelCorpus {
            multipartFormData.append(parallelCorpus, withName: "parallel_corpus")
        }
        if let monolingualCorpus = monolingualCorpus {
            multipartFormData.append(monolingualCorpus, withName: "monolingual_corpus")
        }
        guard let body = try? multipartFormData.toData() else {
            failure?(RestError.encodingError)
            return
        }

        // construct query parameters
        var queryParameters = [URLQueryItem]()
        queryParameters.append(URLQueryItem(name: "base_model_id", value: baseModelID))
        if let name = name {
            let queryParameter = URLQueryItem(name: "name", value: name)
            queryParameters.append(queryParameter)
        }

        // construct REST request
        let request = RestRequest(
            method: "POST",
            url: serviceURL + "/v2/models",
            credentials: credentials,
            headerParameters: defaultHeaders,
            acceptType: "application/json",
            contentType: multipartFormData.contentType,
            queryItems: queryParameters,
            messageBody: body
        )

        // execute REST request
        request.responseObject(responseToError: responseToError) {
            (response: RestResponse<TranslationModel>) in
            switch response.result {
            case .success(let retval): success(retval)
            case .failure(let error): failure?(error)
            }
        }
    }

    /**
     Deletes a custom translation model.

     - parameter modelID: The model identifier.
     - parameter failure: A function executed if an error occurs.
     - parameter success: A function executed with the successful result.
    */
    public func deleteModel(
        modelID: String,
        failure: ((Error) -> Void)? = nil,
        success: @escaping (DeleteModelResult) -> Void)
    {
        // construct REST request
        let path = "/v2/models/\(modelID)"
        guard let encodedPath = path.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else {
            failure?(RestError.encodingError)
            return
        }
        let request = RestRequest(
            method: "DELETE",
            url: serviceURL + encodedPath,
            credentials: credentials,
            headerParameters: defaultHeaders,
            acceptType: "application/json",
            contentType: nil,
            queryItems: nil,
            messageBody: nil
        )

        // execute REST request
        request.responseObject(responseToError: responseToError) {
            (response: RestResponse<DeleteModelResult>) in
            switch response.result {
            case .success(let retval): success(retval)
            case .failure(let error): failure?(error)
            }
        }
    }

    /**
     Get information about the given translation model, including training status.

     - parameter modelID: Model ID to use.
     - parameter failure: A function executed if an error occurs.
     - parameter success: A function executed with the successful result.
    */
    public func getModel(
        modelID: String,
        failure: ((Error) -> Void)? = nil,
        success: @escaping (TranslationModel) -> Void)
    {
        // construct REST request
        let path = "/v2/models/\(modelID)"
        guard let encodedPath = path.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else {
            failure?(RestError.encodingError)
            return
        }
        let request = RestRequest(
            method: "GET",
            url: serviceURL + encodedPath,
            credentials: credentials,
            headerParameters: defaultHeaders,
            acceptType: "application/json",
            contentType: nil,
            queryItems: nil,
            messageBody: nil
        )

        // execute REST request
        request.responseObject(responseToError: responseToError) {
            (response: RestResponse<TranslationModel>) in
            switch response.result {
            case .success(let retval): success(retval)
            case .failure(let error): failure?(error)
            }
        }
    }

    /**
     Lists available standard and custom models by source or target language.

     - parameter source: Filter models by source language.
     - parameter target: Filter models by target language.
     - parameter defaultModels: Valid values are leaving it unset, `true`, and `false`. When `true`, it filters models to return the defaultModels model or models. When `false`, it returns the non-defaultModels model or models. If not set, it returns all models, defaultModels and non-defaultModels.
     - parameter failure: A function executed if an error occurs.
     - parameter success: A function executed with the successful result.
    */
    public func listModels(
        source: String? = nil,
        target: String? = nil,
        defaultModels: Bool? = nil,
        failure: ((Error) -> Void)? = nil,
        success: @escaping (TranslationModels) -> Void)
    {
        // construct query parameters
        var queryParameters = [URLQueryItem]()
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
            method: "GET",
            url: serviceURL + "/v2/models",
            credentials: credentials,
            headerParameters: defaultHeaders,
            acceptType: "application/json",
            contentType: nil,
            queryItems: queryParameters,
            messageBody: nil
        )

        // execute REST request
        request.responseObject(responseToError: responseToError) {
            (response: RestResponse<TranslationModels>) in
            switch response.result {
            case .success(let retval): success(retval)
            case .failure(let error): failure?(error)
            }
        }
    }

}
