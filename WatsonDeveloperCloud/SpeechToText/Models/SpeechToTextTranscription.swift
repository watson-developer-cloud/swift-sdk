/**
 * Copyright IBM Corporation 2015
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 **/

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
    public var timestamps: [SpeechToTextWordTimestamp]?

    /// Confidence scores for each word of the transcript, between 0 and 1. Available only
    /// for the best alternative and only in results marked as final.
    public var wordConfidence: [SpeechToTextWordConfidence]?

    /// Used internally to initialize a `SpeechToTextTranscription` from JSON.
    public init?(_ map: Map) { }

    /// Used internally to serialize and deserialize JSON.
    public mutating func mapping(map: Map) {
        transcript     <-  map["transcript"]
        confidence     <-  map["confidence"]
        timestamps     <- (map["timestamps"], SpeechToTextWordTimestampTransform())
        wordConfidence <- (map["word_confidence"], SpeechToTextWordConfidenceTransform())
    }
}
