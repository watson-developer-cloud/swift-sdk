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
        success: [SpeechRecognitionResult] -> Void)
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
        success: [SpeechRecognitionResult] -> Void)
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
     Perform speech recognition for microphone audio.
     
     If the user granted permission to use the microphone, then microphone audio will be streamed
     to the Speech to Text service. The microphone will automatically stop when the recognition
     request ends (by an end-of-speech event, for example). You can manually stop the microphone
     by invoking the `cancel()` or `finish()` methods of the returned `RecognitionRequest`.
     
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
    public func recognize(
        settings: RecognitionSettings,
        model: String? = nil,
        learningOptOut: Bool? = nil,
        compress: Bool = true,
        failure: (NSError -> Void)? = nil,
        success: [SpeechRecognitionResult] -> Void)
        -> MicrophoneRecognitionRequest
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
        
        return MicrophoneRecognitionRequest(session: session)
    }
}

/** A speech recognition request that streams microphone audio to the Speech to Text service. */
public class MicrophoneRecognitionRequest {

    /// The results of the recognition request.
    public var results: [SpeechRecognitionResult] { return session.results }
    
    /// The session associated with this recognition request.
    private let session: SpeechToTextSession
    
    /**
     Create a `MicrophoneRecognitionRequest` object.
     */
    private init(session: SpeechToTextSession) {
        self.session = session
    }
    
    /**
     Finish the recognition request by stopping the microphone, waiting for all in-flight
     microphone audio to be transcribed, then disconnecting from the Speech to Text service.
     */
    public func finish() {
        session.stopMicrophone()
        session.stopRequest()
        session.disconnect()
    }
}
