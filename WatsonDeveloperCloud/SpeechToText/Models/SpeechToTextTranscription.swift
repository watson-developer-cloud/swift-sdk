//
//  SpeechToTextTranscription.swift
//  WatsonDeveloperCloud
//
//  Created by Glenn Fisher on 3/2/16.
//  Copyright © 2016 Glenn R. Fisher. All rights reserved.
//

import Foundation
import ObjectMapper

/** A transcription alternative produced by Speech to Text. */
public struct SpeechToTextTranscription: Mappable {

    /// A transcript of the utterance.
    public var transcript: String!

    /// The confidence score of the transcript, between 0 and 1. Available only for the best
    /// alternative and only in results marked as final.
    public var confidence: Double?

    /// Timestamps for each word of the transcript.
    public var timestamps: [SpeechToTextWordTimestamp]? // TODO: needs transform from ["word", 0.1, 0.2] to WordTimestamp object...

    /// Confidence scores for each word of the transcript, between 0 and 1. Available only
    /// for the best alternative and only in results marked as final.
    public var wordConfidence: [SpeechToTextWordConfidence]? // TODO: needs a transform from ["hello", 0.95] to WordConfidence object...

    /// Used internally to initialize a `SpeechRecognitionAlternative` from JSON.
    public init?(_ map: Map) { }

    /// Used internally to serialize and deserialize JSON.
    public mutating func mapping(map: Map) {
        transcript     <- map["transcript"]
        confidence     <- map["confidence"]
        timestamps     <- map["timestamps"]
        wordConfidence <- map["word_confidence"]
    }
}
