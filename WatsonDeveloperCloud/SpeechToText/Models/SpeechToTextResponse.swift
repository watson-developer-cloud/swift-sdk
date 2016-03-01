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

extension SpeechToText {

    public struct SpeechToTextResponse: Mappable {

        /// Index indicating change point in the results array.
        /// (See description of `results` array for more information.)
        public var resultIndex: Int!

        /// The results array consists of 0 or more final results, followed by 0 or 1 interim
        /// result. The final results are guaranteed not to change, while the interim result may
        /// be replaced by 0 or more final results, followed by 0 or 1 interim result. The service
        /// periodically sends "updates" to the result list, with the `resultIndex` set to the
        /// lowest index in the array that has changed. `resultIndex` always points to the slot
        /// just after the most recent final result.
        public var results: [SpeechRecognitionResult]!

        /// Used internally to initialize a `SpeechToTextResponse` from JSON.
        public init?(_ map: Map) { }

        /// Used internally to serialize and deserialize JSON.
        public mutating func mapping(map: Map) {
            resultIndex <- map["result_index"]
            results     <- map["results"]
        }
    }

    public struct SpeechRecognitionResult: Mappable {

        /// If `true`, then the transcription result for this utterance is final and will not be
        /// updated further.
        public var final: Bool!

        /// Alternative transcription results.
        public var alternatives: [SpeechRecognitionAlternative]!

        /// A dictionary of spotted keywords and their associated matches. A keyword will have
        /// no associated matches if it was not found within the audio input or the threshold
        /// was set too high.
        public var keywordResults: [String: [KeywordResult]]?

        /// A list of acoustically similar alternatives for words of the input audio.
        public var wordAlternatives: [WordAlternativeResults]?

        /// Used internally to initialize a `SpeechRecognitionResult` from JSON.
        public init?(_ map: Map) { }

        /// Used internally to serialize and deserialize JSON.
        public mutating func mapping(map: Map) {
            final            <- map["final"]
            alternatives     <- map["alternatives"]
            keywordResults   <- map["keywords_result"]
            wordAlternatives <- map["word_alternatives"]
        }
    }

    public struct SpeechRecognitionAlternative: Mappable {

        /// A transcript of the utterance.
        public var transcript: String!

        /// The confidence score of the transcript, between 0 and 1. Available only for the best
        /// alternative and only in results marked as final.
        public var confidence: Double?

        /// Timestamps for each word of the transcript.
        public var timestamps: [WordTimestamp]? // TODO: needs transform from ["word", 0.1, 0.2] to WordTimestamp object...

        /// Confidence scores for each word of the transcript, between 0 and 1. Available only
        /// for the best alternative and only in results marked as final.
        public var wordConfidence: [WordConfidence]? // TODO: needs a transform from ["hello", 0.95] to WordConfidence object...

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

    public struct WordTimestamp {

        /// A particular word from the transcript of the utterance.
        public var word: String!

        /// The start time, in seconds, of the given word in the audio input.
        public var startTime: Double!

        /// The end time, in seconds, of the given word in the audio input.
        public var endTime: Double!

    }

    public struct WordConfidence {

        /// A particular word from the transcript of the utterance.
        public var word: String!

        /// The confidence of the given word, between 0 and 1.
        public var confidence: Double!

    }

    public struct KeywordResult {

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

    public struct WordAlternativeResults {

        /// The time, in seconds, at which the word with alternative
        /// word hypotheses starts in the audio input.
        public var startTime: Double!

        /// The time, in seconds, at which the word with alternative
        /// word hypotheses ends in the audio input.
        public var endTime: Double!

        /// A list of alternative word hypotheses for a word in the audio input.
        public var alternatives: [WordAlternativeResult]!

        /// Used internally to initialize a `WordAlternativeResults` from JSON.
        public init?(_ map: Map) { }

        /// Used internally to serialize and deserialize JSON.
        public mutating func mapping(map: Map) {
            startTime    <- map["start_time"]
            endTime      <- map["end_time"]
            alternatives <- map["alternatives"]
        }
    }

    public struct WordAlternativeResult {

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
}
