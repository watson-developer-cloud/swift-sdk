//
//  AudioUtils.swift
//  WatsonTextToSpeech
//
//  Created by Glenn Fisher on 9/16/15.
//  Copyright © 2015 MIL. All rights reserved.
//

import Foundation
import AVFoundation
import CoreAudio


// holds some information for Audio PCM floats
public struct SpeechAudio
{
    let numChannels:Int
    // let bitsPerSample:Int
    var samples:[Float32]
    
    public init(numChannels: Int, samples: [Float32])
    {
        self.numChannels = numChannels
        self.samples = samples
    }
}

private func bytesToInt(a: UInt8, b: UInt8, c: UInt8, d: UInt8) -> Int
{
    let c1 = Int(a)
    let c2 = Int(b)<<8
    let c3 = Int(c)<<16
    let c4 = Int(d)<<32
    
    return c1+c2+c3+c4
}

private func bytesToDouble(firstByte: UInt8, secondByte: UInt8) -> Float32
{
    let c:Int16 = Int16(secondByte) << 8 | Int16(firstByte)
    return Float32(c)/Float32(Int16.max)
}

public func createPCM(data: NSData) -> SpeechAudio
{
    // using example from http://stackoverflow.com/questions/8754111/how-to-read-the-data-in-a-wav-file-to-an-array
    
    let count = data.length / sizeof(UInt8)
    
    var buffer = [UInt8](count: count, repeatedValue: 6)
    
    data.getBytes(&buffer, length: count * sizeof(UInt8))
    
    print ("Number of channels is \(buffer[22])")
    
    // 4 byte RIFF
    // 4 byte chunk size
    // 4 byte WAVE ID
    var pos = 0
    
    if buffer[0] == 82 && buffer[1] == 73 && buffer[2] == 70 && buffer[3] == 70
    {
        print("Got RIFF header!")
    }
    
    // reports 255,255,255,255 - should be chunk size
    let chunkSize = bytesToInt(buffer[4], b: buffer[5], c: buffer[6], d: buffer[7])
    print ("Chunk size is \(chunkSize)")
    
    pos = 12
    
    if buffer[16] == 16
    {
        print ("PCM Format")
    } else {
        print ("Compressed format")
    }
    
    let sampleRate = bytesToInt(buffer[24], b: buffer[25], c: buffer[26], d: buffer[27])
    print ("Sample rate: \(sampleRate)")
    
    // sampleRate * numChannels * bitsPerSample
    let byteRate = bytesToInt(buffer[28], b: buffer[29], c: buffer[30], d: buffer[31])
    print ("Byte rate \(byteRate)")
    
    // block align = NumChannels * bytesPerSample
    let blockAlign = bytesToInt(buffer[32], b: buffer[33], c: 0, d: 0)
    print ("Block alignment is \(blockAlign)")
    
    // bitsPerSample
    let bitsPerSample = bytesToInt(buffer[34], b: buffer[35], c: 0, d: 0)
    print ("BitsPerSample is \(bitsPerSample)")
    
    // subchunkSize
    let subchunkSize = bytesToInt(buffer[40], b: buffer[41], c: buffer[42], d: buffer[43])
    print ("subchunkSize is \(subchunkSize)")
    
    /**
    while (!(buffer[pos]==100 && buffer[pos+1]==97 && buffer[pos+2]==116))
    {
    pos += 4
    let c1 : Int = Int(buffer[pos])
    let c2 : Int = Int(buffer[pos+1])<<8
    let c3 : Int = Int(buffer[pos+2])<<16
    let c4 : Int = Int(buffer[pos+3])<<32
    
    let chunkSize = c1 + c2 + c3 + c4
    
    pos += 4 + chunkSize
    }
    
    pos += 8
    
    **/
    
    let numSamples : Int = (buffer.count - 44)/2
    print ("Number of samples is \(numSamples)")
    
    pos = 0
    var i = 0
    
    
    var pcmbuffer = [Float32](count: numSamples, repeatedValue: 0.0)
    while (i < numSamples) {
        
        // pcmbuffer[i] = bytesToDouble(buffer[pos], secondByte: buffer[pos+1])
        let value = bytesToDouble(buffer[pos], secondByte: buffer[pos+1])
        
        // 100 = d, 97=a, 116=t, 97=a
        if (pos%26==0)
        {
            print("Subchunk boundary")
            
        }
        
        pcmbuffer[i] = value
        
        i++
        
        pos+=2
        
    }
    
    // return NSData(bytes: pcmbuffer, length: numSamples)
    return SpeechAudio(numChannels: 1, samples: pcmbuffer)
    
}

// Used as a reference:
// http://stackoverflow.com/questions/28058777/generating-a-tone-in-ios-with-16-bit-pcm-audioengine-connect-throws-ausetform
public func playAudioPCM (engine: AVAudioEngine, audioSegment: SpeechAudio)
{
    
    
    let sampleRateHz = 22050.0
    // let numberOfSamples = data.length
    // let durationMs = 5000
    
    // let mixer = engine.mainMixerNode
    // let sampleRateHz: Float = Float(mixer.outputFormatForBus(0).sampleRate)
    // let numberOfSamples = AVAudioFrameCount((Float(durationMs) / 1000 * sampleRateHz))
    let numberOfSamples = AVAudioFrameCount(audioSegment.samples.count)
    
    // support stereo? make parameterizable
    let format = AVAudioFormat(commonFormat: AVAudioCommonFormat.PCMFormatFloat32, sampleRate: Double(sampleRateHz),
        channels: AVAudioChannelCount(1),
        interleaved: false)
    
    let buffer = AVAudioPCMBuffer(PCMFormat: format, frameCapacity: numberOfSamples)
    buffer.frameLength = numberOfSamples
    
    //var pos: Int = 0
    
    for pos in 0...audioSegment.samples.count-1
    {
        buffer.floatChannelData.memory[pos] = audioSegment.samples[pos]
    }
    
    
    // let audioEngine = AVAudioEngine()
    let audioPlayer = AVAudioPlayerNode()
    
    engine.attachNode(audioPlayer)
    // Runtime error occurs here:
    engine.connect(audioPlayer, to: engine.mainMixerNode, format: format)
    
    do {
        
        try engine.start()
        
        audioPlayer.play()
        audioPlayer.scheduleBuffer(buffer, atTime: nil, options: AVAudioPlayerNodeBufferOptions.Interrupts, completionHandler: nil)
        
    } catch {
        // Log if an exception
    }
    
    
    
}
