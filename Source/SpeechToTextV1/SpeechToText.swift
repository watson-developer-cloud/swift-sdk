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
import RestKit

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
     If the given data represents an error returned by the Speech to Text service, then return
     an NSError object with information about the error that occured. Otherwise, return nil.
     
     - parameter data: Raw data returned from the service that may represent an error.
     */
    private func dataToError(data: Data) -> NSError? {
        do {
            let json = try JSON(data: data)
            let error = try json.getString(at: "error")
            let code = try json.getInt(at: "code")
            let description = try json.getString(at: "code_description")
            let userInfo = [
                NSLocalizedFailureReasonErrorKey: error,
                NSLocalizedRecoverySuggestionErrorKey: description
            ]
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
        request.responseArray(dataToError: dataToError, path: ["models"]) {
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
        request.responseObject(dataToError: dataToError) {
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
     
     Knowing when to stop the microphone depends upon the recognition request's continuous setting:
     
     - If `false`, then the service ends the recognition request at the first end-of-speech
     incident (denoted by a half-second of non-speech or when the stream terminates). This
     will coincide with a `final` transcription result. So the `success` callback should
     be configured to stop the microphone when a final transcription result is received.
     
     - If `true`, then you will typically stop the microphone based on user-feedback. For example,
     your application may have a button to start/stop the request, or you may stream the
     microphone for the duration of a long press on a UI element.
     
     Microphone audio is compressed to Opus format unless otherwise specified by the `compress`
     parameter. With compression enabled, the `settings` should specify a `contentType` of
     `AudioMediaType.Opus`. With compression disabled, the `settings` should specify `contentType`
     of `AudioMediaType.L16(rate: 16000, channels: 1)`.
     
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
     - parameter compress: Should microphone audio be compressed to Opus format?
        (Opus compression reduces latency and bandwidth.)
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
        // validate settings
        var settings = settings
        settings.contentType = compress ? .opus : .l16(rate: 16000, channels: 1)
        
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
}
