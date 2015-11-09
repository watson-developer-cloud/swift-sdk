//
//  WatsonSpeechToTextError.swift
//  WatsonSpeechToText
//
//  Created by Glenn Fisher on 9/22/15.
//  Copyright © 2015 MIL. All rights reserved.
//

import Foundation

/**
Model Schema:

{
    "code": 0,
    "error": "",
    "help": ""
}

*/

public struct WatsonSpeechToTextError {
    
    let error: String
    let code: Int
    let codeDescription: String
    
    init(error: String, code: Int, codeDescription: String) {
        
        self.error = error
        self.code = code
        self.codeDescription = codeDescription
        
    }
    
}