//
//  SpeechToTextWordAlternativeResult.swift
//  WatsonDeveloperCloud
//
//  Created by Glenn Fisher on 3/2/16.
//  Copyright © 2016 Glenn R. Fisher. All rights reserved.
//

import Foundation
import ObjectMapper

/** Alternative word hypotheses from Speech to Text for a word in the audio input. */
public struct SpeechToTextWordAlternativeResult {

    /// The confidence score of the alternative word hypothesis, between 0 and 1.
    public var confidence: Double!

    /// The alternative word hypothesis for a word in the audio input.
    public var word: String!

    /// Used internally to initialize a `WordAlternativeResult` from JSON.
    public init?(_ map: Map) { }

    /// Used internally to serialize and deserialize JSON.
    public mutating func mapping(map: Map) {
        confidence <- map["confidence"]
        word       <- map["word"]
    }
}
