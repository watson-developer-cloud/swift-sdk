//
//  SpeechToTextDelegate.swift
//  WatsonSDK
//
//  Created by Robert Dickerson on 11/26/15.
//  Copyright © 2015 IBM Watson Developer Cloud. All rights reserved.
//

import Foundation

public protocol SpeechToTextDelegate {
    
    func onSpeechRecognized(text: String)
    
}