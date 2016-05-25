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
import AVFoundation
import RestKit

/**
 The IBM Watson Speech to Text service enables you to add speech transcription capabilities to
 your application. It uses machine intelligence to combine information about grammar and language
 structure to generate an accurate transcription. Transcriptions are supported for various audio
 formats and languages.
 */
public class SpeechToText {

    private let restToken: RestToken
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
        self.restToken = RestToken(
            tokenURL: tokenURL + "?url=" + serviceURL,
            username: username,
            password: password
        )
        self.websocketsURL = websocketsURL
    }

    /** A function that, when executed, stops streaming audio to Speech to Text. */
    public typealias StopStreaming = Void -> Void

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
        settings: TranscriptionSettings,
        failure: (NSError -> Void)? = nil,
        success: [TranscriptionResult] -> Void)
    {
        guard let audio = NSData(contentsOfURL: file) else {
            let failureReason = "Could not load audio data from \(file)."
            let userInfo = [NSLocalizedFailureReasonErrorKey: failureReason]
            let error = NSError(domain: domain, code: 0, userInfo: userInfo)
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
        settings: TranscriptionSettings,
        failure: (NSError -> Void)? = nil,
        success: [TranscriptionResult] -> Void)
    {
        guard let socket = SpeechToTextWebSocket(
            websocketsURL: websocketsURL,
            restToken: restToken,
            settings: settings,
            failure: failure,
            success: success) else { return }
        
        do {
            let start = try settings.toJSON().serializeString()
            let stop = try TranscriptionStop().toJSON().serializeString()
            socket.connect()
            socket.writeString(start)
            socket.writeData(audio)
            socket.writeString(stop)
            socket.disconnect()
        } catch {
            let failureReason = "Failed to serialize start and stop instructions to JSON."
            let userInfo = [NSLocalizedFailureReasonErrorKey: failureReason]
            let error = NSError(domain: domain, code: 0, userInfo: userInfo)
            failure?(error)
            return
        }
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
        settings: TranscriptionSettings,
        failure: (NSError -> Void)? = nil,
        success: [TranscriptionResult] -> Void)
        -> StopStreaming
    {
        guard let audioStreamer = SpeechToTextAudioStreamer(
            websocketsURL: websocketsURL,
            restToken: restToken,
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
        settings: TranscriptionSettings,
        failure: (NSError -> Void)? = nil,
        success: [TranscriptionResult] -> Void)
        -> (AVCaptureAudioDataOutput, StopStreaming)?
    {
        guard let audioStreamer = SpeechToTextAudioStreamer(
            websocketsURL: websocketsURL,
            restToken: restToken,
            settings: settings,
            failure: failure,
            success: success) else { return nil }
        audioStreamer.startRecognitionRequest()
        return (audioStreamer.createTranscriptionOutput(), audioStreamer.stopRecognitionRequest)
    }
}
