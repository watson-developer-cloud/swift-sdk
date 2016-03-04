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

class SpeechToTextAudioStreamer: NSObject, AVCaptureAudioDataOutputSampleBufferDelegate {

    private var settings: SpeechToTextSettings
    private var failure: (NSError -> Void)?
    private let success: [SpeechToTextResult] -> Void
    private var socket: SpeechToTextWebSocket?
    private var captureSession: AVCaptureSession?

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

    func startStreaming() -> Bool {

        settings.contentType = .L16(rate: 44100, channels: 1)
        guard let start = settings.toJSONString(failure) else {
            return false
        }

        captureSession = AVCaptureSession()
        let microphoneInput = createMicrophoneInput()
        let transcriptionOutput = createTranscriptionOutput()

        guard let captureSession = captureSession else {
            if let failure = failure {
                let description = "Unable to create an AVCaptureSession."
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

        guard captureSession.canAddOutput(transcriptionOutput) else {
            if let failure = failure {
                let description = "Unable to add streaming output to the capture session."
                let error = createError(SpeechToTextConstants.domain, description: description)
                failure(error)
            }
            return false
        }

        socket?.writeString(start)
        captureSession.addInput(microphoneInput)
        captureSession.addOutput(transcriptionOutput)
        captureSession.startRunning()
        return true
    }

    func stopStreaming() {
        captureSession?.stopRunning()
        captureSession = nil
        if let stop = SpeechToTextStop().toJSONString(failure) {
            socket?.writeString(stop)
            socket?.disconnect()
        }
    }

    func captureOutput(
        captureOutput: AVCaptureOutput!,
        didOutputSampleBuffer sampleBuffer: CMSampleBuffer!,
        fromConnection connection: AVCaptureConnection!)
    {
        guard CMSampleBufferDataIsReady(sampleBuffer) else {
            if let failure = failure {
                let description = "Microphone audio buffer ignored because it was not ready."
                let error = createError(SpeechToTextConstants.domain, description: description)
                failure(error)
            }
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

    private func createMicrophoneInput() -> AVCaptureDeviceInput? {
        let microphoneDevice = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeAudio)
        guard let microphoneInput = try? AVCaptureDeviceInput(device: microphoneDevice) else {
            if let failure = failure {
                let description = "Unable to access the microphone."
                let error = createError(SpeechToTextConstants.domain, description: description)
                failure(error)
            }
            return nil
        }
        return microphoneInput
    }

    func createTranscriptionOutput() -> AVCaptureAudioDataOutput {
        let output = AVCaptureAudioDataOutput()
        let queue = dispatch_queue_create("stt_streaming", DISPATCH_QUEUE_SERIAL)
        output.setSampleBufferDelegate(self, queue: queue)
        return output
    }
}