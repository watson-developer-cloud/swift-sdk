//
//  SpeechToTextWordTimestamp.swift
//  WatsonDeveloperCloud
//
//  Created by Glenn Fisher on 3/2/16.
//  Copyright © 2016 Glenn R. Fisher. All rights reserved.
//

import Foundation
import ObjectMapper

/** The timestamp of a word in a Speech to Text transcription. */
public struct SpeechToTextWordTimestamp {

    /// A particular word from the transcript of the utterance.
    public var word: String!

    /// The start time, in seconds, of the given word in the audio input.
    public var startTime: Double!

    /// The end time, in seconds, of the given word in the audio input.
    public var endTime: Double!
    
}
