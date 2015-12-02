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

/// This class abstracts the network handling of sending messages through a websocket
public class WatsonSocket : Service {
    
    private let tokenURL = "https://stream.watsonplatform.net/authorization/api/v1/token"
    private let serviceURL = "/speech-to-text/api"
    private let serviceURLFull = "https://stream.watsonplatform.net/speech-to-text/api"
    private let url = "wss://stream.watsonplatform.net/speech-to-text/api/v1/recognize"
    
    var audioUploadQueue: NSOperationQueue!
    
    var format: SpeechToTextAudioFormat = .OGG
    
    var socket: WebSocket?

    init() {
        
        super.init(serviceURL: serviceURL)

        audioUploadQueue = NSOperationQueue()
        audioUploadQueue.name = "Audio upload"
        audioUploadQueue.maxConcurrentOperationCount = 1
        
        audioUploadQueue.suspended = true
        
        Log.sharedLogger.info("The auth token is \(self._apiKey)")
    }
    
    /**
     <#Description#>
     
     - parameter data: data description
     */
    public func send(data: NSData) {
        
        connectWebsocket()
        
        
            
        let uploadOp = AudioUploadOperation(data: data, watsonSocket: self)
        
        audioUploadQueue.addOperation(uploadOp)
        
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
        
        Log.sharedLogger.info("API key is: \(self._apiKey)")
        
        
        NetworkUtils.requestAuthToken(tokenURL,
            serviceURL: serviceURLFull,
            apiKey: self._apiKey) {
                
            token, error in
            
            if let error = error {
                Log.sharedLogger.error(error.localizedDescription)
            }
            
            Log.sharedLogger.info("Token is now \(token)")
                
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


extension WatsonSocket : WebSocketDelegate {
    /**
     Websocket callback when a web socket connection has been opened.
     
     - parameter socket: <#socket description#>
     */
    public func websocketDidConnect(socket: WebSocket) {
        
        Log.sharedLogger.info("Websocket connected")
        
        // socket.writeString("{\"action\": \"start\", \"content-type\": \"audio/flac\"}")
        
        let command : String = "{\"action\": \"start\", \"content-type\": \"\(self.format.rawValue)\"}"
        socket.writeString(command)
        
        audioUploadQueue.suspended = false
        
//        if let audioData = self.audioData {
//            
//            
//            Log.sharedLogger.info("Sending audio data through WebSocket")
//            socket.writeData(audioData)
//            
//            socket.writeString("{\"action\": \"stop\"}")
//            print("wrote audio data")
//            
//            
//        }
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
        
        Log.sharedLogger.info(result?.transcription())
        
//        if let callback = self.callback {
//            
//            if let result = result {
//                
//                if result.state == "listening" {
//                    
//                    Log.sharedLogger.info("Speech recognition is listening")
//                    
//                } else {
//                    
//                    callback(result, nil)
//                    
//                }
//            } else {
//                
//                callback(nil, NSError.createWatsonError(404, description: "Could not parse the received data"))
//                
//            }
//        } else {
//            Log.sharedLogger.warning("No callback has been defined for this request.")
//        }
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

/// Holds upload information
public class AudioUploadOperation : NSOperation {
    
    private let data: NSData!
    private let watsonSocket: WatsonSocket!
    
    public init(data: NSData, watsonSocket: WatsonSocket){
        self.data = data
        self.watsonSocket = watsonSocket
    }
    
    public override func main() {
        
        if self.cancelled {
            return
        }
        
        Log.sharedLogger.info("Uploading audio of length \(data.length)")
        
        
        
        // socket.writeData( data)
        
        // add to transcription queue
    }
}
