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
import Starscream
import ObjectMapper

/**
    The IBM® Speech to Text service provides an Application Programming Interface (API) that
    enables you to add speech transcription capabilities to your applications.
*/
public class SpeechToText: Service {
    
    private let tokenURL = "https://stream.watsonplatform.net/authorization/api/v1/token"
    private let serviceURL = "/speech-to-text/api"
    private let serviceURLFull = "https://stream.watsonplatform.net/speech-to-text/api"
    private let url = "wss://stream.watsonplatform.net/speech-to-text/api/v1/recognize"
    
    public enum SpeechToTextAudioFormat: String {
        case OGG        = "audio/ogg;codecs=opus"
        case FLAC       = "audio/flac"
        case PCM        = "audio/l16"
        case WAV        = "audio/wav"
    }
    
    private let WATSON_AUDIO_SAMPLE_RATE = 16000
    private let WATSON_AUDIO_FRAME_SIZE = 160
    
    
    // NSOperationQueues
    var audioProcessingQueue: NSOperationQueue!
    // var transcriptionQueue: NSOperationQueue!
    
    public var delegate : SpeechToTextDelegate?
    
    var socket: WebSocket?
    
    private let opus: OpusHelper = OpusHelper()
    private let ogg: OggHelper = OggHelper()
    
    var format: SpeechToTextAudioFormat = .FLAC
    
    var audioData: NSData?
    
    // If set, contains the callback function after a transcription request.
    var callback: ((SpeechToTextResponse?, NSError?) -> Void)?
    
    
    
    
    init() {
        
        super.init(serviceURL: serviceURL)
        
        opus.createEncoder(Int32(WATSON_AUDIO_SAMPLE_RATE))
        
        audioProcessingQueue = NSOperationQueue()
        audioProcessingQueue.name = "Audio processing"
        audioProcessingQueue.maxConcurrentOperationCount = 1
        
    }
    
    public func startListening()
    {
        let NUM_BUFFERS = 2
        let BUFFER_SIZE:UInt32 = 4096
    
        var queue = AudioQueueRef()
        var buffers:[AudioQueueBufferRef] = [AudioQueueBufferRef(),
            AudioQueueBufferRef(),
            AudioQueueBufferRef()]
        
        var format = AudioStreamBasicDescription(
            mSampleRate: 16000,
            mFormatID: kAudioFormatLinearPCM,
            mFormatFlags: kLinearPCMFormatFlagIsSignedInteger | kLinearPCMFormatFlagIsPacked,
            mBytesPerPacket: 2,
            mFramesPerPacket: 1,
            mBytesPerFrame: 2,
            mChannelsPerFrame: 1,
            mBitsPerChannel: 8 * 2,
            mReserved: 0)
        
        AudioQueueNewInput(&format, recordCallback, nil,
            CFRunLoopGetCurrent(), kCFRunLoopCommonModes, 0, &queue)

        for index in 0...NUM_BUFFERS {
            AudioQueueAllocateBuffer(queue, BUFFER_SIZE, &buffers[index])
            //&buffers[index].maAudioDataByteSize = BUFFER_SIZE
            recordCallback(nil, queue, buffers[index], nil, 0, nil )
        }
        
        AudioQueueStart(queue, nil)
        CFRunLoopRun()
        
    }
    
    var recordCallback : AudioQueueInputCallback =
    {
         inUserData, inAQ, inBuffer, inStartTime, inNumberPacketDescriptions, inPacketDescs in
        
    
        print("inside of callback")
    }
    
