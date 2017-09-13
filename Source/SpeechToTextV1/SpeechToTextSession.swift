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

/**
 The IBM Watson Speech to Text service enables you to add speech transcription capabilities to
 your application. It uses machine intelligence to combine information about grammar and language
 structure to generate an accurate transcription. Transcriptions are supported for various audio
 formats and languages.
 
 This class enables fine-tuned control of a WebSockets session with the Speech to Text service.
 Although it is a more complex interface than the `SpeechToText` class, it provides more control
 and customizability of the session.
 */
public class SpeechToTextSession {
    
    /// The base URL of the Speech to Text service.
    public var serviceURL = "https://stream.watsonplatform.net/speech-to-text/api"
    
    /// The URL that shall be used to obtain a token.
    public var tokenURL = "https://stream.watsonplatform.net/authorization/api/v1/token"
    
    /// The URL that shall be used to stream audio for transcription.
    public var websocketsURL = "wss://stream.watsonplatform.net/speech-to-text/api/v1/recognize"
    
    /// The default HTTP headers for all requests to the service.
    public var defaultHeaders = [String: String]()
    
    /// The results of the most recent recognition request.
    public var results: SpeechRecognitionResults {
        get { return socket.results }
    }
    
    /// Invoked when the session connects to the Speech to Text service.
    public var onConnect: (() -> Void)? {
        get { return socket.onConnect }
        set { socket.onConnect = newValue }
    }
    
    /// Invoked with microphone audio when a recording audio queue buffer has been filled.
    /// If microphone audio is being compressed, then the audio data is in OggOpus format.
    /// If uncompressed, then the audio data is in 16-bit mono PCM format at 16 kHZ.
    public var onMicrophoneData: ((Data) -> Void)?
    
    /// Invoked every 0.025s when recording with the average dB power of the microphone.
    public var onPowerData: ((Float32) -> Void)? {
        get { return recorder.onPowerData }
        set { recorder.onPowerData = newValue }
    }
    
    /// Invoked when transcription results are received for a recognition request.
    public var onResults: ((SpeechRecognitionResults) -> Void)? {
        get { return socket.onResults }
        set { socket.onResults = newValue }
    }
    
    /// Invoked when an error or warning occurs.
    public var onError: ((Error) -> Void)? {
        get { return socket.onError }
        set { socket.onError = newValue }
    }
    
    /// Invoked when the session disconnects from the Speech to Text service.
    public var onDisconnect: (() -> Void)?
    
    private lazy var socket: SpeechToTextSocket = {
        var socket = SpeechToTextSocket(
            username: self.username,
            password: self.password,
            model: self.model,
            customizationID: self.customizationID,
            learningOptOut: self.learningOptOut,
            serviceURL: self.serviceURL,
            tokenURL: self.tokenURL,
            websocketsURL: self.websocketsURL,
            defaultHeaders: self.defaultHeaders
        )
        socket.onDisconnect = { [weak self] in
            guard let `self` = self else { return }
            if self.recorder.isRecording {
                self.stopMicrophone()
            }
            self.onDisconnect?()
        }
        return socket
    }()
    
    private var recorder: SpeechToTextRecorder
    private var encoder: SpeechToTextEncoder
    private var compress: Bool = true
    private let domain = "com.ibm.watson.developer-cloud.SpeechToTextV1"
    
    private let username: String
    private let password: String
    private let model: String?
    private let customizationID: String?
    private let learningOptOut: Bool?
    
    /**
     Create a `SpeechToTextSession` object.
     
     - parameter username: The username used to authenticate with the service.
     - parameter password: The password used to authenticate with the service.
     - parameter model: The language and sample rate of the audio. For supported models, visit
        https://www.ibm.com/watson/developercloud/doc/speech-to-text/input.shtml#models.
     - parameter customizationID: The GUID of a custom language model that is to be used with the
        request. The base language model of the specified custom language model must match the
        model specified with the `model` parameter. By default, no custom model is used.
     - parameter learningOptOut: If `true`, then this request will not be logged for training.
     */
    public init(username: String, password: String, model: String? = nil, customizationID: String? = nil, learningOptOut: Bool? = nil) {
        self.username = username
        self.password = password
        self.model = model
        self.customizationID = customizationID
        self.learningOptOut = learningOptOut
        
        recorder = SpeechToTextRecorder()
        encoder = try! SpeechToTextEncoder(
            format: recorder.format,
            opusRate: Int32(recorder.format.mSampleRate),
            application: .voip
        )
    }
    
