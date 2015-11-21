//
//  SpeechToText.swift
//  SpeechToText
//
//  Created by Glenn Fisher on 11/6/15.
//  Copyright © 2015 IBM Mobile Innovation Lab. All rights reserved.
//

import Foundation
import Starscream
import ObjectMapper

public class SpeechToText: Service, WebSocketDelegate {
    
    private let tokenURL = "https://stream.watsonplatform.net/authorization/api/v1/token"
    private let serviceURL = "/speech-to-text/api"
    private let serviceURLFull = "https://stream.watsonplatform.net/speech-to-text/api"
    private let url = "wss://stream.watsonplatform.net/speech-to-text/api/v1/recognize"
    var socket: WebSocket?
    var audio: NSURL?
    
    var callback: ((String?, NSError?) -> Void)?
    
    init() {
        super.init(serviceURL: serviceURL)
    }
    
    public func transcribe(audio: NSURL, callback: (String?, NSError?) -> Void) {
        connectWebsocket()
        self.audio = audio
        self.callback = callback
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
                callback(text, nil)
            }
        }
        // socket.disconnect()
    }
    
    public func websocketDidReceiveData(socket: WebSocket, data: NSData) {
        print("socket received data")
    }
}