//
//  SpeechToText.swift
//  SpeechToText
//
//  Created by Glenn Fisher on 11/6/15.
//  Copyright © 2015 IBM Mobile Innovation Lab. All rights reserved.
//

import Foundation
import SocketIO

public class SpeechToText {
    
    public func transcribe(audio: NSURL, callback: (String?) -> Void) {
        let socket = SocketIOClient(socketURL: "localhost:8080", options: [.Log(true), .ForcePolling(true)])
        
        socket.on("connect") {data, ack in
            print("socket connected")
        }
        
        socket.on("currentAmount") {data, ack in
            if let cur = data[0] as? Double {
                socket.emitWithAck("canUpdate", cur)(timeoutAfter: 0) {data in
                    socket.emit("update", ["amount": cur + 2.50])
                }
                
                ack?.with("Got your currentAmount", "dude")
            }
        }
        
        socket.connect()
    }
}