    /**
     Connect to the Speech to Text service.
     
     If set, the `onConnect()` callback will be invoked after the session connects to the service.
     */
    public func connect() {
        socket.connect()
    }
    
    /**
     Start a recognition request.
 
     - parameter settings: The configuration to use for this recognition request.
     */
    public func startRequest(settings: RecognitionSettings) {
        socket.writeStart(settings: settings)
    }
    
    /**
     Send an audio file to transcribe.
     
     - parameter audio: The audio file to transcribe.
     */
    public func recognize(audio: URL) {
        do {
            let data = try Data(contentsOf: audio)
            recognize(audio: data)
        } catch {
            let failureReason = "Could not load audio data from \(audio)."
            let userInfo = [NSLocalizedFailureReasonErrorKey: failureReason]
            let error = NSError(domain: domain, code: 0, userInfo: userInfo)
            onError?(error)
            return
        }
    }
    
    /**
     Send audio data to transcribe.
     
     - parameter audio: The audio data to transcribe.
     */
    public func recognize(audio: Data) {
        socket.writeAudio(audio: audio)
    }
    
    /**
     Start streaming microphone audio data to transcribe.
     
     By default, microphone audio data is compressed to OggOpus format to reduce latency and bandwidth.
     To disable OggOpus compression and send linear PCM data instead, set `compress` to `false`.
     
     If compression is enabled, the recognitions request's `contentType` setting should be set to
     `AudioMediaType.oggOpus`. If compression is disabled, then the `contentType` settings should be
     set to `AudioMediaType.L16(rate: 16000, channels: 1)`.
     
     This function may cause the system to automatically prompt the user for permission
     to access the microphone. Use `AVAudioSession.requestRecordPermission(_:)` if you
     would rather prefer to ask for the user's permission in advance.
     
     - parameter compress: Should microphone audio be compressed to OggOpus format?
        (OggOpus compression reduces latency and bandwidth.)
     */
    public func startMicrophone(compress: Bool = true) {
        self.compress = compress
        
        // reset encoder
        encoder = try! SpeechToTextEncoder(
            format: recorder.format,
            opusRate: Int32(recorder.format.mSampleRate),
            application: .voip
        )
        
        // request recording permission
        recorder.session.requestRecordPermission { granted in
            guard granted else {
                let failureReason = "Permission was not granted to access the microphone."
                let userInfo = [NSLocalizedFailureReasonErrorKey: failureReason]
                let error = NSError(domain: self.domain, code: 0, userInfo: userInfo)
                self.onError?(error)
                return
            }
            
            // callback if uncompressed
            let onMicrophoneDataPCM = { [weak self] (pcm: Data) in
                guard let `self` = self else { return }
                guard pcm.count > 0 else { return }
                self.socket.writeAudio(audio: pcm)
                self.onMicrophoneData?(pcm)
            }
            
            // callback if compressed
            let onMicrophoneDataOpus = { [weak self] (pcm: Data) in
                guard let `self` = self else { return }
                guard pcm.count > 0 else { return }
                try! self.encoder.encode(pcm: pcm)
                let opus = self.encoder.bitstream(flush: true)
                guard opus.count > 0 else { return }
                self.socket.writeAudio(audio: opus)
                self.onMicrophoneData?(opus)
            }
            
            // set callback
            if compress {
                self.recorder.onMicrophoneData = onMicrophoneDataOpus
            } else {
                self.recorder.onMicrophoneData = onMicrophoneDataPCM
            }
            
            // start recording
            do {
                try self.recorder.startRecording()
            } catch {
                let failureReason = "Failed to start recording."
                let userInfo = [NSLocalizedFailureReasonErrorKey: failureReason]
                let error = NSError(domain: self.domain, code: 0, userInfo: userInfo)
                self.onError?(error)
                return
            }
        }
    }
    
    /**
     Stop streaming microphone audio data to transcribe.
     */
    public func stopMicrophone() {
        do {
            try recorder.stopRecording()
        } catch {
            let failureReason = "Failed to stop recording."
            let userInfo = [NSLocalizedFailureReasonErrorKey: failureReason]
            let error = NSError(domain: self.domain, code: 0, userInfo: userInfo)
            self.onError?(error)
            return
        }
        
        if compress {
            let opus = try! encoder.endstream()
            guard opus.count > 0 else { return }
            self.socket.writeAudio(audio: opus)
        }
    }
    
    /**
     Stop the recognition request.
     */
    public func stopRequest() {
        socket.writeStop()
    }
    
    /**
     Wait for any queued recognition requests to complete then disconnect from the service.
     */
    public func disconnect() {
        socket.waitForResults()
        socket.disconnect()
    }
}
