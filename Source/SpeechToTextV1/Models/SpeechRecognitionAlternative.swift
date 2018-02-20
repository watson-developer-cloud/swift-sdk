/**
 * Copyright IBM Corporation 2018
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

/** SpeechRecognitionAlternative. */
public struct SpeechRecognitionAlternative {

    /// A transcription of the audio.
    public var transcript: String

    /// A score that indicates the service's confidence in the transcript in the range of 0 to 1. Available only for the best alternative and only in results marked as final.
    public var confidence: Double?

    /// Time alignments for each word from the transcript as a list of lists. Each inner list consists of three elements: the word followed by its start and end time in seconds. Example: `[["hello",0.0,1.2],["world",1.2,2.5]]`. Available only for the best alternative.
    public var timestamps: [String]?

    /// A confidence score for each word of the transcript as a list of lists. Each inner list consists of two elements: the word and its confidence score in the range of 0 to 1. Example: `[["hello",0.95],["world",0.866]]`. Available only for the best alternative and only in results marked as final.
    public var wordConfidence: [String]?

    /**
     Initialize a `SpeechRecognitionAlternative` with member variables.

     - parameter transcript: A transcription of the audio.
     - parameter confidence: A score that indicates the service's confidence in the transcript in the range of 0 to 1. Available only for the best alternative and only in results marked as final.
     - parameter timestamps: Time alignments for each word from the transcript as a list of lists. Each inner list consists of three elements: the word followed by its start and end time in seconds. Example: `[["hello",0.0,1.2],["world",1.2,2.5]]`. Available only for the best alternative.
     - parameter wordConfidence: A confidence score for each word of the transcript as a list of lists. Each inner list consists of two elements: the word and its confidence score in the range of 0 to 1. Example: `[["hello",0.95],["world",0.866]]`. Available only for the best alternative and only in results marked as final.

     - returns: An initialized `SpeechRecognitionAlternative`.
    */
    public init(transcript: String, confidence: Double? = nil, timestamps: [String]? = nil, wordConfidence: [String]? = nil) {
        self.transcript = transcript
        self.confidence = confidence
        self.timestamps = timestamps
        self.wordConfidence = wordConfidence
    }
}

extension SpeechRecognitionAlternative: Codable {

    private enum CodingKeys: String, CodingKey {
        case transcript = "transcript"
        case confidence = "confidence"
        case timestamps = "timestamps"
        case wordConfidence = "word_confidence"
        static let allValues = [transcript, confidence, timestamps, wordConfidence]
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        transcript = try container.decode(String.self, forKey: .transcript)
        confidence = try container.decodeIfPresent(Double.self, forKey: .confidence)
        timestamps = try container.decodeIfPresent([String].self, forKey: .timestamps)
        wordConfidence = try container.decodeIfPresent([String].self, forKey: .wordConfidence)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(transcript, forKey: .transcript)
        try container.encodeIfPresent(confidence, forKey: .confidence)
        try container.encodeIfPresent(timestamps, forKey: .timestamps)
        try container.encodeIfPresent(wordConfidence, forKey: .wordConfidence)
    }

}
