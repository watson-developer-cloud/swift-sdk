//
//  WatsonSpeechToTextDelegate.swift
//  WatsonSpeechToText
//
//  Created by Glenn Fisher on 9/23/15.
//  Copyright © 2015 MIL. All rights reserved.
//

import Foundation

public protocol WatsonSpeechToTextDelegate {
    
    func didReceiveInterimResults(results: WatsonSpeechToTextResults?, error: WatsonSpeechToTextError?)
    
}