    /**
     This function takes audio data a returns a callback with the string transcription
     
     - parameter audio:    <#audio description#>
     - parameter callback: A function that will return the string
     */
    public func transcribe(audioData: NSData,
        format: SpeechToTextAudioFormat = .FLAC,
        oncompletion: (SpeechToTextResponse?, NSError?) -> Void) {
        
            connectWebsocket()
        
           
            self.audioData = audioData
            self.format = format
            
            self.callback = oncompletion
            
        
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
    
    /**
     Establishes a Websocket connection if one does not exist already.
     */
    private func connectWebsocket() {
        
        // check to see if a connection has been established.
        if let socket = socket {
            
            if socket.isConnected {
                return
            }
        }
        
        
        NetworkUtils.requestAuthToken(tokenURL, serviceURL: serviceURLFull, apiKey: self._apiKey) {
            token, error in
            
            if let error = error {
                print(error)
            }
            
            if let token = token {
                
                //let authURL = "\(self.url)?watson-token=\(token)"
                let authURL = self.url
                self.socket = WebSocket(url: NSURL(string: authURL)!)
                if let socket = self.socket {
                    
                    socket.delegate = self
                    
                    socket.headers["X-Watson-Authorization-Token"] = token
                   
                    socket.connect()
                    
                } else {
                    Log.sharedLogger.error("Socket could not be created")
                }
            } else {
                Log.sharedLogger.error("Could not get token from Watson")
            }
        }
    }
    
  
}

// MARK: - <#WebSocketDelegate#>
extension SpeechToText : WebSocketDelegate
{
    
    /**
     Websocket callback when a web socket connection has been opened.
     
     - parameter socket: <#socket description#>
     */
    public func websocketDidConnect(socket: WebSocket) {
        
        Log.sharedLogger.info("Websocket connected")
        
        // socket.writeString("{\"action\": \"start\", \"content-type\": \"audio/flac\"}")
        
        let command : String = "{\"action\": \"start\", \"content-type\": \"\(self.format.rawValue)\"}"
        socket.writeString(command)
        
        if let audioData = self.audioData {
            
            
            Log.sharedLogger.info("Sending audio data through WebSocket")
            socket.writeData(audioData)
            
            socket.writeString("{\"action\": \"stop\"}")
            print("wrote audio data")
            
            
        }
    }
    
    public func websocketDidDisconnect(socket: WebSocket, error: NSError?) {
     
        Log.sharedLogger.info("Websocket disconnected")
        
        if let err = error {
            
            /**
            *  Sometimes the WebSocket cannot be elevated on the first couple of tries.
            */
            if err.code == 101 {
                connectWebsocket()
            } else {
                Log.sharedLogger.warning(err.localizedDescription)
            }
        }
    }
    
    public func websocketDidReceiveMessage(socket: WebSocket, text: String) {
        
        // parse the data.
        // print(text)
        
        let result = Mapper<SpeechToTextResponse>().map(text)
        
        if let callback = self.callback {
            
            if let result = result {
                
                if result.state == "listening" {
                    
                    Log.sharedLogger.info("Speech recognition is listening")
                    
                } else {
                    
                    callback(result, nil)
                    
                }
            } else {
                
                callback(nil, NSError.createWatsonError(404, description: "Could not parse the received data"))
                
            }
        } else {
            Log.sharedLogger.warning("No callback has been defined for this request.")
        }
        // socket.disconnect()
    }
    
    /**
     This function is invoked if the WebSocket receives binary data, which should never occur.
     
     - parameter socket: <#socket description#>
     - parameter data:   <#data description#>
     */
    public func websocketDidReceiveData(socket: WebSocket, data: NSData) {
        // print("socket received data")
        Log.sharedLogger.warning("Websocket received binary data")
    }
}

// MARK: - <#AVCaptureAudioDataOutput#>
extension SpeechToText : AVCaptureAudioDataOutputSampleBufferDelegate
{
    
    public func captureOutput(captureOutput: AVCaptureOutput!,
        didOutputSampleBuffer sampleBuffer: CMSampleBuffer!,
        fromConnection connection: AVCaptureConnection!) {
            
          
        
        let o1 = AudioProcessingOperation(data: NSData())
        let o2 = TranscriptionOperation()
            
        o2.addDependency(o1)
            
        audioProcessingQueue.addOperations([o1,o2], waitUntilFinished: true)
        
        
    }
    
}



public struct TranscriptionRequest
{
    var rawData: NSData?
    var compressedData: NSData?
    
    
}

public class AudioProcessingOperation : NSOperation {
    
    private var data: NSData!
    
    public init(data: NSData){
        self.data = data
        
    }
    
    public override func main() {
        
        if self.cancelled {
            return
        }
        
        // encode as opus
        
        // add to transcription queue
    }
}

public class TranscriptionOperation : NSOperation {
    
    public override init() {
    }
    
    public override func main() {
        if self.cancelled {
            return
        }
    }
}