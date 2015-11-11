//
//  SpeechToText.swift
//  SpeechToText
//
//  Created by Glenn Fisher on 11/6/15.
//  Copyright © 2015 IBM Mobile Innovation Lab. All rights reserved.
//

import Foundation
import WatsonCore
import Starscream

public class SpeechToText: Service, WebSocketDelegate {
    
    private let serviceURL = "/speech-to-text/api"
    let url = "wss://stream.watsonplatform.net/speech-to-text/api/v1/recognize"
    var socket: WebSocket?
    
    public init(username: String, password: String) {
        super.init(type: .Streaming, serviceURL: serviceURL)
        self.setUsernameAndPassword(username, password: password)
    }
    
    public func transcribe(audio: NSURL, callback: (String?) -> Void) {
        
        let tokenURL = "https://stream.watsonplatform.net/authorization/api/v1/token"
        let serviceURLFull = "https://stream.watsonplatform.net/speech-to-text/api"
        NetworkUtils.requestAuthToken(tokenURL, serviceURL: serviceURLFull, apiKey: self._apiKey) {
            token, error in
            if let token = token {
                let authURL = "\(self.url)?watson-token=\(token)"
                self.socket = WebSocket(url: NSURL(string: authURL)!)
                if let socket = self.socket {
                    socket.delegate = self
                    socket.connect()
                }
            }
        }
    }
    
    public func websocketDidConnect(socket: WebSocket) {
        print("socket connected")
        socket.writeString("{\"action\": \"start\", \"content-type\": \"audio/flac\"}")
    }
    
    public func websocketDidDisconnect(socket: WebSocket, error: NSError?) {
        print("socket disconnected")
        print(error)
    }
    
    public func websocketDidReceiveMessage(socket: WebSocket, text: String) {
        print("socket received message")
        print(text)
        socket.disconnect()
    }
    
    public func websocketDidReceiveData(socket: WebSocket, data: NSData) {
        print("socket received data")
    }
}

        
//        let params = ["watson-token": token]
//        let socket = SocketIOClient(socketURL: url, options: [.Log(true), .ForcePolling(true), .ConnectParams(params)])
//        
//        socket.on("connect") {data, ack in
//            print("socket connected")
//            socket.emit("SetParams", ["{action: start, content-type: audio/flac}"])
//        }
//        
//        socket.on("currentAmount") {data, ack in
//            if let cur = data[0] as? Double {
//                socket.emitWithAck("canUpdate", cur)(timeoutAfter: 0) {data in
//                    socket.emit("update", ["amount": cur + 2.50])
//                }
//                
//                ack?.with("Got your currentAmount", "dude")
//            }
//        }
//        
//        socket.connect()