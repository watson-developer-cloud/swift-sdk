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
public class SpeechToTextSession {
    
    /// The results of the most recent recognition request.
    public var results: [TranscriptionResult] { return socket.results }
    
    /// The state of the WebSocket connection to the service.
    public var state: SpeechToTextState { return socket.state }
    
    /// Invoked when the WebSocket connects to the Speech to Text service.
    public var onConnect: (Void -> Void)? {
        get { return socket.onConnect }
        set { socket.onConnect = newValue }
    }
    
    /// Invoked when the Speech to Text service transitions to the listening state.
    public var onListening: (Void -> Void)? {
        get { return socket.onListening }
        set { socket.onListening = newValue }
    }
    
    /// Invoked when transcription results are received from the Speech to Text service.
    public var onResults: ([TranscriptionResult] -> Void)? {
        get { return socket.onResults }
        set { socket.onResults = newValue }
    }
    
    /// Invoked when an error or warning occurs.
    public var onError: (NSError -> Void)? {
        get { return socket.onError }
        set { socket.onError = newValue }
    }
    
    /// Invoked when the WebSocket disconnects from the Speech to Text service.
    public var onDisconnect: (Void -> Void)? {
        get { return socket.onDisconnect }
        set { socket.onDisconnect = newValue }
    }
    
    private let socket: SpeechToTextSocket
    private let recorder: SpeechToTextRecorder
    private let encoder: SpeechToTextEncoder
    private var compress: Bool = true
    private let domain = "com.ibm.watson.developer-cloud.SpeechToTextV1"
    
    /**
     Create a `SpeechToTextSession` object.
     
     - parameter username: The username used to authenticate with the service.
     - parameter password: The password used to authenticate with the service.
     - parameter model: 
     - parameter learningOptOut:
     - parameter serviceURL: The base URL of the Speech to Text service.
     - parameter tokenURL: The URL that shall be used to obtain a token.
     - parameter websocketsURL: The URL that shall be used to stream audio for transcription.
     */
    public init(
        username: String,
        password: String,
        model: String?,
        learningOptOut: Bool?,
        serviceURL: String = "https://stream.watsonplatform.net/speech-to-text/api",
        tokenURL: String = "https://stream.watsonplatform.net/authorization/api/v1/token",
        websocketsURL: String = "wss://stream.watsonplatform.net/speech-to-text/api/v1/recognize")
    {
        socket = SpeechToTextSocket(
            username: username,
            password: password,
            model: model,
            learningOptOut: learningOptOut,
            serviceURL: serviceURL,
            tokenURL: tokenURL,
            websocketsURL: websocketsURL
        )
        
        recorder = SpeechToTextRecorder()
        
        encoder = try! SpeechToTextEncoder(
            format: recorder.format,
            opusRate: 16000,
            application: .VOIP
        )
    }
    
    public func connect() {
        socket.connect()
    }
    
    public func startRequest(settings: TranscriptionSettings) {
        socket.startRequest(settings)
    }
    
    /**
     Transcribe an audio file.
     
     - parameter file: The audio file to transcribe.
     */
    public func recognize(file: NSURL) {
        guard let audio = NSData(contentsOfURL: file) else {
            let failureReason = "Could not load audio data from \(file)."
            let userInfo = [NSLocalizedFailureReasonErrorKey: failureReason]
            let error = NSError(domain: domain, code: 0, userInfo: userInfo)
            onError?(error)
            return
        }
        recognize(audio)
    }
    
    /**
     Transcribe audio data.
     
     - parameter audio: The audio data to transcribe.
     */
    public func recognize(audio: NSData) {
        socket.writeAudio(audio)
    }
    
    public func requestMicrophonePermission() {
        // TODO: implement this function and wrap it in SpeechToText
    }
    
    public func startMicrophone(compress: Bool = true) {
        print("starting microphone")
        self.compress = compress
        
        let onAudioPCM = { (pcm: NSData) in
            guard pcm.length > 0 else { return }
            self.socket.writeAudio(pcm)
        }
        
        let onAudioOpus = { (pcm: NSData) in
            guard pcm.length > 0 else { return }
            try! self.encoder.encode(pcm)
            let opus = self.encoder.bitstream(true)
            self.socket.writeAudio(opus)
        }
        
        if compress {
            recorder.onAudio = onAudioOpus
        } else {
            recorder.onAudio = onAudioPCM
        }
        
        recorder.startRecording()
    }
    
    public func stopMicrophone() {
        print("stopping microphone")
        recorder.stopRecording()
        if compress {
            let opus = try! self.encoder.endstream()
            self.socket.writeAudio(opus)
        }
    }
    
    public func stopRequest() {
        socket.stopRequest()
    }
    
    public func keepAlive() {
        socket.writeNop()
    }

    public func disconnect(forceTimeout: NSTimeInterval? = nil) {
        socket.disconnect()
    }
}
