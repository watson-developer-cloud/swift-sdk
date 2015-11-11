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

public typealias CompletionNSDataBlock = ( data: NSData?, error: NSError?) -> Void

public protocol TextToSpeechService
{
    func synthesize ( theText:String, oncompletion: (data: NSData?, error:NSError?) -> Void )
    
    func listVoices ( oncompletion: (voices: [String], error:NSError?) -> Void )
    
    func saveAudio ( location: NSURL, data: NSData )
    
    func playAudio ( audioEngine: AVAudioEngine, data: NSData )
    
}

public class TextToSpeech : Service, TextToSpeechService
{
    let opus:OpusHelper = OpusHelper()
    
    private let serviceURL = "/text-to-speech/api/"
    
    public init() {
        super.init(serviceURL:serviceURL)
    }
    
    public func synthesize(theText:String, oncompletion: (data: NSData?, error:NSError?) -> Void ) {
        
        if let url = NSBundle(forClass: self.dynamicType).URLForResource("testing", withExtension: "opus") {
            if let data = NSData(contentsOfURL: url) {
        
                let pcm = opus.opusToPCM(data, sampleRate: 48000)
            
                print (pcm.length)
            }
        } else {
            print("Could not load the file")
        }
        
        
        
        oncompletion =
    }
    
    public func listVoices ( oncompletion: (voices: [String], error:NSError?) -> Void ) {
    
    }
    
    public func saveAudio ( location: NSURL, data: NSData ) {
        
    }
    
    public func playAudio( audioEngine: AVAudioEngine, data: NSData ) {
        
        let sampleRateHz = 22050.0
        
        let numberOfSamples = AVAudioFrameCount(audioSegment.samples.count)
        
        // support stereo? make parameterizable
        let format = AVAudioFormat(commonFormat: AVAudioCommonFormat.PCMFormatFloat32, sampleRate: Double(sampleRateHz),
            channels: AVAudioChannelCount(1),
            interleaved: false)
        
        let buffer = AVAudioPCMBuffer(PCMFormat: format, frameCapacity: numberOfSamples)
        buffer.frameLength = numberOfSamples
        
        for pos in 0...audioSegment.samples.count-1
        {
            buffer.floatChannelData.memory[pos] = audioSegment.samples[pos]
        }
        
        let audioPlayer = AVAudioPlayerNode()
        
        audioEngine.attachNode(audioPlayer)
        // Runtime error occurs here:
        audioEngine.connect(audioPlayer, to: audioEngine.mainMixerNode, format: format)
        
        do {
            
            // might not have to start this here.
            try audioEngine.start()
            
            audioPlayer.play()
            audioPlayer.scheduleBuffer(buffer, atTime: nil, options: AVAudioPlayerNodeBufferOptions.Interrupts, completionHandler: {
                
                
                if let delegate = delegate {
                    delegate.speechDidPlay()
                }
                
            })
            
        } catch {
            
            print("Problem playing the audio")
        }

    }
    
}