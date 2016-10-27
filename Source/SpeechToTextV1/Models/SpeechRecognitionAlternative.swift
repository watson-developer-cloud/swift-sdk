/**
 * Copyright IBM Corporation 2016
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
import RestKit

/** A transcription alternative produced by Speech to Text. */
public struct SpeechRecognitionAlternative: JSONDecodable {

    /// A transcript of the utterance.
    public let transcript: String

    /// The confidence score of the transcript, between 0 and 1. Available only for the best
    /// alternative and only in results marked as final.
    public let confidence: Double?

    /// Timestamps for each word of the transcript.
    public let timestamps: [WordTimestamp]?

    /// Confidence scores for each word of the transcript, between 0 and 1. Available only
    /// for the best alternative and only in results marked as final.
    public let wordConfidence: [WordConfidence]?

    /// Used internally to initialize a `SpeechRecognitionAlternative` model from JSON.
    public init(json: JSON) throws {
        transcript = try json.getString(at: "transcript")
        confidence = try? json.getDouble(at: "confidence")
        timestamps = try? json.decodedArray(at: "timestamps", type: WordTimestamp.self)
        wordConfidence = try? json.decodedArray(at: "word_confidence", type: WordConfidence.self)
    }
}
