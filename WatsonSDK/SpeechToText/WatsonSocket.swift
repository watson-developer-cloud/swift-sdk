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
    
    var audioUploadQueue: NSOperationQueue!
    
    // The format for continuous PCM based recognition requires OGG
    var format: SpeechToTextAudioFormat = .OGG
    
    // Starscream websocket
    var socket: WebSocket?

    // The Basic authentication Base64 request
    internal var apiKey: String?
    
    internal var username: String?
    internal var password: String?
    
    /** If set, will use the username and password specified to generate Watson Token
      Normally, a token should be provided.
    */
    internal var generateToken: Bool = true
    
    // The received token from Watson
    internal var token: String?
    
    init() {
    
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
    
    /**
     Fetches a token that is valid for 1 hr.
     
     - parameter username:     Watson generated username
     - parameter password:     Watson generated password
     - parameter oncompletion: completion block for when a token is sent by server
     */
    internal func getToken( username: String, password: String,
        oncompletion: (String?, NSError?) -> Void)
    {
        let authorizationString = username + ":" + password
        let apiKey = "Basic " + (authorizationString.dataUsingEncoding(NSASCIIStringEncoding)?.base64EncodedStringWithOptions(NSDataBase64EncodingOptions.Encoding76CharacterLineLength))!
        
        NetworkUtils.requestAuthToken(tokenURL, serviceURL: serviceURLFull,
            apiKey: apiKey, completionHandler: {
            
            token, error in
            
            Log.sharedLogger.info("Token received was \(token)")
                
            self.token = token
                
            oncompletion(token, error)
        })
        
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
        
        if (username == nil || password == nil)
        {
            Log.sharedLogger.error("API key was not set")
            return
        }
        
        getToken(username!, password: password!, oncompletion: {
            token, error in
            
            Log.sharedLogger.info("Got a response back from the server")
            
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
    }
    
    internal func websocketDidReceiveMessage(socket: WebSocket, text: String) {
        
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
    internal func websocketDidReceiveData(socket: WebSocket, data: NSData) {
        // print("socket received data")
        Log.sharedLogger.warning("Websocket received binary data")
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
        
        
        
        // socket.writeData( data)
        
        // add to transcription queue
    }
}


