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

    /// The URL that shall be used to stream audio for transcription.
    internal var websocketsURL: String {
        return serviceURL
            .replacingOccurrences(of: "http", with: "ws", options: .anchored, range: nil)
            + "/v1/recognize"
    }

    /**
     Perform speech recognition for audio data using WebSockets.

     - parameter audio: The audio data to transcribe.
     - parameter settings: The configuration to use for this recognition request.
     - parameter model: The language and sample rate of the audio. For supported models, visit
       https://cloud.ibm.com/docs/services/speech-to-text/input.html#models.
     - parameter baseModelVersion: The version of the specified base model that is to be used for all requests sent
       over the connection. Multiple versions of a base model can exist when a model is updated for internal improvements.
       The parameter is intended primarily for use with custom models that have been upgraded for a new base model.
       The default value depends on whether the parameter is used with or without a custom model. See
       [Base model version](https://cloud.ibm.com/docs/services/speech-to-text/input.html#version).
     - parameter languageCustomizationID: The customization ID (GUID) of a custom language model that is to be used
       with the recognition request. The base model of the specified custom language model must match the model
       specified with the `model` parameter. You must make the request with service credentials created for the instance
       of the service that owns the custom model. By default, no custom language model is used. See [Custom
       models](https://cloud.ibm.com/docs/services/speech-to-text/input.html#custom).
     - parameter acousticCustomizationID: The customization ID (GUID) of a custom acoustic model
       that is to be used with the recognition request. The base model of the specified custom
       acoustic model must match the model specified with the `model` parameter. By default, no
       custom acoustic model is used.
     - parameter learningOptOut: If `true`, then this request will not be logged for training.
     - parameter customerID: Associates a customer ID with all data that is passed over the connection.
       By default, no customer ID is associated with the data.
     - parameter headers: A dictionary of request headers to be sent with this request.
     - parameter completionHandler: A function executed when the request completes with a successful result or error
     */
    public func recognizeUsingWebSocket(
        audio: Data,
        settings: RecognitionSettings,
        model: String? = nil,
        baseModelVersion: String? = nil,
        languageCustomizationID: String? = nil,
        acousticCustomizationID: String? = nil,
        learningOptOut: Bool? = nil,
        customerID: String? = nil,
        headers: [String: String]? = nil,
        callback: RecognizeCallback)
    {
        // create SpeechToTextSession
        let session = SpeechToTextSession(
            authMethod: authMethod,
            model: model,
            baseModelVersion: baseModelVersion,
            languageCustomizationID: languageCustomizationID,
            acousticCustomizationID: acousticCustomizationID,
            learningOptOut: learningOptOut,
            customerID: customerID
        )

        // set url
        session.websocketsURL = websocketsURL

        // set headers
        session.defaultHeaders = defaultHeaders
        if let headers = headers {
            session.defaultHeaders.merge(headers) { (_, new) in new }
        }
        let sdkHeaders = Shared.getSDKHeaders(serviceName: serviceName, serviceVersion: serviceVersion, methodName: "recognizeUsingWebSocket")
        session.defaultHeaders.merge(sdkHeaders) { (_, new) in new }

        // set callbacks
        session.onResults = callback.onResults
        session.onError = callback.onError

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
       https://cloud.ibm.com/docs/services/speech-to-text/input.html#models.
     - parameter baseModelVersion: The version of the specified base model that is to be used for all requests sent
       over the connection. Multiple versions of a base model can exist when a model is updated for internal improvements.
       The parameter is intended primarily for use with custom models that have been upgraded for a new base model.
       The default value depends on whether the parameter is used with or without a custom model. See
       [Base model version](https://cloud.ibm.com/docs/services/speech-to-text/input.html#version).
     - parameter languageCustomizationID: The customization ID (GUID) of a custom language model that is to be used
       with the recognition request. The base model of the specified custom language model must match the model
       specified with the `model` parameter. You must make the request with service credentials created for the instance
       of the service that owns the custom model. By default, no custom language model is used. See [Custom
       models](https://cloud.ibm.com/docs/services/speech-to-text/input.html#custom).
     - parameter acousticCustomizationID: The customization ID (GUID) of a custom acoustic model
       that is to be used with the recognition request. The base model of the specified custom
       acoustic model must match the model specified with the `model` parameter. By default, no
       custom acoustic model is used.
     - parameter learningOptOut: If `true`, then this request will not be logged for training.
     - parameter customerID: Associates a customer ID with all data that is passed over the connection.
       By default, no customer ID is associated with the data.
     - parameter compress: Should microphone audio be compressed to Opus format?
       (Opus compression reduces latency and bandwidth.)
     - parameter headers: A dictionary of request headers to be sent with this request.
     - parameter completionHandler: A function executed when the request completes with a successful result or error
     */
    public func recognizeMicrophone(
        settings: RecognitionSettings,
        model: String? = nil,
        baseModelVersion: String? = nil,
        languageCustomizationID: String? = nil,
        acousticCustomizationID: String? = nil,
        learningOptOut: Bool? = nil,
        customerID: String? = nil,
        compress: Bool = true,
        headers: [String: String]? = nil,
        callback: RecognizeCallback)
    {
        // make sure the AVAudioSession shared instance is properly configured
        do {
            let audioSession = AVAudioSession.sharedInstance()
            try audioSession.setCategory(AVAudioSession.Category.playAndRecord, mode: .default, options: [.defaultToSpeaker, .mixWithOthers])
            try audioSession.setActive(true)
        } catch {
            let failureReason = "Failed to setup the AVAudioSession sharedInstance properly."
            callback.onError?(WatsonError.other(message: failureReason, metadata: nil))
            return
        }

        // validate settings
        var settings = settings
        settings.contentType = compress ? "audio/ogg;codecs=opus" : "audio/l16;rate=16000;channels=1"

        // create SpeechToTextSession
        let session = SpeechToTextSession(
            authMethod: authMethod,
            model: model,
            baseModelVersion: baseModelVersion,
            languageCustomizationID: languageCustomizationID,
            acousticCustomizationID: acousticCustomizationID,
            learningOptOut: learningOptOut,
            customerID: customerID
        )

        // set url
        session.websocketsURL = websocketsURL

        // set headers
        session.defaultHeaders = defaultHeaders
        if let headers = headers {
            session.defaultHeaders.merge(headers) { (_, new) in new }
        }
        let sdkHeaders = Shared.getSDKHeaders(serviceName: serviceName, serviceVersion: serviceVersion, methodName: "recognizeMicrophone")
        session.defaultHeaders.merge(sdkHeaders) { (_, new) in new }

        // set callbacks
        session.onResults = callback.onResults
        session.onError = callback.onError

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

#endif
