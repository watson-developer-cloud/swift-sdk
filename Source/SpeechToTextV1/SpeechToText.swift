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
 The IBM Watson Speech to Text service enables you to add speech transcription capabilities to
 your application. It uses machine intelligence to combine information about grammar and language
 structure to generate an accurate transcription. Transcriptions are supported for various audio
 formats and languages.
 */
public class SpeechToText {

    private let username: String
    private let password: String
    private let serviceURL: String
    private let tokenURL: String
    private let websocketsURL: String
    private var microphoneSession: SpeechToTextSession?
    private let userAgent = buildUserAgent("watson-apis-ios-sdk/0.6.0 SpeechToTextV1")
    private let domain = "com.ibm.watson.developer-cloud.SpeechToTextV1"

    /**
     Create a `SpeechToText` object.
     
     - parameter username: The username used to authenticate with the service.
     - parameter password: The password used to authenticate with the service.
     - parameter serviceURL: The base URL of the Speech to Text service.
     - parameter tokenURL: The URL that shall be used to obtain a token.
     - parameter websocketsURL: The URL that shall be used to stream audio for transcription.
     */
    public init(
        username: String,
        password: String,
        serviceURL: String = "https://stream.watsonplatform.net/speech-to-text/api",
        tokenURL: String = "https://stream.watsonplatform.net/authorization/api/v1/token",
        websocketsURL: String = "wss://stream.watsonplatform.net/speech-to-text/api/v1/recognize")
    {
        self.username = username
        self.password = password
        self.serviceURL = serviceURL
        self.tokenURL = tokenURL
        self.websocketsURL = websocketsURL
    }
    
