//
//  TextToSpeechAudio.swift
//  WatsonDeveloperCloud
//
//  Created by Sarah Chen on 1/23/17.
//  Copyright © 2017 Glenn R. Fisher. All rights reserved.
//

import Foundation

public struct TextToSpeechAudio {
    
    public let data: Data // raw data from TTS, in client-specified format
    public let format: AudioFormat // client-specified
    
    private let asWav: Data // converted to wav format (cache)
    
    
    
    private func transcodeToWav() {
        switch format {
        case .wav: break
        case .flac: break // do something
        case .l16:  break // do something?
        case .opus: decodeOpusToWav()
        }
    }
    
    private func decodeOpusToWav() {
        // this is the nasty bit (opus decoder)
        // pull opus data from ogg
            // 1. Pull page out from the stream (ogg_sync_pageout)
            // 2. Parse header to grab needed data (i.e. packet length, sample rate, output channels)
        // Check for comments header/metadata for file
        // Then handle the last part of data: opus audio data. (loop until end to build pcm to return).
            // Pull out pages
            // Parse page
            // call on final function opus_decode.
    }
    
    public func play() {
        // check format, if not .wav then transcode to wave
        // pass wave file to AVAudioPlayer
    }
    
}

//{ audio in audio.transcodeToWav() { wav in save(wav) } }
