//
//  SpeechToTextResult.swift
//  WatsonDeveloperCloud
//
//  Created by Glenn Fisher on 3/2/16.
//  Copyright © 2016 Glenn R. Fisher. All rights reserved.
//

import Foundation
import ObjectMapper

/** A recognition result from Speech to Text. */
public struct SpeechToTextResult: Mappable {

    /// If `true`, then the transcription result for this utterance is final and will not be
    /// updated further.
    public var final: Bool!

    /// Alternative transcription results.
    public var alternatives: [SpeechToTextTranscription]!

    /// A dictionary of spotted keywords and their associated matches. A keyword will have
    /// no associated matches if it was not found within the audio input or the threshold
    /// was set too high.
    public var keywordResults: [String: [SpeechToTextKeywordResult]]?

    /// A list of acoustically similar alternatives for words of the input audio.
    public var wordAlternatives: [SpeechToTextWordAlternativeResults]?

    /// Used internally to initialize a `SpeechToTextResult` from JSON.
    public init?(_ map: Map) { }

    /// Used internally to serialize and deserialize JSON.
    public mutating func mapping(map: Map) {
        final            <- map["final"]
        alternatives     <- map["alternatives"]
        keywordResults   <- map["keywords_result"]
        wordAlternatives <- map["word_alternatives"]
    }
}