    /**
     If the given data represents an error returned by the Speech to Text service, then return
     an NSError object with information about the error that occured. Otherwise, return nil.
     
     - parameter data: Raw data returned from the service that may represent an error.
     */
    private func dataToError(data: NSData) -> NSError? {
        do {
            let json = try JSON(data: data)
            let error = try json.string("error")
            let code = try json.int("code")
            let description = try json.string("code_description")
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
    public func getModels(failure: (NSError -> Void)? = nil, success: [Model] -> Void) {
        // construct REST request
        let request = RestRequest(
            method: .GET,
            url: serviceURL + "/v1/models",
            acceptType: "application/json",
            userAgent: userAgent
        )
        
        // execute REST request
        Alamofire.request(request)
            .authenticate(user: username, password: password)
            .responseArray(dataToError: dataToError, path: ["models"]) {
                (response: Response<[Model], NSError>) in
                switch response.result {
                case .Success(let models): success(models)
                case .Failure(let error): failure?(error)
                }
            }
    }
    
    /**
     Retrieve information about a particular model that is available for use with the service.
 
     - parameter failure: A function executed if an error occurs.
     - parameter success: A function executed with information about the model.
    */
    public func getModel(modelID: String, failure: (NSError -> Void)? = nil, success: Model -> Void) {
        //construct REST request
        let request = RestRequest(
            method: .GET,
            url: serviceURL + "/v1/models/" + modelID,
            acceptType: "application/json",
            userAgent: userAgent
        )
        
        // execute REST request
        Alamofire.request(request)
            .authenticate(user: username, password: password)
            .responseObject(dataToError: dataToError) {
                (response: Response<Model, NSError>) in
                switch response.result {
                case .Success(let model): success(model)
                case .Failure(let error): failure?(error)
                }
            }
    }

    /**
     Perform speech recognition for an audio file.
    
     - parameter audio: The audio file to transcribe.
     - parameter settings: The configuration to use for this recognition request.
     - parameter model: The language and sample rate of the audio. For supported models, visit
        https://www.ibm.com/watson/developercloud/doc/speech-to-text/input.shtml#models.
     - parameter learningOptOut: If `true`, then this request will not be logged for training.
     - parameter failure: A function executed whenever an error occurs.
     - parameter success: A function executed with all transcription results whenever
        a final or interim transcription is received.
     */
    public func recognize(
        audio: NSURL,
        settings: RecognitionSettings,
        model: String? = nil,
        learningOptOut: Bool? = nil,
        failure: (NSError -> Void)? = nil,
        success: SpeechRecognitionResults -> Void)
    {
        guard let data = NSData(contentsOfURL: audio) else {
            let failureReason = "Could not load audio data from \(audio)."
            let userInfo = [NSLocalizedFailureReasonErrorKey: failureReason]
            let error = NSError(domain: domain, code: 0, userInfo: userInfo)
            failure?(error)
            return
        }

        recognize(
            data,
            settings: settings,
            model: model,
            learningOptOut: learningOptOut,
            failure: failure,
            success: success
        )
    }

    /**
     Perform speech recognition for audio data.

     - parameter audio: The audio data to transcribe.
     - parameter settings: The configuration to use for this recognition request.
     - parameter model: The language and sample rate of the audio. For supported models, visit
        https://www.ibm.com/watson/developercloud/doc/speech-to-text/input.shtml#models.
     - parameter learningOptOut: If `true`, then this request will not be logged for training.
     - parameter failure: A function executed whenever an error occurs.
     - parameter success: A function executed with all transcription results whenever
        a final or interim transcription is received.
     */
    public func recognize(
        audio: NSData,
        settings: RecognitionSettings,
        model: String? = nil,
        learningOptOut: Bool? = nil,
        failure: (NSError -> Void)? = nil,
        success: SpeechRecognitionResults -> Void)
    {
        let session = SpeechToTextSession(
            username: username,
            password: password,
            model: model,
            learningOptOut: learningOptOut,
            serviceURL: serviceURL,
            tokenURL: tokenURL,
            websocketsURL: websocketsURL
        )
        
        session.onResults = success
        session.onError = failure
        
        session.connect()
        session.startRequest(settings)
        session.recognize(audio)
        session.stopRequest()
        session.disconnect()
    }

    /**
     Perform speech recognition for microphone audio. To stop the microphone, invoke
     `stopRecognizeMicrophone()`.
     
     If the user granted permission to use the microphone, then microphone audio will be streamed
     to the Speech to Text service. The microphone will automatically stop when the recognition
     request ends (by an end-of-speech event, for example). Alternatively, you can manually stop
     the microphone by invoking the `stopRecognizeMicrophone()` method.
     
     Microphone audio is compressed to Opus format unless otherwise specified by the `compress`
     parameter. With compression enabled, the `settings` should specify a `contentType` of
     `AudioMediaType.Opus`. With compression disabled, the `settings` should specify `contentType`
     of `AudioMediaType.L16(rate: 16000, channels: 1)`.

     - parameter settings: The configuration for this transcription request.
     - parameter model: The language and sample rate of the audio. For supported models, visit
        https://www.ibm.com/watson/developercloud/doc/speech-to-text/input.shtml#models.
     - parameter learningOptOut: If `true`, then this request will not be logged for training.
     - parameter compress: Should microphone audio be compressed to Opus format?
     - parameter failure: A function executed whenever an error occurs.
     - parameter success: A function executed with all transcription results whenever
        a final or interim transcription is received.
     */
    public func recognizeMicrophone(
        settings: RecognitionSettings,
        model: String? = nil,
        learningOptOut: Bool? = nil,
        compress: Bool = true,
        failure: (NSError -> Void)? = nil,
        success: SpeechRecognitionResults -> Void)
    {
        var settings = settings
        settings.contentType = compress ? .Opus : .L16(rate: 16000, channels: 1)
        
        let session = SpeechToTextSession(
            username: username,
            password: password,
            model: model,
            learningOptOut: learningOptOut,
            serviceURL: serviceURL,
            tokenURL: tokenURL,
            websocketsURL: websocketsURL
        )
        
        session.onResults = success
        session.onError = failure
        
        session.connect()
        session.startRequest(settings)
        session.startMicrophone(compress)
        
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
