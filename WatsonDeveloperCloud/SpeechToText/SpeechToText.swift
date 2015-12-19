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

import ObjectMapper

/**
    The IBM® Speech to Text service provides an Application Programming Interface (API) that
    enables you to add speech transcription capabilities to your applications.
*/
public class SpeechToText: WatsonService {
    
    private let tokenURL = "https://stream.watsonplatform.net/authorization/api/v1/token"
    private let serviceURL = "/speech-to-text/api"
    private let serviceURLFull = "https://stream.watsonplatform.net/speech-to-text/api"
   
    
    private let WATSON_AUDIO_SAMPLE_RATE = 16000
    private let WATSON_AUDIO_FRAME_SIZE = 160
    
    
    // NSOperationQueues
    var transcriptionQueue: NSOperationQueue!
    
    public var delegate : SpeechToTextDelegate?
    
    private let opus: OpusHelper = OpusHelper()
    private let ogg: OggHelper = OggHelper()
    
    private let watsonSocket: WatsonSocket
   
    var audioState: AudioRecorderState?
    var audioData: NSData?
    
    // If set, contains the callback function after a transcription request.
    var callback: ((SpeechToTextResponse?, NSError?) -> Void)?
    
    
    struct AudioRecorderState {
        var dataFormat: AudioStreamBasicDescription
        var queue: AudioQueueRef
        var buffers: [AudioQueueBufferRef]
        var bufferByteSize: UInt32
        var currentPacket: Int64
        var isRunning: Bool
        var opusEncoder: OpusHelper
        var oggEncoder: OggHelper
        var watsonSocket: WatsonSocket
    }
    
    let NUM_BUFFERS = 3
    let BUFFER_SIZE: UInt32 = 4096

    
    
    // The shared WatsonGateway singleton.
    let gateway = WatsonGateway.sharedInstance
    
    // The authentication strategy to obtain authorization tokens.
    let authStrategy: AuthenticationStrategy
    
    public required init(authStrategy: AuthenticationStrategy) {
        watsonSocket = WatsonSocket(authStrategy: authStrategy)
        opus.createEncoder(Int32(WATSON_AUDIO_SAMPLE_RATE))
        self.authStrategy = authStrategy
        watsonSocket.delegate = self
    }
    
    public convenience required init(username: String, password: String) {
        let authStrategy = BasicAuthenticationStrategy(
            tokenURL: "https://stream.watsonplatform.net/authorization/api/v1/token",
            serviceURL: "https://stream.watsonplatform.net/speech-to-text/api",
            username: username,
            password: password)
        self.init(authStrategy: authStrategy)
    }
    
    public func startListening()
    {
        
        //var queue = AudioQueueRef()
//        let buffers:[AudioQueueBufferRef] = [AudioQueueBufferRef(),
//            AudioQueueBufferRef(),
//            AudioQueueBufferRef()]
        
        // connectWebsocket()
        
        let format = AudioStreamBasicDescription(
            mSampleRate: 16000,
            mFormatID: kAudioFormatLinearPCM,
            mFormatFlags: kLinearPCMFormatFlagIsSignedInteger | kLinearPCMFormatFlagIsPacked,
            mBytesPerPacket: 2,
            mFramesPerPacket: 1,
            mBytesPerFrame: 2,
            mChannelsPerFrame: 1,
            mBitsPerChannel: 8 * 2,
            mReserved: 0)
        
        audioState = AudioRecorderState(
            dataFormat: format,
            queue: AudioQueueRef(),
            buffers: [AudioQueueBufferRef(), AudioQueueBufferRef(), AudioQueueBufferRef()],
            bufferByteSize: BUFFER_SIZE,
            currentPacket: 0,
            isRunning: true,
            opusEncoder: opus,
            oggEncoder: ogg,
            watsonSocket: watsonSocket
        )
        
        
        if var audioState = audioState {
        
            AudioQueueNewInput(&audioState.dataFormat, recordCallback, &audioState,
                nil, kCFRunLoopCommonModes, 0, &audioState.queue)

            for index in 1...NUM_BUFFERS {
                AudioQueueAllocateBuffer(audioState.queue, BUFFER_SIZE, &audioState.buffers[index-1])
            
                AudioQueueEnqueueBuffer(audioState.queue, audioState.buffers[index-1], 0, nil)

            }
        
            AudioQueueStart(audioState.queue, nil)
        
        } else {
            Log.sharedLogger.error("No audio state object was created.")
        }
        
    }
    
