/**
 * Copyright IBM Corporation 2015
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
import ObjectMapper

/// The IBM Watson Language Translation service translates text from one language
/// to another and identifies the language in which text is written.
public class LanguageTranslation: WatsonService {
    
    public init(username: String, password: String) {
        let authStrategy = BasicAuthenticationStrategy(tokenURL: Constants.tokenURL,
            serviceURL: Constants.serviceURL, username: username, password: password)
        super.init(authStrategy: authStrategy)
    }
    
    /**
     Retrieves the list of identifiable languages
     
     - parameter completionHandler: callback method that is invoked with the
                                        identifiable languages
     */
    public func getIdentifiableLanguages(
        completionHandler: ([IdentifiableLanguage]?, NSError?) -> ()) {
        
        // construct request
        let request = WatsonRequest(
            method: .GET,
            serviceURL: Constants.serviceURL,
            endpoint: Constants.identifiableLanguages,
            authStrategy: authStrategy,
            accept: .JSON)
        
        // execute request
        gateway.request(request, serviceError: LanguageTranslationError()) { data, error in
            let languages = Mapper<IdentifiableLanguage>().mapArray(data, keyPath: "languages")
            completionHandler(languages, error)
        }
    }
    
    /**
     Identify the language in which text is written
     
     - parameter text:              the text to identify
     - parameter completionHandler: the callback method to be invoked with an array of
                                        identified languages in descending order of
                                        confidence
     */
    public func identify(text: String,
        completionHandler: ([IdentifiedLanguage]?, NSError?) -> ()) {
            
        // construct request
        let request = WatsonRequest(
            method: .GET,
            serviceURL: Constants.serviceURL,
            endpoint: Constants.identify,
            authStrategy: authStrategy,
            accept: .JSON,
            urlParams: [NSURLQueryItem(name: "text", value: text)])
        
        // execute request
        gateway.request(request, serviceError: LanguageTranslationError()) { data, error in
            let languages = Mapper<IdentifiedLanguage>().mapArray(data, keyPath: "languages")
            completionHandler(languages, error)
        }
    }
    
    /**
     Translate text using source and target languages
     
     - parameter text:              The text to translate
     - parameter source:            The language that the original text is written in
     - parameter target:            The language that the text will be translated into
     - parameter completionHandler: The callback method that is invoked with the
                                        translated strings
     */
    public func translate(text: [String], source: String, target: String,
        completionHandler: ([String]?, NSError?) -> ()) {
        
        translate(TranslateRequest(text: text, source: source, target: target),
            completionHandler: completionHandler)
    }
    
    /**
     Translate text using a model specified by modelID
     
     - parameter text:              The text to translate
     - parameter modelID:           The ID of the model that should be used for
                                        translation parameters
     - parameter completionHandler: The callback method that is invoked with the
                                        translated strings
     */
    public func translate(text: [String], modelID: String,
        completionHandler: ([String]?, NSError?) -> ()) {
        
        translate(TranslateRequest(text: text, modelID: modelID),
            completionHandler: completionHandler)
    }
    
    /**
     Translate text given a `TranslateRequest`.
     - parameter translateRequest: The TranslateRequest object to be used in the body
                                        of the HTTP request.
     - parameter completionHandler: The callback method that is invoked with the
                                        translated strings.
     */
    private func translate(translateRequest: TranslateRequest,
        completionHandler: ([String]?, NSError?) -> ()) {
        
        // construct request
        let request = WatsonRequest(
            method: .POST,
            serviceURL: Constants.serviceURL,
            endpoint: Constants.translate,
            authStrategy: authStrategy,
            accept: .JSON,
            contentType: .JSON,
            messageBody: Mapper().toJSONData(translateRequest))
        
        // execute request
        gateway.request(request, serviceError: LanguageTranslationError()) { data, error in
            let translations = Mapper<TranslateResponse>().map(data)?.translationStrings
            completionHandler(translations, error)
        }
    }
    
    /**
     Lists available standard and custom models by source or target language
     
     - parameter source:       Filter models by source language.
     - parameter target:       Filter models by target language.
     - parameter defaultModel: Valid values are leaving it unset, 'true' and 'false'. When 'true', it filters models to return the default model or models. When 'false' it returns the non-default model or models. If not set, all models (default and non-default) return.
     - parameter callback:     The callback method to invoke after the response is received
     */
    public func getModels(source: String? = nil, target: String? = nil,
        defaultModel: Bool? = nil, completionHandler: ([TranslationModel]?, NSError?) -> ()) {

        // construct url query parameters
        var urlParams = [NSURLQueryItem]()
        if let source = source {
            urlParams.append(NSURLQueryItem(name: "source", value: "\(source)"))
        }
        if let target = target {
            urlParams.append(NSURLQueryItem(name: "target", value: "\(target)"))
        }
        if let defaultModel = defaultModel {
            urlParams.append(NSURLQueryItem(name: "default", value: "\(defaultModel)"))
        }
            
        // construct request
        let request = WatsonRequest(
            method: .GET,
            serviceURL: Constants.serviceURL,
            endpoint: Constants.models,
            authStrategy: authStrategy,
            accept: .JSON,
            urlParams: urlParams)
            
        // execute request
        gateway.request(request, serviceError: LanguageTranslationError()) { data, error in
            let models = Mapper<TranslationModel>().mapArray(data, keyPath: "models")
            completionHandler(models, error)
        }
    }
    
    /**
     Returns information, including training status, about a specified translation model.
     
     - parameter modelID:           The model identifier
     - parameter completionHandler: The callback method to invoke after the response is received
     */
    public func getModel(modelID: String,
        completionHandler: (TranslationModel?, NSError?) -> ()) {
        
        // construct request
        let request = WatsonRequest(
            method: .GET,
            serviceURL: Constants.serviceURL,
            endpoint: Constants.model(modelID),
            authStrategy: authStrategy,
            accept: .JSON)
        
        // execute request
        gateway.request(request, serviceError: LanguageTranslationError()) { data, error in
            let model = Mapper<TranslationModel>().map(data)
            completionHandler(model, error)
        }
    }
    
    /**
     Uploads a TMX glossary file on top of a domain to customize a translation model.
     
     - parameter baseModelID:        (Required). Specifies the domain model that is used as the base for the training.
     - parameter name:               The model name. Valid characters are letters, numbers, -, and _. No spaces.
     - parameter forcedGlossaryPath: (Required). A TMX file with your customizations. Anything specified in this file will completely overwrite the domain data translation.
     - parameter callback:           Returns the created model
     */
    public func createModel(baseModelID: String, name: String? = nil, fileKey: String, fileURL: NSURL, callback: (TranslationModel?, NSError?)->())
    {
        
        // TODO: requires WatsonGateway to support multi-part file upload
        
        var queryParams = Dictionary<String,String>()
        queryParams.updateValue(baseModelID, forKey: LanguageTranslationConstants.baseModelID)
        if let name = name {
            queryParams.updateValue(name, forKey: LanguageTranslationConstants.name)
        }
        
        var fileParams = Dictionary<String,NSURL>()
        fileParams.updateValue(fileURL, forKey: fileKey)
        
        let endpoint = getEndpoint("/v2/models")
        NetworkUtils.performBasicAuthFileUploadMultiPart(endpoint, fileURLs: fileParams, parameters: queryParams, apiKey: _apiKey, completionHandler: {response in
            callback(Mapper<TranslationModel>().map(response.data), response.error)
        })
    }
    
    /**
     Delete a translation model
     
     - parameter modelID:           The model identifier
     - parameter completionHandler: The callback method to invoke after the response is received, returns true if delete is successful
     */
    public func deleteModel(modelID: String, completionHandler: NSError? -> ()) {
        
        // construct request
        let request = WatsonRequest(
            method: .DELETE,
            serviceURL: Constants.serviceURL,
            endpoint: Constants.model(modelID),
            authStrategy: authStrategy)
        
        // execute request
        gateway.request(request, serviceError: LanguageTranslationError()) { data, error in
            completionHandler(error)
        }
    }
}