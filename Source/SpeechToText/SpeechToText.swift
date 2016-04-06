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
import AVFoundation

/**
 The IBM Watson Speech to Text service enables you to add speech transcription capabilities to
 your application. It uses machine intelligence to combine information about grammar and language
 structure to generate an accurate transcription. Transcriptions are supported for various audio
 formats and languages.
 */
public class SpeechToText: WatsonService {

    private let authStrategy: AuthenticationStrategy

    /** A function that, when executed, stops streaming audio to Speech to Text. */
    public typealias StopStreaming = Void -> Void

    /**
     Instantiate a `SpeechToText` object that can be used to transcribe audio data to text.
    
     - parameter authStrategy: An `AuthenticationStrategy` that defines how to authenticate
        with the Watson Developer Cloud's Speech to Text service. The `AuthenticationStrategy`
        is used internally to obtain tokens, refresh expired tokens, and maintain information
        about authentication state.
     - returns: A `SpeechToText` object that can be used to transcribe audio data to text.
     */
    public required init(authStrategy: AuthenticationStrategy) {
        self.authStrategy = authStrategy
    }

    /**
     Instantiate a `SpeechToText` object that can be used to transcribe audio data to text.
    
     - parameter username: The username associated with your `SpeechToText` service.
     - parameter password: The password associated with your `SpeechToText` service.
     - returns: A `SpeechToText` object that can be used to transcribe audio data to text.
     */
    public convenience required init(username: String, password: String) {
        let authStrategy = BasicAuthenticationStrategy(
            tokenURL: SpeechToTextConstants.tokenURL,
            serviceURL: SpeechToTextConstants.serviceURL,
            username: username,
            password: password)
        self.init(authStrategy: authStrategy)
    }

    /**
     Transcribe an audio file.
    
     - parameter file: The audio file to transcribe.
     - parameter settings: The configuration for this transcription request.
     - parameter failure: A function executed whenever an error occurs.
     - parameter success: A function executed with all transcription results whenever
        a final or interim transcription is received.
     */
    public func transcribe(
        file: NSURL,
        settings: SpeechToTextSettings,
        failure: (NSError -> Void)? = nil,
        success: [SpeechToTextResult] -> Void)
    {
        guard let audio = NSData(contentsOfURL: file) else {
            let description = "Could not load audio data from \(file)."
            let error = createError(SpeechToTextConstants.domain, description: description)
            failure?(error)
            return
        }

        transcribe(audio, settings: settings, failure: failure, success: success)
    }

    /**
     Transcribe audio data.

     - parameter audio: The audio data to transcribe.
     - parameter settings: The configuration for this transcription request.
     - parameter failure: A function executed whenever an error occurs.
     - parameter success: A function executed with all transcription results whenever
        a final or interim transcription is received.
     */
    public func transcribe(
        audio: NSData,
        settings: SpeechToTextSettings,
        failure: (NSError -> Void)? = nil,
        success: [SpeechToTextResult] -> Void)
    {
        guard let socket = SpeechToTextWebSocket(
            authStrategy: authStrategy,
            settings: settings,
            failure: failure,
            success: success) else { return }

        guard let start = settings.toJSONString(failure),
              let stop = SpeechToTextStop().toJSONString(failure) else { return }

        socket.connect()
        socket.writeString(start)
        socket.writeData(audio)
        socket.writeString(stop)
        socket.disconnect()
    }

    /**
     Stream audio from the microphone to the Speech to Text service. The microphone will stop
     recording after an end-of-speech event is detected by the Speech to Text service or the
     returned function is executed.

     - parameter settings: The configuration for this transcription request.
     - parameter failure: A function executed whenever an error occurs.
     - parameter success: A function executed with all transcription results whenever
        a final or interim transcription is received.
     - returns: A function that, when executed, stops streaming audio to Speech to Text.
     */
    public func transcribe(
        settings: SpeechToTextSettings,
        failure: (NSError -> Void)? = nil,
        success: [SpeechToTextResult] -> Void)
        -> StopStreaming
    {
        guard let audioStreamer = SpeechToTextAudioStreamer(
            authStrategy: authStrategy,
            settings: settings,
            failure: failure,
            success: success) else { return { } }

        guard audioStreamer.startStreaming() else {
            audioStreamer.stopStreaming()
            return { }
        }

        return audioStreamer.stopStreaming
    }

    /**
     Create an `AVCaptureAudioDataOutput` that streams audio to the Speech to Text service.

     - parameter settings: The configuration for this transcription request.
     - parameter failure: A function executed whenever an error occurs.
     - parameter success: A function executed with all transcription results whenever
        a final or interim transcription is received.
     - returns: A tuple with two elements. The first element is an `AVCaptureAudioDataOutput` that
        streams audio to the Speech to Text service when set as the output of an `AVCaptureSession`.
        The second element is a function that, when executed, stops streaming to Speech to Text.
     */
    public func createTranscriptionOutput(
        settings: SpeechToTextSettings,
        failure: (NSError -> Void)? = nil,
        success: [SpeechToTextResult] -> Void)
        -> (AVCaptureAudioDataOutput, StopStreaming)?
    {
        guard let audioStreamer = SpeechToTextAudioStreamer(
            authStrategy: authStrategy,
            settings: settings,
            failure: failure,
            success: success) else { return nil }
        audioStreamer.startRecognitionRequest()
        return (audioStreamer.createTranscriptionOutput(), audioStreamer.stopRecognitionRequest)
    }
}
