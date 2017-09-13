/**
 * Copyright IBM Corporation 2016-2017
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
import RestKit
import AVFoundation

/**
 The IBM Watson Speech to Text service enables you to add speech transcription capabilities to
 your application. It uses machine intelligence to combine information about grammar and language
 structure to generate an accurate transcription. Transcriptions are supported for various audio
 formats and languages.
 
 This class makes it easy to recognize audio with the Speech to Text service. Internally, many
 of the functions make use of the `SpeechToTextSession` class, but this class provides a simpler
 interface by minimizing customizability. If you find that you require more control of the session
 or microphone, consider using the `SpeechToTextSession` class instead.
 */
public class SpeechToText {

    /// The base URL to use when contacting the service.
    public var serviceURL = "https://stream.watsonplatform.net/speech-to-text/api"
    
    /// The URL that shall be used to obtain a token.
    public var tokenURL = "https://stream.watsonplatform.net/authorization/api/v1/token"
    
    /// The URL that shall be used to stream audio for transcription.
    public var websocketsURL = "wss://stream.watsonplatform.net/speech-to-text/api/v1/recognize"
    
    /// The default HTTP headers for all requests to the service.
    public var defaultHeaders = [String: String]()
    
    private let username: String
    private let password: String
    private let credentials: Credentials
    private var microphoneSession: SpeechToTextSession?
    private let audioSession = AVAudioSession.sharedInstance()
    private let domain = "com.ibm.watson.developer-cloud.SpeechToTextV1"

    /**
     Create a `SpeechToText` object.
     
     - parameter username: The username used to authenticate with the service.
     - parameter password: The password used to authenticate with the service.
     */
    public init(username: String, password: String) {
        self.username = username
        self.password = password
        self.credentials = Credentials.basicAuthentication(username: username, password: password)
    }
    
