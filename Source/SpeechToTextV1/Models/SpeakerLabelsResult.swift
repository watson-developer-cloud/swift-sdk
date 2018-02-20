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

/** SpeakerLabelsResult. */
public struct SpeakerLabelsResult {

    /// The start time of a word from the transcript. The value matches the start time of a word from the `timestamps` array.
    public var from: Double

    /// The end time of a word from the transcript. The value matches the end time of a word from the `timestamps` array.
    public var to: Double

    /// The numeric identifier that the service assigns to a speaker from the audio. Speaker IDs begin at `0` initially but can evolve and change across interim results (if supported by the method) and between interim and final results as the service processes the audio. They are not guaranteed to be sequential, contiguous, or ordered.
    public var speaker: Int

    /// A score that indicates the service's confidence in its identification of the speaker in the range of 0 to 1.
    public var confidence: Double

    /// An indication of whether the service might further change word and speaker-label results. A value of `true` means that the service guarantees not to send any further updates for the current or any preceding results; `false` means that the service might send further updates to the results.
    public var finalResults: Bool

    /**
     Initialize a `SpeakerLabelsResult` with member variables.

     - parameter from: The start time of a word from the transcript. The value matches the start time of a word from the `timestamps` array.
     - parameter to: The end time of a word from the transcript. The value matches the end time of a word from the `timestamps` array.
     - parameter speaker: The numeric identifier that the service assigns to a speaker from the audio. Speaker IDs begin at `0` initially but can evolve and change across interim results (if supported by the method) and between interim and final results as the service processes the audio. They are not guaranteed to be sequential, contiguous, or ordered.
     - parameter confidence: A score that indicates the service's confidence in its identification of the speaker in the range of 0 to 1.
     - parameter finalResults: An indication of whether the service might further change word and speaker-label results. A value of `true` means that the service guarantees not to send any further updates for the current or any preceding results; `false` means that the service might send further updates to the results.

     - returns: An initialized `SpeakerLabelsResult`.
    */
    public init(from: Double, to: Double, speaker: Int, confidence: Double, finalResults: Bool) {
        self.from = from
        self.to = to
        self.speaker = speaker
        self.confidence = confidence
        self.finalResults = finalResults
    }
}

extension SpeakerLabelsResult: Codable {

    private enum CodingKeys: String, CodingKey {
        case from = "from"
        case to = "to"
        case speaker = "speaker"
        case confidence = "confidence"
        case finalResults = "final"
        static let allValues = [from, to, speaker, confidence, finalResults]
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        from = try container.decode(Double.self, forKey: .from)
        to = try container.decode(Double.self, forKey: .to)
        speaker = try container.decode(Int.self, forKey: .speaker)
        confidence = try container.decode(Double.self, forKey: .confidence)
        finalResults = try container.decode(Bool.self, forKey: .finalResults)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(from, forKey: .from)
        try container.encode(to, forKey: .to)
        try container.encode(speaker, forKey: .speaker)
        try container.encode(confidence, forKey: .confidence)
        try container.encode(finalResults, forKey: .finalResults)
    }

}
