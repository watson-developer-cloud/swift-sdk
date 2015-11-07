//
//  TextToSpeech.swift
//  WatsonTextToSpeech
//
//  Created by Robert Dickerson on 11/6/15.
//  Copyright © 2015 MIL. All rights reserved.
//

import Foundation
import AVFoundation

import WatsonCore

public protocol TextToSpeechService
{
    func synthesize ( )
    func listVoices ()
    func saveAudio ()
    func playAudio ()
}

public class TextToSpeech : Service
{
    let opus:OpusHelper = OpusHelper()
    
    private let serviceURL = "/text-to-speech/api/"
    
    public init() {
        super.init(serviceURL:serviceURL)
    }
    
}