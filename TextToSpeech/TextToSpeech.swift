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
    func synthesize ( theText:String )
    func listVoices ()
    func saveAudio ()
    func playAudio ()
}

public class TextToSpeech : Service, TextToSpeechService
{
    let opus:OpusHelper = OpusHelper()
    
    private let serviceURL = "/text-to-speech/api/"
    
    public init() {
        super.init(serviceURL:serviceURL)
    }
    
    public func synthesize(theText:String) {
        
        if let url = NSBundle(forClass: self.dynamicType).URLForResource("testing", withExtension: "opus") {
            if let data = NSData(contentsOfURL: url) {
        
                let pcm = opus.opusToPCM(data, sampleRate: 48000)
            
                print (pcm.length)
            }
        } else {
            print("Could not load the file")
        }
    }
    
    public func listVoices() {
       
    }
    
    public func saveAudio() {
        
    }
    
    public func playAudio() {
        
    }
    
}