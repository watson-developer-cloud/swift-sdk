//
//  SpeechToTextWordAlternativeResults.swift
//  WatsonDeveloperCloud
//
//  Created by Glenn Fisher on 3/2/16.
//  Copyright © 2016 Glenn R. Fisher. All rights reserved.
//

import Foundation
import ObjectMapper

/** A word alternative produced by Speech to Text. */
public struct SpeechToTextWordAlternativeResults {

    /// The time, in seconds, at which the word with alternative
    /// word hypotheses starts in the audio input.
    public var startTime: Double!

    /// The time, in seconds, at which the word with alternative
    /// word hypotheses ends in the audio input.
    public var endTime: Double!

    /// A list of alternative word hypotheses for a word in the audio input.
    public var alternatives: [SpeechToTextWordAlternativeResult]!

    /// Used internally to initialize a `WordAlternativeResults` from JSON.
    public init?(_ map: Map) { }

    /// Used internally to serialize and deserialize JSON.
    public mutating func mapping(map: Map) {
        startTime    <- map["start_time"]
        endTime      <- map["end_time"]
        alternatives <- map["alternatives"]
    }
}
