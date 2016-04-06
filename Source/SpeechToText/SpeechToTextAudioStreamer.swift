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

/** Stream microphone audio to Speech to Text. */
class SpeechToTextAudioStreamer: NSObject, AVCaptureAudioDataOutputSampleBufferDelegate {

    private var settings: SpeechToTextSettings
    private var failure: (NSError -> Void)?
    private let success: [SpeechToTextResult] -> Void
    private var socket: SpeechToTextWebSocket?
    private var captureSession: AVCaptureSession?

    /**
     Create a `SpeechToTextAudioStreamer` to stream microphone audio to Speech to Text.

     - parameter authStrategy: An `AuthenticationStrategy` that defines how to authenticate
        with the Watson Developer Cloud's Speech to Text service. The `AuthenticationStrategy`
        is used internally to obtain tokens, refresh expired tokens, and maintain information
        about authentication state.
     - parameter settings: The configuration for this transcription request.
     - parameter failure: A function executed whenever an error occurs.
     - parameter success: A function executed with all transcription results whenever
        a final or interim transcription is received.
     
     - returns: A `SpeechToTextAudioStreamer` object that can stream microphone audio to
        Speech to Text.
    */
    init?(
        authStrategy: AuthenticationStrategy,
        settings: SpeechToTextSettings,
        failure: (NSError -> Void)? = nil,
        success: [SpeechToTextResult] -> Void)
    {
        self.settings = settings
        self.success = success
        self.failure = failure

        super.init()

        self.failure = { (error: NSError) in
            self.stopStreaming()
            failure?(error)
        }

        guard let socket = SpeechToTextWebSocket(
            authStrategy: authStrategy,
            settings: settings,
            failure: failure,
            success: success) else
        {
            // A bug in the Swift compiler requires us to set all properties before returning nil
            // This bug is fixed in Swift 2.2, so we can set socket as non-optional
            return nil
        }

        self.socket = socket
    }

    /**
     Start streaming microphone audio to Speech to Text.

     - returns: `true` if the `AVCaptureSession` could be configured to stream microphone audio
        to the Speech to Text service; false, otherwise.
     */
    func startStreaming() -> Bool {

        captureSession = AVCaptureSession()
        guard let captureSession = captureSession else {
            let description = "Unable to create an AVCaptureSession."
            let error = createError(SpeechToTextConstants.domain, description: description)
            failure?(error)
            return false
        }

        let microphoneInput = createMicrophoneInput()
        guard captureSession.canAddInput(microphoneInput) else {
            let description = "Unable to add the microphone as a capture session input. " +
                              "(Note that the microphone is only accessible on a physical device" +
                              "--no microphone is accessible from within the simulator.)"
            let error = createError(SpeechToTextConstants.domain, description: description)
            failure?(error)
            return false
        }

        let transcriptionOutput = createTranscriptionOutput()
        guard captureSession.canAddOutput(transcriptionOutput) else {
            let description = "Unable to add transcription as a capture session output."
            let error = createError(SpeechToTextConstants.domain, description: description)
            failure?(error)
            return false
        }

        startRecognitionRequest()
        captureSession.addInput(microphoneInput)
        captureSession.addOutput(transcriptionOutput)
        captureSession.startRunning()
        return true
    }

    /**
     Initiate the recognition request.
     */
    func startRecognitionRequest() {
        settings.contentType = .L16(rate: 44100, channels: 1)
        if let start = settings.toJSONString(failure) {
            socket?.connect()
            socket?.writeString(start)
        }
    }

    /**
     Send a stop message to stop the recognition request.
     */
    func stopRecognitionRequest() {
        if let stop = SpeechToTextStop().toJSONString(failure) {
            socket?.writeString(stop)
            socket?.disconnect()
        }
    }

    /**
     Stop streaming microphone audio to Speech to Text
     */
    func stopStreaming() {
        captureSession?.stopRunning()
        captureSession = nil
        stopRecognitionRequest()
    }

    /**
     Send an audio sample buffer to Speech to Text.
     
     - parameter captureOutput: The capture output object.
     - parameter sampleBuffer: The sample buffer that was output.
     - parameter connection: The connection.
     */
    func captureOutput(
        captureOutput: AVCaptureOutput!,
        didOutputSampleBuffer sampleBuffer: CMSampleBuffer!,
        fromConnection connection: AVCaptureConnection!)
    {
        guard CMSampleBufferDataIsReady(sampleBuffer) else {
            let description = "Microphone audio buffer ignored because it was not ready."
            let error = createError(SpeechToTextConstants.domain, description: description)
            failure?(error)
            return
        }

        let emptyBuffer = AudioBuffer(mNumberChannels: 0, mDataByteSize: 0, mData: nil)
        var audioBufferList = AudioBufferList(mNumberBuffers: 1, mBuffers: emptyBuffer)
        var blockBuffer: CMBlockBuffer?
        
        CMSampleBufferGetAudioBufferListWithRetainedBlockBuffer(
            sampleBuffer,
            nil,
            &audioBufferList,
            sizeof(audioBufferList.dynamicType),
            nil,
            nil,
            UInt32(kCMSampleBufferFlag_AudioBufferList_Assure16ByteAlignment),
            &blockBuffer)

        let audioData = NSMutableData()
        let audioBuffers = UnsafeBufferPointer<AudioBuffer>(start: &audioBufferList.mBuffers,
            count: Int(audioBufferList.mNumberBuffers))
        for audioBuffer in audioBuffers {
            audioData.appendBytes(audioBuffer.mData, length: Int(audioBuffer.mDataByteSize))
        }

        socket?.writeData(audioData)
    }

    /**
     Create a microphone input for use with an `AVCaptureSession`.
     
     - returns: An `AVCaptureDeviceInput` for the default audio input device, or nil if the
        default audio input device is inaccessible.
     */
    func createMicrophoneInput() -> AVCaptureDeviceInput? {
        let microphoneDevice = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeAudio)
        guard let microphoneInput = try? AVCaptureDeviceInput(device: microphoneDevice) else {
            let description = "Unable to access the microphone."
            let error = createError(SpeechToTextConstants.domain, description: description)
            failure?(error)
            return nil
        }
        return microphoneInput
    }

    /**
     Create a transcription output for use with an `AVCaptureSession`.

     - returns: An `AVCaptureAudioDataOutput` that streams audio data to Speech to Text.
     */
    func createTranscriptionOutput() -> AVCaptureAudioDataOutput {
        let output = AVCaptureAudioDataOutput()
        let queue = dispatch_queue_create("stt_streaming", DISPATCH_QUEUE_SERIAL)
        output.setSampleBufferDelegate(self, queue: queue)
        return output
    }
}
