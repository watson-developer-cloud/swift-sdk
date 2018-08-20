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

#if os(Linux)
#else

import Foundation
import AVFoundation
import RestKit

private var microphoneSession: SpeechToTextSession?

extension SpeechToText {

    /**
     Perform speech recognition for an audio file.

     - parameter audio: The audio file to transcribe.
     - parameter settings: The configuration to use for this recognition request.
     - parameter model: The language and sample rate of the audio. For supported models, visit
       https://console.bluemix.net/docs/services/speech-to-text/input.html#models.
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
            recognizeUsingWebSocket(
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
            let userInfo = [NSLocalizedDescriptionKey: failureReason]
            let error = NSError(domain: domain, code: 0, userInfo: userInfo)
            failure?(error)
            return
        }
    }

    /**
     Perform speech recognition for audio data using WebSockets.

     - parameter audio: The audio data to transcribe.
     - parameter settings: The configuration to use for this recognition request.
     - parameter model: The language and sample rate of the audio. For supported models, visit
       https://console.bluemix.net/docs/services/speech-to-text/input.html#models.
     - parameter customizationID: The GUID of a custom language model that is to be used with the
       request. The base language model of the specified custom language model must match the
       model specified with the `model` parameter. By default, no custom model is used.
     - parameter acousticCustomizationID: The customization ID (GUID) of a custom acoustic model
       that is to be used with the recognition request. The base model of the specified custom
       acoustic model must match the model specified with the `model` parameter. By default, no
       custom acoustic model is used.
     - parameter learningOptOut: If `true`, then this request will not be logged for training.
     - parameter headers: A dictionary of request headers to be sent with this request.
     - parameter failure: A function executed whenever an error occurs.
     - parameter success: A function executed with all transcription results whenever
       a final or interim transcription is received.
     */
    public func recognizeUsingWebSocket(
        audio: Data,
        settings: RecognitionSettings,
        model: String? = nil,
        customizationID: String? = nil,
        acousticCustomizationID: String? = nil,
        learningOptOut: Bool? = nil,
        headers: [String: String]? = nil,
        failure: ((Error) -> Void)? = nil,
        success: @escaping (SpeechRecognitionResults) -> Void)
    {
        // create SpeechToTextSession
        let session = SpeechToTextSession(
            authMethod: authMethod,
            model: model,
            customizationID: customizationID,
            acousticCustomizationID: acousticCustomizationID,
            learningOptOut: learningOptOut
        )

        // set urls
        session.serviceURL = serviceURL
        session.tokenURL = tokenURL
        session.websocketsURL = websocketsURL

        // set headers
        session.defaultHeaders = defaultHeaders
        if let headers = headers {
            session.defaultHeaders.merge(headers) { (_, new) in new }
        }

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

     Microphone audio is compressed to Opus format unless otherwise specified by the `compress`
     parameter. With compression enabled, the `settings` should specify a `contentType` of
     "audio/ogg;codecs=opus". With compression disabled, the `settings` should specify a
     `contentType` of "audio/l16;rate=16000;channels=1".

     This function may cause the system to automatically prompt the user for permission
     to access the microphone. Use `AVAudioSession.requestRecordPermission(_:)` if you
     would prefer to ask for the user's permission in advance.

     - parameter settings: The configuration for this transcription request.
     - parameter model: The language and sample rate of the audio. For supported models, visit
       https://console.bluemix.net/docs/services/speech-to-text/input.html#models.
     - parameter customizationID: The GUID of a custom language model that is to be used with the
       request. The base language model of the specified custom language model must match the
       model specified with the `model` parameter. By default, no custom model is used.
     - parameter acousticCustomizationID: The customization ID (GUID) of a custom acoustic model
       that is to be used with the recognition request. The base model of the specified custom
       acoustic model must match the model specified with the `model` parameter. By default, no
       custom acoustic model is used.
     - parameter learningOptOut: If `true`, then this request will not be logged for training.
     - parameter compress: Should microphone audio be compressed to Opus format?
       (Opus compression reduces latency and bandwidth.)
     - parameter headers: A dictionary of request headers to be sent with this request.
     - parameter failure: A function executed whenever an error occurs.
     - parameter success: A function executed with all transcription results whenever
       a final or interim transcription is received.
     */
    public func recognizeMicrophone(
        settings: RecognitionSettings,
        model: String? = nil,
        customizationID: String? = nil,
        acousticCustomizationID: String? = nil,
        learningOptOut: Bool? = nil,
        compress: Bool = true,
        headers: [String: String]? = nil,
        failure: ((Error) -> Void)? = nil,
        success: @escaping (SpeechRecognitionResults) -> Void)
    {
        // make sure the AVAudioSession shared instance is properly configured
        do {
            let audioSession = AVAudioSession.sharedInstance()
            try audioSession.setCategory(AVAudioSessionCategoryPlayAndRecord, with: [.defaultToSpeaker, .mixWithOthers])
            try audioSession.setActive(true)
        } catch {
            let failureReason = "Failed to setup the AVAudioSession sharedInstance properly."
            let userInfo = [NSLocalizedDescriptionKey: failureReason]
            let error = NSError(domain: self.domain, code: 0, userInfo: userInfo)
            failure?(error)
            return
        }

        // validate settings
        var settings = settings
        settings.contentType = compress ? "audio/ogg;codecs=opus" : "audio/l16;rate=16000;channels=1"

        // extract authMethod
        guard let basicAuth = authMethod as? BasicAuthentication else {
            let failureReason = "Invalid authenticaion method format."
            let userInfo = [NSLocalizedDescriptionKey: failureReason]
            let error = NSError(domain: domain, code: 0, userInfo: userInfo)
            failure?(error)
            return
        }

        // create session
        let session = SpeechToTextSession(
            username: basicAuth.username,
            password: basicAuth.password,
            model: model,
            customizationID: customizationID,
            acousticCustomizationID: acousticCustomizationID,
            learningOptOut: learningOptOut
        )

        // set urls
        session.serviceURL = serviceURL
        session.tokenURL = tokenURL
        session.websocketsURL = websocketsURL

        // set headers
        session.defaultHeaders = defaultHeaders
        if let headers = headers {
            session.defaultHeaders.merge(headers) { (_, new) in new }
        }

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

extension SpeechToText {

    @available(*, deprecated, message: "The recognize method has been deprecated in favor of recognizeUsingWebSocket method.  This method will be removed in a future release.")
    public func recognize(
        audio: Data,
        settings: RecognitionSettings,
        model: String? = nil,
        customizationID: String? = nil,
        learningOptOut: Bool? = nil,
        failure: ((Error) -> Void)? = nil,
        success: @escaping (SpeechRecognitionResults) -> Void)
    {
        recognizeUsingWebSocket(audio: audio, settings: settings, model: model, customizationID: customizationID,
                                learningOptOut: learningOptOut, failure: failure, success: success)
    }
}

#endif
