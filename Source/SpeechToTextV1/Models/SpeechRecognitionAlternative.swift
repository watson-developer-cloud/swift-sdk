/**
 * Copyright IBM Corporation 2019
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
public struct SpeechRecognitionAlternative: Codable, Equatable {

    /**
     A transcription of the audio.
     */
    public var transcript: String

    /**
     A score that indicates the service's confidence in the transcript in the range of 0.0 to 1.0. A confidence score is
     returned only for the best alternative and only with results marked as final.
     */
    public var confidence: Double?

    /**
     Time alignments for each word from the transcript as a list of lists. Each inner list consists of three elements:
     the word followed by its start and end time in seconds, for example: `[["hello",0.0,1.2],["world",1.2,2.5]]`.
     Timestamps are returned only for the best alternative.
     */
    public var timestamps: [WordTimestamp]?

    /**
     A confidence score for each word of the transcript as a list of lists. Each inner list consists of two elements:
     the word and its confidence score in the range of 0.0 to 1.0, for example: `[["hello",0.95],["world",0.866]]`.
     Confidence scores are returned only for the best alternative and only with results marked as final.
     */
    public var wordConfidence: [WordConfidence]?

    // Map each property name to the key that shall be used for encoding/decoding.
    private enum CodingKeys: String, CodingKey {
        case transcript = "transcript"
        case confidence = "confidence"
        case timestamps = "timestamps"
        case wordConfidence = "word_confidence"
    }

}
