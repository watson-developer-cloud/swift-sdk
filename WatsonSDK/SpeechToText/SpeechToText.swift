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
 * Implementation of the Watson speech to text service
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
    
    private func connectWebsocket() {
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
                    //socket.selfSignedSSL = true
                    socket.connect()
                    //socket.writePing(NSData())
                } else {
                    Log.sharedLogger.error("Socket could not be created")
                }
            } else {
                Log.sharedLogger.error("Could not get token from Watson")
            }
        }
    }
    
  
}

extension SpeechToText : WebSocketDelegate
{
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
        
        let result = Mapper<STTResponse>().map(text)
        
        if let callback = self.callback {
            
            if let result = result {
                
                if result.state == "listening" {
                    Log.sharedLogger.info("Speech recognition is listening")
                } else {
                    callback(text, nil)
                }
            }
        }
        // socket.disconnect()
    }
    
    public func websocketDidReceiveData(socket: WebSocket, data: NSData) {
        print("socket received data")
    }
}


extension SpeechToText : AVAudioRecorderDelegate
{
     public func audioRecorderDidFinishRecording( recorder: AVAudioRecorder,
        successfully flag: Bool) {
    
        
        print("Finished audio recording")
        
        
    }
}

extension SpeechToText : AVAudioSessionDelegate
{
    public func beginInterruption() {
        
    }
    
    public func inputIsAvailableChanged(isInputAvailable: Bool) {
        
    }
}