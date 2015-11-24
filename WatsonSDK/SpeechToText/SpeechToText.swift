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
    
    private let WATSON_AUDIO_SAMPLE_RATE: Int32 = 16000
    private let WATSON_AUDIO_FRAME_SIZE: Int32 = 160
    
    var socket: WebSocket?
    var audio: NSURL?
    
    private let opus: OpusHelper = OpusHelper()
    
    // If set, contains the callback function after a transcription request.
    var callback: ((String?, NSError?) -> Void)?
    
    init() {
        
        super.init(serviceURL: serviceURL)
        
        opus.createEncoder(WATSON_AUDIO_SAMPLE_RATE)
        
    }
    
    /**
     This function takes audio data a returns a callback with the string transcription
     
     - parameter audio:    <#audio description#>
     - parameter callback: <#callback description#>
     */
    public func transcribe(audio: NSURL, callback: (String?, NSError?) -> Void) {
        
        connectWebsocket()
        self.audio = audio
        self.callback = callback
        
    }
    
    /**
     Description
     
     - parameter data: PCM data
     
     - returns: Opus encoded audio
     */
    public func encodeOpus(data: NSData) -> NSData
    {
        let data = opus.encode(data, frameSize: WATSON_AUDIO_FRAME_SIZE)
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
        print("socket connected")
        socket.writeString("{\"action\": \"start\", \"content-type\": \"audio/flac\"}")
        if let audio = self.audio {
            if let audioData = NSData(contentsOfURL: audio) {
                print("writing audio data")
                socket.writeData(audioData)
                socket.writeString("{\"action\": \"stop\"}")
                print("wrote audio data")
            }
        }
    }
    
    public func websocketDidDisconnect(socket: WebSocket, error: NSError?) {
        print("socket disconnected")
        print(error)
        
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
        print("socket received message")
        
        // parse the data.
        // print(text)
        
        let result = Mapper<SpeechToTextResponse>().map(text)
        
        if let callback = self.callback {
            
            if let result = result {
                
                if result.state == "listening" {
                    Log.sharedLogger.info("Speech recognition is listening")
                } else {
                    callback(text, nil)
                }
            } else {
                callback(nil, NSError.createWatsonError(404, description: "Could not parse the recieved data"))
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

// MARK: - <#AVAudioRecorderDelegate#>
extension SpeechToText : AVAudioRecorderDelegate
{
    /**
     This function gets invoked when the AVAudioPlayer has stopped recording. If the recording
     is successful, the audio is transcribed and the delegate's callback is invoked.
     
     - parameter recorder: <#recorder description#>
     - parameter flag:     flag description
     */
     public func audioRecorderDidFinishRecording( recorder: AVAudioRecorder,
        successfully flag: Bool) {
    
            let fileLocation = recorder.url.absoluteString
        
            let data = NSData(contentsOfFile: fileLocation)
       
            if let data = data {
                print("Finished audio recording \(fileLocation) length is \(data.length)" )
                
                // transcribe(<#T##audio: NSURL##NSURL#>, callback: <#T##(String?, NSError?) -> Void#>)
                
            } else {
                Log.sharedLogger.warning("Could not find file at \(fileLocation)")
            }
        
            
            
        
    }
}

// MARK: - <#AVAudioSessionDelegate#>
extension SpeechToText : AVAudioSessionDelegate
{
    public func beginInterruption() {
        
    }
    
    public func inputIsAvailableChanged(isInputAvailable: Bool) {
        
    }
}