/**
 * Copyright IBM Corporation 2016
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
import Alamofire
import Freddy
import RestKit

/**
 The Watson Language Translator service provides domain-specific translation utilizing
 Statistical Machine Translation techniques that have been perfected in our research labs
 over the past few decades.
 */
public class LanguageTranslator {

    /// The base URL to use when contacting the service.
    public var serviceURL = "https://gateway.watsonplatform.net/language-translation/api"
    
    /// The default HTTP headers for all requests to the service.
    public var defaultHeaders = [String: String]()
    
    private let username: String
    private let password: String
    private let domain = "com.ibm.watson.developer-cloud.LanguageTranslatorV2"

    /**
     Create a `LanguageTranslator` object.
     
     - parameter username: The username used to authenticate with the service.
     - parameter password: The password used to authenticate with the service.
     */
    public init(username: String, password: String) {
        self.username = username
        self.password = password
    }

    /**
     If the given data represents an error returned by the Visual Recognition service, then return
     an NSError with information about the error that occured. Otherwise, return nil.
     
     - parameter data: Raw data returned from the service that may represent an error.
     */
    private func dataToError(data: Data) -> Error? {
        do {
            let json = try JSON(data: data)
            let code = try json.getInt(at: "error_code")
            let message = try json.getString(at: "error_message")
            let userInfo = [NSLocalizedFailureReasonErrorKey: message]
            return NSError(domain: domain, code: code, userInfo: userInfo)
        } catch {
            return nil
        }
    }

    // MARK: - Models

    /**
     List the available standard and custom models.
     
     - parameter source: Specify a source to filter models by source language.
     - parameter target: Specify a target to filter models by target language.
     - parameter defaultModelsOnly: Specify `true` to filter models by whether they are default.
     - parameter failure: A function executed if an error occurs.
     - parameter success: A function executed with the list of available standard and custom models.
     */
    public func getModels(
        source: String? = nil,
        target: String? = nil,
        defaultModelsOnly: Bool? = nil,
        failure: ((Error) -> Void)? = nil,
        success: @escaping ([TranslationModel]) -> Void)
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
        if let defaultModelsOnly = defaultModelsOnly {
            let queryParameter = URLQueryItem(name: "default", value: "\(defaultModelsOnly)")
            queryParameters.append(queryParameter)
        }

        // construct REST request
        let request = RestRequest(
            method: .get,
            url: serviceURL + "/v2/models",
            headerParameters: defaultHeaders,
            acceptType: "application/json",
            queryParameters: queryParameters
        )

