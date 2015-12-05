//
//  SpeechToTextConstants.swift
//  SpeechToText
//
//  Created by Glenn Fisher on 11/6/15.
//  Copyright © 2015 IBM Mobile Innovation Lab. All rights reserved.
//

import Foundation

public enum SpeechToTextAudioFormat: String {
    case OGG        = "audio/ogg;codecs=opus"
    case FLAC       = "audio/flac"
    case PCM        = "audio/l16"
    case WAV        = "audio/wav"
}