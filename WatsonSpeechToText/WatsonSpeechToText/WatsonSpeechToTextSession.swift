//
//  WatsonSpeechToTextSession.swift
//  WatsonSpeechToText
//
//  Created by Glenn Fisher on 9/22/15.
//  Copyright © 2015 MIL. All rights reserved.
//

import Foundation

public struct WatsonSpeechToTextSession {
    
    let sessionID: String
    let newSessionURI: String
    let recognize: String
    let recognizeWS: String
    let observeResult: String
    
    init(sessionID: String, newSessionURI: String, recognize: String, recognizeWS: String, observeResult: String) {
        
        self.sessionID = sessionID
        self.newSessionURI = newSessionURI
        self.recognize = recognize
        self.recognizeWS = recognizeWS
        self.observeResult = observeResult
        
    }
}