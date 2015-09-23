//
//  AudioUtils.swift
//  WatsonTextToSpeech
//
//  Created by Robert Dickerson on 9/16/15.
//  Copyright © 2015 IBM Mobile Innovation Lab. All rights reserved.
//

import Foundation
import AVFoundation
import CoreAudio


let debug = true

/** 
Holds some information for Audio PCM floats
*/
public struct SpeechAudio
{
    let numChannels:Int
    var samples:[Float32]
    
    public init(numChannels: Int, samples: [Float32])
    {
        self.numChannels = numChannels
        self.samples = samples
    }
}

/**
Converts 4 little-endian bytes to an Int
 - parameter a: lowest significant byte
 - parameter b: 2nd lowest order byte
 - parameter c: 3rd lowest order byte
 - parameter d: most significant byte
 - returns: an integer representing the byte array
*/
private func bytesToInt(a: UInt8, b: UInt8, c: UInt8, d: UInt8) -> Int {
    let c1 = Int(a)
    let c2 = Int(b)<<8
    let c3 = Int(c)<<16
    let c4 = Int(d)<<32
    
    return c1+c2+c3+c4
}

/**
Converts 2 bytes little-endian to a 32 bit float
 - parameter firstByte: lowest significant byte
 - parameter secondByte: highest signifiant byte
 - returns: a 32 bit float approximation representing the byte array
*/
private func bytesToDouble(firstByte: UInt8, secondByte: UInt8) -> Float32 {
    let c:Int16 = Int16(secondByte) << 8 | Int16(firstByte)
    return Float32(c)/Float32(Int16.max)
}

/**
Converts a downloaded binary WAV to a SpeechAudio structure
 - parameter data: NSData binary for the WAV file
 - returns: a SpeechAudio structure with audio data and information
*/
public func createPCM(data: NSData) -> SpeechAudio
{
    
    let count = data.length / sizeof(UInt8)
    
    var buffer = [UInt8](count: count, repeatedValue: 6)
    
    data.getBytes(&buffer, length: count * sizeof(UInt8))
    
    if debug {
        print ("Number of channels is \(buffer[22])")
    }
    
    // 4 byte RIFF
    // 4 byte chunk size
    // 4 byte WAVE ID
    var pos = 0
    
    if buffer[0] == 82 && buffer[1] == 73 && buffer[2] == 70 && buffer[3] == 70 && debug
    {
        print("Got RIFF header!")
    }
    
    // reports 255,255,255,255 - should be chunk size
    let chunkSize = bytesToInt(buffer[4], b: buffer[5], c: buffer[6], d: buffer[7])
    print ("Chunk size is \(chunkSize)")
    
    pos = 12
    
    
    let sampleRate = bytesToInt(buffer[24], b: buffer[25], c: buffer[26], d: buffer[27])
    
    let byteRate = bytesToInt(buffer[28], b: buffer[29], c: buffer[30], d: buffer[31])
    
    let blockAlign = bytesToInt(buffer[32], b: buffer[33], c: 0, d: 0)
    
    let bitsPerSample = bytesToInt(buffer[34], b: buffer[35], c: 0, d: 0)
    
    let subchunkSize = bytesToInt(buffer[40], b: buffer[41], c: buffer[42], d: buffer[43])
    
    let numSamples : Int = (buffer.count - 44)/2
    
    if debug {
        print ("Sample rate: \(sampleRate)")
        print ("Byte rate \(byteRate)")
        print ("Block alignment is \(blockAlign)")
        print ("BitsPerSample is \(bitsPerSample)")
        print ("subchunkSize is \(subchunkSize)")
        print ("Number of samples is \(numSamples)")
        
        if buffer[16] == 16
        {
            print ("PCM Format")
        } else {
            print ("Compressed format")
        }

    }
    
    pos = 0
    var i = 0
    
    
    var pcmbuffer = [Float32](count: numSamples, repeatedValue: 0.0)
    while (i < numSamples) {
        
        let value = bytesToDouble(buffer[pos], secondByte: buffer[pos+1])
        
        // 100 = d, 97=a, 116=t, 97=a
        if (pos%26==0)
        {
            // print("Subchunk boundary")
            
        }
        
        pcmbuffer[i] = value
        
        i++
        
        pos+=2
        
    }
    
    return SpeechAudio(numChannels: 1, samples: pcmbuffer)
    
}

/**
Plays an audio segment using lower-level audio engine
 - parameter engine: AVAudioEngine that has been initialized and outside the scope of the function for threading
 - parameter audioSegment: SpeechAudio structure that holds the data to play
 - parameter delegate: a protocol that can be invoked when the speech has finished playing
*/
public func playAudioPCM (engine: AVAudioEngine, audioSegment: SpeechAudio, delegate: TextToSpeechServiceDelegate?)
{
    
    
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
    
    engine.attachNode(audioPlayer)
    // Runtime error occurs here:
    engine.connect(audioPlayer, to: engine.mainMixerNode, format: format)
    
    do {
        
        try engine.start()
        
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