    /**
     If the response or data represents an error returned by the Speech to Text service,
     then return NSError with information about the error that occured. Otherwise, return nil.
     
     - parameter response: the URL response returned from the service.
     - parameter data: Raw data returned from the service that may represent an error.
     */
    private func responseToError(response: HTTPURLResponse?, data: Data?) -> NSError? {
        
        // First check http status code in response
        if let response = response {
            if response.statusCode >= 200 && response.statusCode < 300 {
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
            let json = try JSON(data: data)
            let code = response?.statusCode ?? 400
            let message = try json.getString(at: "error")
            var userInfo = [NSLocalizedFailureReasonErrorKey: message]
            let codeDescription = try? json.getString(at: "code_description")
            let description = try? json.getString(at: "description")
            if let recoverySuggestion = codeDescription ?? description {
                userInfo[NSLocalizedRecoverySuggestionErrorKey] = recoverySuggestion
            }
            return NSError(domain: domain, code: code, userInfo: userInfo)
        } catch {
            return nil
        }
    }
    
    /**
     Retrieve a list of models available for use with the service.
     
     - parameter failure: A function executed if an error occurs.
     - parameter success: A function executed with the list of models.
     */
    public func getModels(failure: ((Error) -> Void)? = nil, success: @escaping ([Model]) -> Void) {
        // construct REST request
        let request = RestRequest(
            method: "GET",
            url: serviceURL + "/v1/models",
            credentials: credentials,
            headerParameters: defaultHeaders,
            acceptType: "application/json"
        )
        
        // execute REST request
        request.responseArray(responseToError: responseToError, path: ["models"]) {
            (response: RestResponse<[Model]>) in
                switch response.result {
                case .success(let models): success(models)
                case .failure(let error): failure?(error)
                }
            }
    }
    
    /**
     Retrieve information about a particular model that is available for use with the service.
     
     - parameter withID: The alphanumeric ID of the model.
     - parameter failure: A function executed if an error occurs.
     - parameter success: A function executed with information about the model.
    */
    public func getModel(
        withID modelID: String,
        failure: ((Error) -> Void)? = nil,
        success: @escaping (Model) -> Void)
    {
        //construct REST request
        let request = RestRequest(
            method: "GET",
            url: serviceURL + "/v1/models/" + modelID,
            credentials: credentials,
            headerParameters: defaultHeaders,
            acceptType: "application/json"
        )
        
        // execute REST request
        request.responseObject(responseToError: responseToError) {
            (response: RestResponse<Model>) in
                switch response.result {
                case .success(let model): success(model)
                case .failure(let error): failure?(error)
                }
            }
    }

    /**
     Perform speech recognition for an audio file.
    
     - parameter audio: The audio file to transcribe.
     - parameter settings: The configuration to use for this recognition request.
     - parameter model: The language and sample rate of the audio. For supported models, visit
        https://www.ibm.com/watson/developercloud/doc/speech-to-text/input.shtml#models.
     - parameter customizationID: The GUID of a custom language model that is to be used with the
        request. The base language model of the specified custom language model must match the
        model specified with the `model` parameter. By default, no custom model is used.
     - parameter learningOptOut: If `true`, then this request will not be logged for training.
     - parameter failure: A function executed whenever an error occurs.
     - parameter success: A function executed with all transcription results whenever
        a final or interim transcription is received.
     */
    public func recognize(
        audio: URL,
        settings: RecognitionSettings,
        model: String? = nil,
        customizationID: String? = nil,
        learningOptOut: Bool? = nil,
        failure: ((Error) -> Void)? = nil,
        success: @escaping (SpeechRecognitionResults) -> Void)
    {
        do {
            let data = try Data(contentsOf: audio)
            recognize(
                audio: data,
                settings: settings,
                model: model,
                customizationID: customizationID,
                learningOptOut: learningOptOut,
                failure: failure,
                success: success
            )
        } catch {
            let failureReason = "Could not load audio data from \(audio)."
            let userInfo = [NSLocalizedFailureReasonErrorKey: failureReason]
            let error = NSError(domain: domain, code: 0, userInfo: userInfo)
            failure?(error)
            return
        }
    }

    /**
     Perform speech recognition for audio data.

     - parameter audio: The audio data to transcribe.
     - parameter settings: The configuration to use for this recognition request.
     - parameter model: The language and sample rate of the audio. For supported models, visit
        https://www.ibm.com/watson/developercloud/doc/speech-to-text/input.shtml#models.
     - parameter customizationID: The GUID of a custom language model that is to be used with the
        request. The base language model of the specified custom language model must match the
        model specified with the `model` parameter. By default, no custom model is used.
     - parameter learningOptOut: If `true`, then this request will not be logged for training.
     - parameter failure: A function executed whenever an error occurs.
     - parameter success: A function executed with all transcription results whenever
        a final or interim transcription is received.
     */
    public func recognize(
        audio: Data,
        settings: RecognitionSettings,
        model: String? = nil,
        customizationID: String? = nil,
        learningOptOut: Bool? = nil,
        failure: ((Error) -> Void)? = nil,
        success: @escaping (SpeechRecognitionResults) -> Void)
    {
        // create session
        let session = SpeechToTextSession(
            username: username,
            password: password,
            model: model,
            customizationID: customizationID,
            learningOptOut: learningOptOut
        )
        
        // set urls
        session.serviceURL = serviceURL
        session.tokenURL = tokenURL
        session.websocketsURL = websocketsURL
        
        // set headers
        session.defaultHeaders = defaultHeaders
        
        // set callbacks
        session.onResults = success
        session.onError = failure
        
        // execute recognition request
        session.connect()
        session.startRequest(settings: settings)
        session.recognize(audio: audio)
        session.stopRequest()
        session.disconnect()
    }

    /**
     Perform speech recognition for microphone audio. To stop the microphone, invoke
     `stopRecognizeMicrophone()`.
     
     Microphone audio is compressed to OggOpus format unless otherwise specified by the `compress`
     parameter. With compression enabled, the `settings` should specify a `contentType` of
     `AudioMediaType.oggOpus`. With compression disabled, the `settings` should specify a
     `contentType` of `AudioMediaType.l16(rate: 16000, channels: 1)`.
     
     This function may cause the system to automatically prompt the user for permission
     to access the microphone. Use `AVAudioSession.requestRecordPermission(_:)` if you
     would prefer to ask for the user's permission in advance.

     - parameter settings: The configuration for this transcription request.
     - parameter model: The language and sample rate of the audio. For supported models, visit
        https://www.ibm.com/watson/developercloud/doc/speech-to-text/input.shtml#models.
     - parameter customizationID: The GUID of a custom language model that is to be used with the
        request. The base language model of the specified custom language model must match the
        model specified with the `model` parameter. By default, no custom model is used.
     - parameter learningOptOut: If `true`, then this request will not be logged for training.
     - parameter compress: Should microphone audio be compressed to OggOpus format?
        (OggOpus compression reduces latency and bandwidth.)
     - parameter failure: A function executed whenever an error occurs.
     - parameter success: A function executed with all transcription results whenever
        a final or interim transcription is received.
     */
    public func recognizeMicrophone(
        settings: RecognitionSettings,
        model: String? = nil,
        customizationID: String? = nil,
        learningOptOut: Bool? = nil,
        compress: Bool = true,
        failure: ((Error) -> Void)? = nil,
        success: @escaping (SpeechRecognitionResults) -> Void)
    {
        // make sure the AVAudioSession shared instance is properly configured
        do {
            try audioSession.setCategory(AVAudioSessionCategoryPlayAndRecord, with: [.defaultToSpeaker, .mixWithOthers])
            try audioSession.setActive(true)
        } catch {
            let failureReason = "Failed to setup the AVAudioSession sharedInstance properly."
            let userInfo = [NSLocalizedFailureReasonErrorKey: failureReason]
            let error = NSError(domain: self.domain, code: 0, userInfo: userInfo)
            failure?(error)
            return
        }
        
        // validate settings
        var settings = settings
        settings.contentType = compress ? .oggOpus : .l16(rate: 16000, channels: 1)
        
        // create session
        let session = SpeechToTextSession(
            username: username,
            password: password,
            model: model,
            customizationID: customizationID,
            learningOptOut: learningOptOut
        )
        
        // set urls
        session.serviceURL = serviceURL
        session.tokenURL = tokenURL
        session.websocketsURL = websocketsURL
        
        // set headers
        session.defaultHeaders = defaultHeaders
        
        // set callbacks
        session.onResults = success
        session.onError = failure
        
        // start recognition request
        session.connect()
        session.startRequest(settings: settings)
        session.startMicrophone(compress: compress)
        
        // store session
        microphoneSession = session
    }
    
    /**
     Stop performing speech recognition for microphone audio.
 
     When invoked, this function will
        1. Stop recording audio from the microphone.
        2. Send a stop message to stop the current recognition request.
        3. Wait to receive all recognition results then disconnect from the service.
     */
    public func stopRecognizeMicrophone() {
        microphoneSession?.stopMicrophone()
        microphoneSession?.stopRequest()
        microphoneSession?.disconnect()
    }
    
    // MARK: - Custom Models
    
    /**
     List information about all custom language models owned by the calling user. Specify a language
     to see custom models for that language only.
     
     - parameter language: The language of the custom models that you want returned.
     - parameter failure: A function executed whenever an error occurs.
     - parameter success: A function executed with a list of custom models.
     */
    public func getCustomizations(
        withLanguage language: String? = nil,
        failure: ((Error) -> Void)? = nil,
        success: @escaping ([Customization]) -> Void)
    {
        // construct query parameters
        var queryParameters = [URLQueryItem]()
        if let language = language {
            queryParameters.append(URLQueryItem(name: "language", value: language))
        }
        
        // construct REST request
        let request = RestRequest(
            method: "GET",
            url: serviceURL + "/v1/customizations",
            credentials: credentials,
            headerParameters: defaultHeaders,
            acceptType: "application/json",
            queryItems: queryParameters
        )
        
        // execute REST request
        request.responseArray(responseToError: responseToError, path: ["customizations"]) {
            (response: RestResponse<[Customization]>) in
            switch response.result {
            case .success(let customizations): success(customizations)
            case .failure(let error): failure?(error)
            }
        }
    }
    
    /**
     Create a new custom language model for a specified base language model.
     
     - parameter name: The name of the new custom model.
     - parameter baseModelName: The name of the language model that will be customized by the new 
        model.
     - parameter description: The description of the new model.
     - parameter failure: A function executed whenever an error occurs.
     - parameter success: A function executed with a `CustomizationID` object.
     */
    public func createCustomization(
        withName name: String,
        withBaseModelName baseModelName: String,
        dialect: String? = nil,
        description: String? = nil,
        failure: ((Error) -> Void)? = nil,
        success: @escaping (CustomizationID) -> Void)
    {
        // construct body
        var jsonData = [String: Any]()
        jsonData["name"] = name
        jsonData["base_model_name"] = baseModelName
        if let dialect = dialect {
            jsonData["dialect"] = dialect
        }
        if let description = description {
            jsonData["description"] = description
        }
        guard let body = try? JSON(dictionary: jsonData).serialize() else {
            failure?(RestError.serializationError)
            return
        }
        
        // construct REST request
        let request = RestRequest(
            method: "POST",
            url: serviceURL + "/v1/customizations",
            credentials: credentials,
            headerParameters: defaultHeaders,
            acceptType: "application/json",
            contentType: "application/json",
            messageBody: body
        )
        
        // execute REST request
        request.responseObject(responseToError: responseToError) {
            (response: RestResponse<CustomizationID>) in
            switch response.result {
            case .success(let customization): success(customization)
            case .failure(let error): failure?(error)
            }
        }
    }
    
    /**
     Delete an existing custom language model with the given ID. The custom model can't be deleted
     if another request, such as adding a corpus to the model, is currently being processed.
     
     - parameter customizationID: The ID of the custom model to delete.
     - parameter failure: A function executed whenever an error occurs.
     - parameter success: A function executed whenever a success occurs.
     */
    public func deleteCustomization(
        withID customizationID: String,
        failure: ((Error) -> Void)? = nil,
        success: (() -> Void)? = nil)
    {
        // construct REST request
        let request = RestRequest(
            method: "DELETE",
            url: serviceURL + "/v1/customizations/\(customizationID)",
            credentials: credentials,
            headerParameters: defaultHeaders,
            acceptType: "application/json"
        )
        
        // execute REST request
        request.responseData { response in
            switch response.result {
            case .success(let data):
                switch self.responseToError(response: response.response, data: data) {
                case .some(let error): failure?(error)
                case .none: success?()
                }
            case .failure(let error):
                failure?(error)
            }
        }
    }
    
    /**
     Get information about a custom language model.
     
     - parameter customizationID: The ID of the custom language model to return information about.
     - parameter failure: A function executed whenever an error occurs.
     - parameter success: A function executed with information about the custom model.
     */
    public func getCustomization(
        withID customizationID: String,
        failure: ((Error) -> Void)? = nil,
        success: @escaping (Customization) -> Void)
    {
        // construct REST request
        let request = RestRequest(
            method: "GET",
            url: serviceURL + "/v1/customizations/\(customizationID)",
            credentials: credentials,
            headerParameters: defaultHeaders,
            acceptType: "application/json"
        )
        
        // execute REST request
        request.responseObject(responseToError: responseToError) {
            (response: RestResponse<Customization>) in
            switch response.result {
            case .success(let customization): success(customization)
            case .failure(let error): failure?(error)
            }
        }
    }
    
    /**
     Initiates the training of a custom language model with new corpora, words, or both. The service 
     cannot accept subsequent training requests, or requests to add new corpora or words, until the 
     existing request completes. 
     
     Training will fail if no new training data has been added, if pre-processing of new corpora 
     or words is incomplete, or if one or more words have errors that must be fixed.
     
     - parameter customizationID: The ID of the custom model to train.
     - parameter wordTypeToAdd: The type of words from the custom model's words resource on which 
        to train the model: `all` trains the model on all new words. `user` trains the model only 
        on new words that were added or modified by the user - the model is not trained on new 
        words extracted from corpora.
     - parameter failure: A function executed whenever an error occurs.
     - parameter success: A function executed when a success occurs.
     */
    public func trainCustomization(
        withID customizationID: String,
        wordTypeToAdd: WordTypeToAdd? = nil,
        failure: ((Error) -> Void)? = nil,
        success: (() -> Void)? = nil)
    {
        // construct query parameters
        var queryParameters = [URLQueryItem]()
        if let wordTypeToAdd = wordTypeToAdd {
            queryParameters.append(URLQueryItem(name: "word_type_to_add", value: "\(wordTypeToAdd.rawValue)"))
        }
        
        // construct REST request
        let request = RestRequest(
            method: "POST",
            url: serviceURL + "/v1/customizations/\(customizationID)/train",
            credentials: credentials,
            headerParameters: defaultHeaders,
            acceptType: "application/json",
            queryItems: queryParameters)
        
        // execute REST request
        request.responseData { response in
            switch response.result {
            case .success(let data):
                switch self.responseToError(response: response.response, data: data) {
                case .some(let error): failure?(error)
                case .none: success?()
                }
            case .failure(let error):
                failure?(error)
            }
        }
    }
    
    /**
     Resets a custom language model by removing all corpora and words from the model. Metadata such 
     as the name and language of the model are preserved.
     
     - parameter customizationID: The ID of the custom model to reset.
     - parameter failure: A function executed whenever an error occurs.
     - parameter success: A function executed when a success occurs.
     */
    public func resetCustomization(
        withID customizationID: String,
        failure: ((Error) -> Void)? = nil,
        success: (() -> Void)? = nil)
    {
        // construct REST request
        let request = RestRequest(
            method: "POST",
            url: serviceURL + "/v1/customizations/\(customizationID)/reset",
            credentials: credentials,
            headerParameters: defaultHeaders,
            acceptType: "application/json")
        
        // execute REST request
        request.responseData { response in
            switch response.result {
            case .success(let data):
                switch self.responseToError(response: response.response, data: data) {
                case .some(let error): failure?(error)
                case .none: success?()
                }
            case .failure(let error):
                failure?(error)
            }
        }
    }
    
    /**
     Upgrades a custom language model to the latest release level of the Speech to Text service.
     
     - parameter customizationID: The ID of the custom model to upgrade.
     - parameter failure: A function executed whenever an error occurs.
     - parameter success: A function executed when a success occurs.
     */
    public func upgradeCustomization(
        withID customizationID: String,
        failure: ((Error) -> Void)? = nil,
        success: (() -> Void)? = nil)
    {
        // construct REST request
        let request = RestRequest(
            method: "POST",
            url: serviceURL + "/v1/customizations/\(customizationID)/upgrade",
            credentials: credentials,
            headerParameters: defaultHeaders,
            acceptType: "application/json")
        
        // execute REST request
        request.responseData { response in
            switch response.result {
            case .success(let data):
                switch self.responseToError(response: response.response, data: data) {
                case .some(let error): failure?(error)
                case .none: success?()
                }
            case .failure(let error):
                failure?(error)
            }
        }
    }
    
    // MARK: - Custom Corpora
    
    /**
     Lists information about all corpora for a custom language model.
     
     - parameter customizationID: The ID of the custom language model whose corpora you want
        information about.
     - parameter failure: A function executed whenever an error occurs.
     - parameter success: A function executed with a list of corpora for this custom model.
     */
    public func getCorpora(
        customizationID: String,
        failure: ((Error) -> Void)? = nil,
        success: @escaping ([Corpus]) -> Void)
    {
        // construct REST request
        let request = RestRequest(
            method: "GET",
            url: serviceURL + "/v1/customizations/\(customizationID)/corpora",
            credentials: credentials,
            headerParameters: defaultHeaders,
            acceptType: "application/json"
        )
        
        // execute REST request
        request.responseArray(responseToError: responseToError, path: ["corpora"]) {
            (response: RestResponse<[Corpus]>) in
            switch response.result {
            case .success(let corpora): success(corpora)
            case .failure(let error): failure?(error)
            }
        }
    }
    
    /**
     Deletes a corpus from a custom language model. Note: removing a corpus doesn't affect the custom
     model until you train the model with the `train` method.
     
     - parameter name: The name of the corpus to delete.
     - parameter customizationID: The ID of the custom model the corpus belongs to.
     - parameter failure: A function executed whenever an error occurs.
     - parameter success: A function executed whenever a success occurs.
     */
    public func deleteCorpus(
        withName name: String,
        customizationID: String,
        failure: ((Error) -> Void)? = nil,
        success: (() -> Void)? = nil)
    {
        // construct REST request
        let request = RestRequest(
            method: "DELETE",
            url: serviceURL + "/v1/customizations/\(customizationID)/corpora/\(name)",
            credentials: credentials,
            headerParameters: defaultHeaders,
            acceptType: "application/json"
        )
        
        // execute REST request
        request.responseData { response in
            switch response.result {
            case .success(let data):
                switch self.responseToError(response: response.response, data: data) {
                case .some(let error): failure?(error)
                case .none: success?()
                }
            case .failure(let error):
                failure?(error)
            }
        }
    }
    
    /**
     Lists information about a specific corpus for a custom language model.
     
     - parameter name: The name of the corpus you want details about.
     - parameter customizationID: The ID of the custom language model that the corpus is for.
     - parameter failure: A function executed whenever an error occurs.
     - parameter success: A function executed with details of the corpus.
     */
    public func getCorpus(
        withName name: String,
        customizationID: String,
        failure: ((Error) -> Void)? = nil,
        success: @escaping (Corpus) -> Void)
    {
        // construct REST request
        let request = RestRequest(
            method: "GET",
            url: serviceURL + "/v1/customizations/\(customizationID)/corpora/\(name)",
            credentials: credentials,
            headerParameters: defaultHeaders,
            acceptType: "application/json"
        )
        
        // execute REST request
        request.responseObject(responseToError: responseToError) {
            (response: RestResponse<Corpus>) in
            switch response.result {
            case .success(let corpus): success(corpus)
            case .failure(let error): failure?(error)
            }
        }
    }
    
    /**
     Add a corpus text file to a custom language model.
     
     - parameter textFile: A plain text file that contains the training data for the corpus. For 
        more information about how to prepare a corpus file, visit this link:
        http://www.ibm.com/watson/developercloud/doc/speech-to-text/custom.shtml#prepareCorpus
     - parameter name: The name of the corpus to be added. This cannot be `user`, which is a 
        reserved word. If a corpus with the same name exists already, you must set `allowOverwrite` 
        to true or the request will fail.
     - parameter customizationID: The ID of the custom model to which this corpus should be added.
     - parameter allowOverwrite: If a corpus with the same name exists, this value must be set to 
        true or the request will fail. By default, this parameter is false. This parameter is 
        ignored if there is no other corpus with the same name.
     - parameter failure: A function executed whenever an error occurs.
     - parameter success: A function executed when a success occurs.
     */
    public func addCorpus(
        withName name: String,
        fromFile textFile: URL,
        customizationID: String,
        allowOverwrite: Bool? = nil,
        failure: ((Error) -> Void)? = nil,
        success: (() -> Void)? = nil)
    {
        // construct query parameters
        var queryParameters = [URLQueryItem]()
        if let allowOverwrite = allowOverwrite {
            queryParameters.append(URLQueryItem(name: "allow_overwrite", value: "\(allowOverwrite)"))
        }
        
        // construct body
        let multipartFormData = MultipartFormData()
        multipartFormData.append(textFile, withName: "body")
        guard let body = try? multipartFormData.toData() else {
            failure?(RestError.encodingError)
            return
        }

        // construct REST request
        let request = RestRequest(
            method: "POST",
            url: serviceURL + "/v1/customizations/\(customizationID)/corpora/\(name)",
            credentials: credentials,
            headerParameters: defaultHeaders,
            acceptType: "application/json",
            contentType: multipartFormData.contentType,
            queryItems: queryParameters,
            messageBody: body)
        
        // execute REST request
        request.responseData { response in
            switch response.result {
            case .success(let data):
                switch self.responseToError(response: response.response, data: data) {
                case .some(let error): failure?(error)
                case .none: success?()
                }
            case .failure(let error):
                failure?(error)
            }
        }
    }
    
    // MARK: - Custom Words
    
    /**
     List all custom words from a custom language model.
     
     - parameter customizationID: The ID of the custom model.
     - parameter wordType: The types of words to return. By default, all words are returned.
     - parameter sortOrder: The order in which to return the list of words. By default, words are 
        returned in sorted alphabetical order.
     - parameter sortDirection: The order the list of words should be sorted. By default, words are 
        sorted alphabetically in ascending order.
     - parameter failure: A function executed whenever an error occurs.
     - parameter success: A function executed with a list of words in the custom language model.
     */
    public func getWords(
        customizationID: String,
        wordType: WordTypesToList? = nil,
        sortOrder: WordSort? = nil,
        sortDirection: WordSortDirection? = nil,
        failure: ((Error) -> Void)? = nil,
        success: @escaping ([Word]) -> Void)
    {
        // construct query parameters
        var queryParameters = [URLQueryItem]()
        if let wordType = wordType {
            queryParameters.append(URLQueryItem(name: "word_type", value: wordType.rawValue))
        }
        if let sortOrder = sortOrder {
            if let sortDirection = sortDirection {
                queryParameters.append(URLQueryItem(name: "sort", value: "\(sortDirection.rawValue)\(sortOrder.rawValue)"))
            } else {
                queryParameters.append(URLQueryItem(name: "sort", value: sortOrder.rawValue))
            }
        }
        
        // construct REST request
        let request = RestRequest(
            method: "GET",
            url: serviceURL + "/v1/customizations/\(customizationID)/words",
            credentials: credentials,
            headerParameters: defaultHeaders,
            acceptType: "application/json",
            queryItems: queryParameters
        )
        
        // execute REST request
        request.responseArray(responseToError: responseToError, path: ["words"]) {
            (response: RestResponse<[Word]>) in
            switch response.result {
            case .success(let words): success(words)
            case .failure(let error): failure?(error)
            }
        }
    }
    
    /**
     Add one or more words to the custom language model, or replace the definition of an existing 
     word with the same name.
    
     - parameter customizationID: The ID of the custom language model to add words to.
     - parameter words: An array of `NewWords` objects that describes what words should be added.
     - parameter failure: A function executed whenever an error occurs.
     - parameter success: A function executed whenever a success occurs.
     */
    public func addWords(
        customizationID: String,
        words: [NewWord],
        failure: ((Error) -> Void)? = nil,
        success: (() -> Void)? = nil)
    {
        // construct body
        var jsonData = [String: Any]()
        jsonData["words"] = words.map { word in word.toJSONObject() }
        guard let body = try? JSON(dictionary: jsonData).serialize() else {
            failure?(RestError.serializationError)
            return
        }
        
        // construct REST request
        let request = RestRequest(
            method: "POST",
            url: serviceURL + "/v1/customizations/\(customizationID)/words",
            credentials: credentials,
            headerParameters: defaultHeaders,
            acceptType: "application/json",
            contentType: "application/json",
            messageBody: body
        )
        
        // execute REST request
        request.responseData { response in
            switch response.result {
            case .success(let data):
                switch self.responseToError(response: response.response, data: data) {
                case .some(let error): failure?(error)
                case .none: success?()
                }
            case .failure(let error):
                failure?(error)
            }
        }
    }
    
    /**
     Delete a custom word from the specified custom model. If the word also exists in the service's 
     base vocabulary, the service removes only the custom pronunciation for the word; the word 
     remains in the base vocabulary.
     
     Note: Removing a custom word does not affect the custom model until you train the model.
     
     - parameter name: The name of the word you would like to delete.
     - parameter customizationID: The ID of the custom model from which you would like to delete the
        word from.
     - parameter failure: A function executed whenever an error occurs.
     - parameter success: A function executed whenever a success occurs.
     */
    public func deleteWord(
        withName name: String,
        customizationID: String,
        failure: ((Error) -> Void)? = nil,
        success: (() -> Void)? = nil)
    {
        // construct REST request
        let request = RestRequest(
            method: "DELETE",
            url: serviceURL + "/v1/customizations/\(customizationID)/words/\(name)",
            credentials: credentials,
            headerParameters: defaultHeaders,
            acceptType: "application/json"
        )
        
        // execute REST request
        request.responseData { response in
            switch response.result {
            case .success(let data):
                switch self.responseToError(response: response.response, data: data) {
                case .some(let error): failure?(error)
                case .none: success?()
                }
            case .failure(let error):
                failure?(error)
            }
        }
    }
    
    /**
     Get details of a word from a specific custom language model.
     
     - parameter name: The name of the word.
     - parameter customizationID: The ID of the custom language model.
     - parameter failure: A function executed whenever an error occurs.
     - parameter success: A function executed with details of the word.
     */
    public func getWord(
        withName name: String,
        customizationID: String,
        failure: ((Error) -> Void)? = nil,
        success: @escaping (Word) -> Void)
    {
        // construct REST request
        let request = RestRequest(
            method: "GET",
            url: serviceURL + "/v1/customizations/\(customizationID)/words/\(name)",
            credentials: credentials,
            headerParameters: defaultHeaders,
            acceptType: "application/json"
        )
        
        // execute REST request
        request.responseObject(responseToError: responseToError) {
            (response: RestResponse<Word>) in
            switch response.result {
            case .success(let word): success(word)
            case .failure(let error): failure?(error)
            }
        }
    }
    
    /**
     Add a single custom word to the custom language model, or modify an existing word.
     
     - parameter customizationID: The ID of the custom language model to add the new word to.
     - parameter name: The word that should be added.
     - parameter word: An object describing information about the custom word.
     - parameter failure: A function executed whenever an error occurs.
     - parameter success: A function executed whenever a success occurs.
     */
    public func addWord(
        withName name: String,
        customizationID: String,
        word: NewWord? = NewWord(),
        failure: ((Error) -> Void)? = nil,
        success: (() -> Void)? = nil)
    {
        // construct body
        guard let body = try? word?.toJSON().serialize() else {
            failure?(RestError.serializationError)
            return
        }
        
        // construct REST request
        let request = RestRequest(
            method: "PUT",
            url: serviceURL + "/v1/customizations/\(customizationID)/words/\(name)",
            credentials: credentials,
            headerParameters: defaultHeaders,
            acceptType: "application/json",
            contentType: "application/json",
            messageBody: body
        )
        
        // execute REST request
        request.responseData { response in
            switch response.result {
            case .success(let data):
                switch self.responseToError(response: response.response, data: data) {
                case .some(let error): failure?(error)
                case .none: success?()
                }
            case .failure(let error):
                failure?(error)
            }
        }
    }
}
