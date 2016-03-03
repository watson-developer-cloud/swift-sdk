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

public class SpeechToText {

    private let authStrategy: AuthenticationStrategy
    private var captureSession: AVCaptureSession?
    private var audioStreamer: SpeechToTextAudioStreamer?

    /**
     Instantiate a `SpeechToText` object that can be used to transcribe audio data to text.
    
     - parameter authStrategy: An `AuthenticationStrategy` that defines how to authenticate
        with the Watson Developer Cloud's `SpeechToText` service. The `AuthenticationStrategy`
        is used internally to obtain tokens, refresh expired tokens, and maintain information
        about the state of authentication with the Watson Developer Cloud.
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
     Transcribe recorded audio data.

     - parameter audio: The recorded audio data.
     - parameter settings: Settings to configure the SpeechToText service.
     - parameter failure: A function that will be executed whenever a failure occurs.
     - parameter success: A function executed whenever a result is returned from Speech to Text.
     */
    public func transcribe(
        audio: NSData,
        settings: SpeechToTextSettings,
        failure: (NSError -> Void)? = nil,
        success: [SpeechToTextResult] -> Void)
    {
        guard let socket = createSocket(settings, failure: failure, success: success),
              let start = settings.toJSONString(failure),
              let stop = SpeechToTextStop().toJSONString(failure) else { return }

        socket.writeString(start)
        socket.writeData(audio)
        socket.writeString(stop)
    }

    /**
     StopRecording is a function that stops a microphone capture session. Microphone audio will no
     longer be streamed to the Speech to Text service after the capture session is stopped.
     */
    public typealias StopStreaming = Void -> Void

    /**
     Start the microphone and perform a live transcription by streaming the microphone audio to
     the Speech to Text service. The microphone will stop recording after an end-of-speech event
     is detected by the Speech to Text service or the returned `StopRecording` function is
     executed.

     - parameter settings: The settings used to configure the SpeechToText service.
     - parameter failure: A function that will be executed whenever a failure occurs.
     - parameter success: A function executed whenever a result is returned from Speech to Text.
     - returns: A `StopRecording` function that can be executed to stop streaming the microphone's
        audio to the Speech to Text service, wait for any remaining transcription results to be
        returned, and then execute the `completionHandler`.
     */
    public func transcribe(
        settings: SpeechToTextSettings,
        failure: (NSError -> Void)? = nil,
        success: [SpeechToTextResult] -> Void)
        -> StopStreaming
    {
        guard let socket = createSocket(settings, failure: failure, success: success),
              let start = settings.toJSONString(failure),
              let stop = SpeechToTextStop().toJSONString(failure) else { return { } }

        let stopStreaming = {
            self.captureSession?.stopRunning()
            socket.writeString(stop)
            socket.disconnect()
        }

        socket.writeString(start)
        guard startStreaming(socket, failure: failure) else {
            stopStreaming()
            return { }
        }

        return stopStreaming
    }

    public func createTranscriptionStream(
        settings: SpeechToTextSettings,
        failure: (NSError -> Void)? = nil,
        success: [SpeechToTextResult] -> Void)
        -> AVCaptureAudioDataOutput?
    {
        guard let socket = createSocket(settings, failure: failure, success: success),
              let start = settings.toJSONString(failure) else { return nil }

        socket.writeString(start)

        let output = AVCaptureAudioDataOutput()
        let queue = dispatch_queue_create("stt_streaming_output", DISPATCH_QUEUE_SERIAL)
        audioStreamer = SpeechToTextAudioStreamer(socket: socket, failure: failure)
        output.setSampleBufferDelegate(audioStreamer, queue: queue)

        return output
    }

    // MARK: Helper Functions

    private func createSocket(
        settings: SpeechToTextSettings,
        failure: (NSError -> Void)? = nil,
        success: [SpeechToTextResult] -> Void)
        -> SpeechToTextWebSocket?
    {
        guard let url = NSURL(string: SpeechToTextConstants.websocketsURL(settings)) else {
            if let failure = failure {
                let description = "Could not parse Speech to Text WebSockets URL."
                let error = createError(SpeechToTextConstants.domain, description: description)
                failure(error)
            }
            return nil
        }

        let socket = SpeechToTextWebSocket(
            authStrategy: authStrategy,
            url: url,
            failure: failure,
            success: success)

        return socket
    }

    private func startStreaming(
        socket: SpeechToTextWebSocket,
        failure: (NSError -> Void)? = nil)
        -> Bool
    {
        captureSession = AVCaptureSession()
        guard let captureSession = captureSession else {
            return false
        }

        let microphoneDevice = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeAudio)
        guard let microphoneInput = try? AVCaptureDeviceInput(device: microphoneDevice) else {
            if let failure = failure {
                let description = "Unable to access the microphone."
                let error = createError(SpeechToTextConstants.domain, description: description)
                failure(error)
            }
            return false
        }

        guard captureSession.canAddInput(microphoneInput) else {
            if let failure = failure {
                let description = "Unable to add the microphone to the capture session."
                let error = createError(SpeechToTextConstants.domain, description: description)
                failure(error)
            }
            return false
        }

        let output = AVCaptureAudioDataOutput()
        let queue = dispatch_queue_create("stt_streaming", DISPATCH_QUEUE_SERIAL)
        audioStreamer = SpeechToTextAudioStreamer(socket: socket, failure: failure)
        output.setSampleBufferDelegate(audioStreamer, queue: queue)

        guard captureSession.canAddOutput(output) else {
            if let failure = failure {
                let description = "Unable to add streaming output to the capture session."
                let error = createError(SpeechToTextConstants.domain, description: description)
                failure(error)
            }
            return false
        }

        captureSession.addInput(microphoneInput)
        captureSession.addOutput(output)
        captureSession.startRunning()
        return true
    }
}