    public func stopListening()
    {
        if var audioState = audioState {
            
            AudioQueueStop(audioState.queue, true)
        
            audioState.isRunning = false
        
            AudioQueueDispose(audioState.queue, true)
            
        } else {
            Log.sharedLogger.error("Audio state not created")
        }
    }
    
    /// Callback function when the audio buffer is full
    var recordCallback : AudioQueueInputCallback =
    {
        inUserData, inAQ, inBuffer, inStartTime, inNumberPacketDescriptions, inPacketDescs in
        
        let watsonFrameSize = 160
        
        let pUserData = UnsafeMutablePointer<AudioRecorderState>(inUserData)
        let data: AudioRecorderState = pUserData.memory
        
        let buffer = inBuffer.memory
        let length: Int = Int(buffer.mAudioDataByteSize)
        
        if length == 0 {
            return 
        }
        
        
        let chunkSize: Int = watsonFrameSize * 2
        var offset : Int = 0
        
        var ptr = UnsafeMutablePointer<UInt8>(buffer.mAudioData)
        
        let newData = NSData(bytesNoCopy: ptr, length: Int(buffer.mAudioDataByteSize), freeWhenDone: false)
        
        data.watsonSocket.send(newData)
        // Log.sharedLogger.info("Added the audio to the queue")
        //let o1 = AudioUploadOperation(data: newData, socket: data.socket!)
        //data.audioUploadQueue.addOperation(o1)
        
        
        // Tell the buffer it's free to accept more data
        AudioQueueEnqueueBuffer(data.queue, inBuffer, 0, nil)
        
        
    }
    
    /**
     This function takes audio data a returns a callback with the string transcription
     
     - parameter audio:    <#audio description#>
     - parameter callback: A function that will return the string
     */
    public func transcribe(audioData: NSData,
        format: MediaType = .FLAC,
        completionHandler: (SpeechToTextResponse?, NSError?) -> Void) {
            
            
            watsonSocket.format = format
            watsonSocket.send(audioData)
            
            self.callback = completionHandler
        
//            connectWebsocket()
//        
//           
//            self.audioData = audioData
//            self.format = format
//            
//            self.callback = completionHandler
            
        
    }
    
    /**
     Description
     
     - parameter data: PCM data
     
     - returns: Opus encoded audio
     */
    public func encodeOpus(data: NSData) -> NSData
    {
        
        let length: Int = data.length
        let chunkSize: Int = WATSON_AUDIO_FRAME_SIZE * 2
        var offset : Int = 0
        
        var ptr = UnsafeMutablePointer<UInt8>(data.bytes)
        
        repeat {
            let thisChunkSize = length - offset > chunkSize ? chunkSize : length - offset
            
            ptr += offset
            let chunk = NSData(bytesNoCopy: ptr, length: thisChunkSize, freeWhenDone: false)
            
            let compressed : NSData = opus.encode(chunk, frameSize: Int32(WATSON_AUDIO_FRAME_SIZE))
            
            if compressed.length != 0 {
                let newData = ogg.writePacket(compressed, frameSize: Int32(WATSON_AUDIO_FRAME_SIZE))
                
                if newData != nil {
                    // send to websocket
                    Log.sharedLogger.info("Writing a chunk with \(newData.length) bytes")
                }
            }
            
            offset += thisChunkSize
            
        } while offset < length
        
        let data = opus.encode(data, frameSize: Int32(WATSON_AUDIO_FRAME_SIZE))
        return data
    }

}

extension SpeechToText: WatsonSocketDelegate {
    
    func onConnected() {}
    func onListening() {}
    func onDisconnected() {}
    
    func onMessageReceived(result: SpeechToTextResponse) {
    
        callback?(result, nil)
    
    }

    
}





