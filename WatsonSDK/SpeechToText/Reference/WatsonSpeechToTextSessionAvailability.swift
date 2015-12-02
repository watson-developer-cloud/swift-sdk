//
//  WatsonSpeechToTextSessionAvailability.swift
//  WatsonSpeechToText
//
//  Created by Glenn Fisher on 9/23/15.
//  Copyright © 2015 MIL. All rights reserved.
//

import Foundation

/**

Model Schema:

{
    "session": {
        "state": "",
        "model": "",
        "recognize": "",
        "observe_result": ""
    }
}

*/

public struct WatsonSpeechToTextSessionAvailability {
    
    let state: String
    let model: String
    let recognize: String
    let observeResult: String
    
    init(state: String, model: String, recognize: String, observeResult: String) {
        self.state = state
        self.model = model
        self.recognize = recognize
        self.observeResult = observeResult
    }
    
    // todo: add convenience methods for checking session availability
    // example: session.isAvailable()
    
}