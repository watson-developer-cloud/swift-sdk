//
//  TextToSpeech.swift
//  WatsonTextToSpeech
//
//  Created by Robert Dickerson on 11/6/15.
//  Copyright © 2015 MIL. All rights reserved.
//

import Foundation
import AVFoundation
import ObjectMapper

import WatsonCore


public protocol TextToSpeechService
{
    func synthesize ( theText:String, oncompletion: (data: NSData?, error:NSError?) -> Void )
    
    func listVoices ( oncompletion: (voices: [Voice], error:NSError?) -> Void )
    
    func saveAudio ( location: NSURL, data: NSData )
    
    func playAudio ( audioEngine: AVAudioEngine, data: NSData )
    
}

public class TextToSpeech : Service, TextToSpeechService
{
    let opus:OpusHelper = OpusHelper()
    
    private let _serviceURL = "/text-to-speech/api"
    private let DEFAULT_SAMPLE_RATE = 24000
    
    public init() {
        
        super.init(type: .Streaming, serviceURL: _serviceURL)
       
    }
    
    public func synthesize(theText:String, oncompletion: (data: NSData?, error:NSError?) -> Void ) {
        
        let endpoint = getEndpoint("/v1/synthesize")
        
        var params = Dictionary<String, String>()
        params.updateValue(theText, forKey: "text")
        //params.updateValue("audio/ogg; codecs=opus", forKey: "accept")
        
        NetworkUtils.performBasicAuthRequest(endpoint, method: .GET,
            parameters: params,
            contentType: .AUDIO_OPUS,
            accept: .AUDIO_OPUS,
            apiKey: _apiKey,
            completionHandler: {
            
            response in
                
                if let data = response.data as? NSData {
                    
                    // Use codec to decompress the audio
                    let pcm = self.opus.opusToPCM(data, sampleRate: self.DEFAULT_SAMPLE_RATE)
                    
                    oncompletion(data: pcm, error: response.error)
                } else {
                    oncompletion(data: nil, error: response.error)
                }
            
        })
        
//        if let url = NSBundle(forClass: self.dynamicType).URLForResource("testing", withExtension: "opus") {
//            if let data = NSData(contentsOfURL: url) {
//        
//                let pcm = opus.opusToPCM(data, sampleRate: 48000)
//            
//                print (pcm.length)
//            }
//        } else {
//            print("Could not load the file")
//        }
        
        
        
        
    }
    
    public func listVoices ( oncompletion: (voices: [Voice], error:NSError?) -> Void ) {
        let endpoint = getEndpoint("/v1/voices")
        
        NetworkUtils.performBasicAuthRequest(endpoint, apiKey: _apiKey, completionHandler: {response in
            
            var voices : [Voice] = []
            
            if case let data as Dictionary<String, AnyObject> = response.data {
                
                if case let rawVoices as [AnyObject] = data["voices"]
                {
                    for rawVoice in rawVoices {
                        if let voice = Mapper<Voice>().map(rawVoice) {
                            voices.append(voice)
                        }
                    }
                }
                
            }
           
            
            oncompletion(voices: voices, error: response.error)
        })

    }
    
    public func saveAudio ( location: NSURL, data: NSData ) {
        
    }
    
    public func playAudio( audioEngine: AVAudioEngine, data: NSData ) {
        
//        let sampleRateHz = 22050.0
//        
//        let numberOfSamples = AVAudioFrameCount(audioSegment.samples.count)
//        
//        // support stereo? make parameterizable
//        let format = AVAudioFormat(commonFormat: AVAudioCommonFormat.PCMFormatFloat32, sampleRate: Double(sampleRateHz),
//            channels: AVAudioChannelCount(1),
//            interleaved: false)
//        
//        let buffer = AVAudioPCMBuffer(PCMFormat: format, frameCapacity: numberOfSamples)
//        buffer.frameLength = numberOfSamples
//        
//        for pos in 0...audioSegment.samples.count-1
//        {
//            buffer.floatChannelData.memory[pos] = audioSegment.samples[pos]
//        }
//        
//        let audioPlayer = AVAudioPlayerNode()
//        
//        audioEngine.attachNode(audioPlayer)
//        // Runtime error occurs here:
//        audioEngine.connect(audioPlayer, to: audioEngine.mainMixerNode, format: format)
//        
//        do {
//            
//            // might not have to start this here.
//            try audioEngine.start()
//            
//            audioPlayer.play()
//            audioPlayer.scheduleBuffer(buffer, atTime: nil, options: AVAudioPlayerNodeBufferOptions.Interrupts, completionHandler: {
//                
//                
//                if let delegate = delegate {
//                    delegate.speechDidPlay()
//                }
//                
//            })
//            
//        } catch {
//            
//            print("Problem playing the audio")
//        }

    }
    
    // Websocket handlers
    
 

    
    
}