        // execute REST request
        Alamofire.request(request)
            .authenticate(user: username, password: password)
            .responseArray(path: ["models"]) { (response: DataResponse<[TranslationModel]>) in
                switch response.result {
                case .success(let models): success(models)
                case .failure(let error): failure?(error)
                }
            }
    }

    /**
     Create a custom language translator model by uploading a TMX glossary file.
     
     Depending on the size of the file, training can range from minutes for a glossary to several
     hours for a large parallel corpus. Glossary files must be less than 10 MB. The cumulative file
     size of all uploaded glossary and corpus files is limited to 250 MB.
     
     - parameter baseModelID: Specifies the domain model that is used as the base for the training.
     - parameter name: The model name. Valid characters are letters, numbers, -, and _. No spaces.
     - parameter forcedGlossary: A TMX file with your customizations. Anything that is specified in
            this file completely overwrites the domain data translation. You can upload only one
            glossary with a file size less than 10 MB per call.
     - parameter failure: A function executed if an error occurs.
     - parameter success: A function executed with the modelID of the created model.
     */
    public func createModel(
        baseModelID: String,
        name: String? = nil,
        forcedGlossary: URL,
        failure: ((Error) -> Void)? = nil,
        success: @escaping (String) -> Void)
    {
        // construct query parameters
        var queryParameters = [URLQueryItem]()
        queryParameters.append(URLQueryItem(name: "base_model_id", value: baseModelID))
        if let name = name {
            let queryParameter = URLQueryItem(name: "name", value: name)
            queryParameters.append(queryParameter)
        }

        // construct REST request
        let request = RestRequest(
            method: .post,
            url: serviceURL + "/v2/models",
            headerParameters: defaultHeaders,
            acceptType: "application/json",
            queryParameters: queryParameters
        )

        // execute REST request
        Alamofire.upload(
            multipartFormData: { multipartFormData in
                multipartFormData.append(forcedGlossary, withName: "forced_glossary")
            },
            with: request,
            encodingCompletion: { encodingResult in
                switch encodingResult {
                case .success(let upload, _, _):
                    upload.authenticate(user: self.username, password: self.password)
                    upload.responseObject(path: ["model_id"]) { (response: DataResponse<String>) in
                        switch response.result {
                        case .success(let modelID): success(modelID)
                        case .failure(let error): failure?(error)
                        }
                    }
                case .failure:
                    let failureReason = "Forced glossary could not be encoded as form data."
                    let userInfo = [NSLocalizedFailureReasonErrorKey: failureReason]
                    let error = NSError(domain: self.domain, code: 0, userInfo: userInfo)
                    failure?(error)
                    return
                }
            }
        )
    }

    /**
     Delete a trained translation model.
     
     - parameter modelID: The translation model's identifier.
     - parameter failure: A function executed if an error occurs.
     - parameter success: A function executed after the given model has been deleted.
     */
    public func deleteModel(
        modelID: String,
        failure: ((Error) -> Void)? = nil,
        success: ((Void) -> Void)? = nil)
    {
        // construct REST request
        let request = RestRequest(
            method: .delete,
            url: serviceURL + "/v2/models/\(modelID)",
            headerParameters: defaultHeaders,
            acceptType: "application/json"
        )

        // execute REST request
        Alamofire.request(request)
            .authenticate(user: username, password: password)
            .responseData { response in
                switch response.result {
                case .success(let data):
                    switch self.dataToError(data: data) {
                    case .some(let error): failure?(error)
                    case .none: success?()
                    }
                case .failure(let error):
                    failure?(error)
                }
            }
    }

    /**
     Get information about the given translation model, including training status.
     
     - parameter modelID: The translation model's identifier.
     - parameter failure: A function executed if an error occurs.
     - parameter success: A function executed with the retrieved information about the model.
     */
    public func getModel(
        modelID: String,
        failure: ((Error) -> Void)? = nil,
        success: @escaping (MonitorTraining) -> Void)
    {
        // construct REST request
        let request = RestRequest(
            method: .get,
            url: serviceURL + "/v2/models/\(modelID)",
            headerParameters: defaultHeaders,
            acceptType: "application/json"
        )

        // execute REST request
        Alamofire.request(request)
            .authenticate(user: username, password: password)
            .responseObject() { (response: DataResponse<MonitorTraining>) in
                switch response.result {
                case .success(let monitorTraining): success(monitorTraining)
                case .failure(let error): failure?(error)
                }
            }
    }

    // MARK: - Translate

    /**
     Translate text from a source language to a target language.
     
     - parameter text: The text to translate.
     - parameter modelID: The unique modelID of the translation model that shall be used to
            translate the text. The modelID inherently specifies the source, target language, and
            domain.
     - parameter failure: A function executed if an error occurs.
     - parameter success: A function executed with the translation.
     */
    public func translate(
        text: String,
        modelID: String,
        failure: ((Error) -> Void)? = nil,
        success: @escaping (TranslateResponse) -> Void)
    {
        let translateRequest = TranslateRequest(text: [text], modelID: modelID)
        translate(translateRequest: translateRequest, failure: failure, success: success)
    }

    /**
     Translate text from a source language to a target language.
     
     - parameter text: The text to translate.
     - parameter modelID: The unique modelID of the translation model that shall be used to
            translate the text. The modelID inherently specifies the source, target language, and
            domain.
     - parameter failure: A function executed if an error occurs.
     - parameter success: A function executed with the translation.
     */
    public func translate(
        text: [String],
        modelID: String,
        failure: ((Error) -> Void)? = nil,
        success: @escaping (TranslateResponse) -> Void)
    {
        let translateRequest = TranslateRequest(text: text, modelID: modelID)
        translate(translateRequest: translateRequest, failure: failure, success: success)
    }
    
    /**
     Translate text from a source language to a target language.
     
     - parameter text: The text to translate.
     - parameter source:  The source language in 2 or 5 letter language code. Use 2 letter codes
            except when clarifying between multiple supported languages.
     - parameter target: The target language in 2 or 5 letter language code. Use 2 letter codes
            except when clarifying between multiple supported languages.
     - parameter failure: A function executed if an error occurs.
     - parameter success: A function executed with the translation.
     */
    public func translate(
        text: String,
        source: String,
        target: String,
        failure: ((Error) -> Void)? = nil,
        success: @escaping (TranslateResponse) -> Void)
    {
        let translateRequest = TranslateRequest(text: [text], source: source, target: target)
        translate(translateRequest: translateRequest, failure: failure, success: success)
    }

    /**
     Translate text from a source language to a target language.
     
     - parameter text: The text to translate.
     - parameter source:  The source language in 2 or 5 letter language code. Use 2 letter codes
            except when clarifying between multiple supported languages.
     - parameter target: The target language in 2 or 5 letter language code. Use 2 letter codes
            except when clarifying between multiple supported languages.
     - parameter failure: A function executed if an error occurs.
     - parameter success: A function executed with the translation.
     */
    public func translate(
        text: [String],
        source: String,
        target: String,
        failure: ((Error) -> Void)? = nil,
        success: @escaping (TranslateResponse) -> Void)
    {
        let translateRequest = TranslateRequest(text: text, source: source, target: target)
        translate(translateRequest: translateRequest, failure: failure, success: success)
    }

    /**
     Process a translation request.
 
     - parameter translateRequest: A `TranslateRequest` object representing the parameters of the
            request to the Language Translator service.
     - parameter failure: A function executed if an error occurs.
     - parameter success: A function executed with the response from the service.
     */
    private func translate(
        translateRequest: TranslateRequest,
        failure: ((Error) -> Void)? = nil,
        success: @escaping (TranslateResponse) -> Void)
    {
        // serialize translate request to JSON
        guard let body = try? translateRequest.toJSON().serialize() else {
            let failureReason = "Translation request could not be serialized to JSON."
            let userInfo = [NSLocalizedFailureReasonErrorKey: failureReason]
            let error = NSError(domain: domain, code: 0, userInfo: userInfo)
            failure?(error)
            return
        }

        // construct REST request
        let request = RestRequest(
            method: .post,
            url: serviceURL + "/v2/translate",
            headerParameters: defaultHeaders,
            acceptType: "application/json",
            contentType: "application/json",
            messageBody: body
        )

        // execute REST request
        Alamofire.request(request)
            .authenticate(user: username, password: password)
            .responseObject() { (response: DataResponse<TranslateResponse>) in
                switch response.result {
                case .success(let translateResponse): success(translateResponse)
                case .failure(let error): failure?(error)
                }
            }
    }

    // MARK: - Identify

    /**
     Get a list of all languages that can be identified.
     
     - parameter failure: A function executed if an error occurs.
     - parameter success: A function executed with the list of all languages that can be identified.
     */
    public func getIdentifiableLanguages(
        failure: ((Error) -> Void)? = nil,
        success: @escaping ([IdentifiableLanguage]) -> Void)
    {
        // construct REST request
        let request = RestRequest(
            method: .get,
            url: serviceURL + "/v2/identifiable_languages",
            headerParameters: defaultHeaders,
            contentType: "application/json"
        )

        // execute REST request
        Alamofire.request(request)
            .authenticate(user: username, password: password)
            .responseArray(path: ["languages"]) { (response: DataResponse<[IdentifiableLanguage]>) in
                switch response.result {
                case .success(let languages): success(languages)
                case .failure(let error): failure?(error)
                }
            }
    }

    /**
     Identify the language of the given text.
     
     - parameter text: The text whose language shall be identified.
     - parameter failure: A function executed if an error occurs.
     - parameter success: A function executed with all identified languages in the given text.
     */
    public func identify(
        text: String,
        failure: ((Error) -> Void)? = nil,
        success: @escaping ([IdentifiedLanguage]) -> Void)
    {
        // convert text to NSData with UTF-8 encoding
        guard let body = text.data(using: String.Encoding.utf8) else {
            let failureReason = "Text could not be encoded to NSData with NSUTF8StringEncoding."
            let userInfo = [NSLocalizedFailureReasonErrorKey: failureReason]
            let error = NSError(domain: domain, code: 0, userInfo: userInfo)
            failure?(error)
            return
        }

        // construct REST request
        let request = RestRequest(
            method: .post,
            url: serviceURL + "/v2/identify",
            headerParameters: defaultHeaders,
            acceptType: "application/json",
            contentType: "text/plain",
            messageBody: body
        )

        // execute REST request
        Alamofire.request(request)
            .authenticate(user: username, password: password)
            .responseArray(path: ["languages"]) { (response: DataResponse<[IdentifiedLanguage]>) in
                switch response.result {
                case .success(let languages): success(languages)
                case .failure(let error): failure?(error)
                }
            }
    }
}
