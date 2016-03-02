//
//  SpeechToTextKeywordResult.swift
//  WatsonDeveloperCloud
//
//  Created by Glenn Fisher on 3/2/16.
//  Copyright © 2016 Glenn R. Fisher. All rights reserved.
//

import Foundation
import ObjectMapper

/** A keyword identified by Speech to Text. */
public struct SpeechToTextKeywordResult {

    /// The specified keyword normalized to the spoken phrase that matched in the audio input.
    public var normalizedText: String!

    /// The start time, in seconds, of the keyword match.
    public var startTime: Double!

    /// The end time, in seconds, of the keyword match.
    public var endTime: Double!

    /// The confidence score of the keyword match, between 0 and 1. The confidence must be at
    /// least as great as the specified threshold to be included in the results.
    public var confidence: Double!

    /// Used internally to initialize a `KeywordResult` from JSON.
    public init?(_ map: Map) { }

    /// Used internally to serialize and deserialize JSON.
    public mutating func mapping(map: Map) {
        normalizedText <- map["normalized_text"]
        startTime      <- map["start_time"]
        endTime        <- map["end_time"]
        confidence     <- map["confidence"]
    }
}
