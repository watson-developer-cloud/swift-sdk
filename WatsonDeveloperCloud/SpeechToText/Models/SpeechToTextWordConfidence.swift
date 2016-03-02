//
//  SpeechToTextWordConfidence.swift
//  WatsonDeveloperCloud
//
//  Created by Glenn Fisher on 3/2/16.
//  Copyright © 2016 Glenn R. Fisher. All rights reserved.
//

import Foundation
import ObjectMapper

/** The confidence of a word in a Speech to Text transcription. */
public struct SpeechToTextWordConfidence {

    /// A particular word from the transcript of the utterance.
    public var word: String!

    /// The confidence of the given word, between 0 and 1.
    public var confidence: Double!
    
}
