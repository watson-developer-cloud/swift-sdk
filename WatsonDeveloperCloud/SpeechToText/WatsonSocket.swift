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
    
/// Watson Web Socket abstraction
internal class WatsonSocket {
    
    private let tokenURL = "https://stream.watsonplatform.net/authorization/api/v1/token"
    private let serviceURL = "/speech-to-text/api"
    private let serviceURLFull = "https://stream.watsonplatform.net/speech-to-text/api"
    private let url = "wss://stream.watsonplatform.net/speech-to-text/api/v1/recognize"
    
    // Set this to receive updates about the websocket activity
    var delegate: WatsonSocketDelegate?
    
    var audioUploadQueue: NSOperationQueue!
    
    // The format for continuous PCM based recognition requires OGG
    var format: MediaType = .OPUS
    
    // Starscream websocket
    var socket: WebSocket?

    var authStrategy: AuthenticationStrategy!
    
    var isListening: Bool = false
    
    init(authStrategy: AuthenticationStrategy) {
    
        self.authStrategy = authStrategy
        
        audioUploadQueue = NSOperationQueue()
        audioUploadQueue.name = "Audio upload"
        audioUploadQueue.maxConcurrentOperationCount = 1
        
        // Wait until connection established before uploading samples
        audioUploadQueue.suspended = true
        
    }
    
    /**
     This function sends compressed audio frames for transcription by Watson
     
     - parameter data: Compressed audio frame
     */
    internal func send(data: NSData) {
        
        connectWebsocket()
        
        let uploadOp = AudioUploadOperation(data: data, watsonSocket: self)
        
        audioUploadQueue.addOperation(uploadOp)
        
    }
    
    internal func disconnect() {
        
        socket?.disconnect()
        
    }
    
        
    /**
     Establishes a Websocket connection if one does not exist already.
     */
    internal func connectWebsocket() {
        
        // check to see if a connection has been established.
//        if let socket = socket {
//            
//            if socket.isConnected {
//                return
//            }
//        }
        
        authStrategy.refreshToken({
      
            
            error in
            
            Log.sharedLogger.info("Got a response back from the server")
            
            if let token = self.authStrategy.token {
                
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
                
            }

            
        })
    }
}



// MARK: - <#WebSocketDelegate#>
extension WatsonSocket : WebSocketDelegate {
    
    /**
     Websocket callback when a web socket connection has been opened.
     
     - parameter socket: <#socket description#>
     */
    internal func websocketDidConnect(socket: WebSocket) {
        
        let command : String = "{\"action\": \"start\", \"content-type\": \"\(self.format.rawValue)\"}"
        socket.writeString(command)
        
        Log.sharedLogger.info("Sending \(command) through socket")
        
        audioUploadQueue.suspended = false
        
        delegate?.onConnected()
        
    }
    
    internal func websocketDidDisconnect(socket: WebSocket, error: NSError?) {
        
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
        
        audioUploadQueue.suspended = true
        isListening = false
        
        delegate?.onDisconnected()
    }
    
    internal func websocketDidReceiveMessage(socket: WebSocket, text: String) {
        
        // parse the data.
        // print(text)
        
        let result = Mapper<SpeechToText.SpeechToTextResponse>().map(text)
        
        Log.sharedLogger.info(result?.transcription())
        
            if let result = result {
                
                if result.state == "listening" {
                    
                    Log.sharedLogger.info("Speech recognition is listening")
                    
                    isListening = true
                    delegate?.onListening()
                    
                } else {
                    
                    if (result.results?.count > 0 ) {
                        delegate?.onMessageReceived(result)
                    }
                    // callback(result, nil)
                    
                }
            } else {
                
                Log.sharedLogger.error("Could not parse the response from the Websocket")
                
                //callback(nil, NSError.createWatsonError(404, description: "Could not parse the received data"))
                
            }
        
        // socket.disconnect()
    }
    
    /**
     This function is invoked if the WebSocket receives binary data, which should never occur.
     
     - parameter socket: <#socket description#>
     - parameter data:   <#data description#>
     */
    internal func websocketDidReceiveData(socket: WebSocket, data: NSData) {
        // print("socket received data")
        Log.sharedLogger.error("Websocket received binary data")
    }

}

/// Holds upload information
internal class AudioUploadOperation : NSOperation {
    
    private let data: NSData!
    private let watsonSocket: WatsonSocket!
    
    internal init(data: NSData, watsonSocket: WatsonSocket){
        
        self.data = data
        self.watsonSocket = watsonSocket
        
    }
    
    internal override func main() {
        
        if self.cancelled {
            return
        }
        
        Log.sharedLogger.info("Uploading audio of length \(data.length)")
        
        if let ws = watsonSocket.socket {
            ws.writeData(data)
            ws.writeString("{\"action\": \"stop\"}")
            
        } else {
            Log.sharedLogger.error("Websocket should be created")
        }
        
        // socket.writeData( data)
        
        // add to transcription queue
    }
}


