//
//  AudioUtils.swift
//  TextToSpeech
//
//  Created by Robert Dickerson on 11/11/15.
//  Copyright © 2015 Watson Developer Cloud. All rights reserved.
//

import Foundation

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
public func createPCMFromWAV(data: NSData) -> [Float32]
{
    
    let count = data.length / sizeof(UInt8)
    
    var buffer = [UInt8](count: count, repeatedValue: 6)
    
    data.getBytes(&buffer, length: count * sizeof(UInt8))
    

    Log.sharedLogger.warning("Number of channels is \(buffer[22])")
    
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
    
    
    // let subchunkSize = bytesToInt(buffer[40], b: buffer[41], c: buffer[42], d: buffer[43])
    
    let numSamples : Int = (buffer.count - 44)/2
    
    
        if buffer[16] == 16
        {
            print ("PCM Format")
        } else {
            print ("Compressed format")
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
    
    return pcmbuffer
}
