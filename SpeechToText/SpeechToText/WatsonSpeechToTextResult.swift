//
//  WatsonSpeechToTextResult.swift
//  WatsonSpeechToText
//
//  Created by Glenn R. Fisher on 9/16/15.
//  Copyright © 2015 IBM Mobile Innovation Lab. All rights reserved.
//

import Foundation

/**
Model Schema:

{
    "result_index": 0,
    "results": [
        {
            "final": false,
            "alternatives": [
                {
                    "transcript": "",
                    "confidence": 0,
                    "timestamps": [
                        ""
                    ],
                    "word_confidence": [
                        ""
                    ]
                }
            ]
        }
    ]
}

*/

public struct WatsonSpeechToTextTranscription {
    
    let transcript: String
    let confidence: Double
    let timestamps: [NSDate]
    let wordConfidence: [Double]
    
}

public struct WatsonSpeechToTextResult {
    
    let final: Bool
    let alternatives: [WatsonSpeechToTextTranscription]
    
}

public struct WatsonSpeechToTextResults {
    
    let resultIndex: Int
    let results: [WatsonSpeechToTextResult]
    
    // todo: define convenience methods for accessing results
    // example: results.mostConfidentTranscription()
    
}