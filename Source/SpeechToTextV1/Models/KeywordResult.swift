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

/** KeywordResult. */
public struct KeywordResult {

    /// A specified keyword normalized to the spoken phrase that matched in the audio input.
    public var normalizedText: String

    /// The start time in seconds of the keyword match.
    public var startTime: Double

    /// The end time in seconds of the keyword match.
    public var endTime: Double

    /// A confidence score for the keyword match in the range of 0 to 1.
    public var confidence: Double

    /**
     Initialize a `KeywordResult` with member variables.

     - parameter normalizedText: A specified keyword normalized to the spoken phrase that matched in the audio input.
     - parameter startTime: The start time in seconds of the keyword match.
     - parameter endTime: The end time in seconds of the keyword match.
     - parameter confidence: A confidence score for the keyword match in the range of 0 to 1.

     - returns: An initialized `KeywordResult`.
    */
    public init(normalizedText: String, startTime: Double, endTime: Double, confidence: Double) {
        self.normalizedText = normalizedText
        self.startTime = startTime
        self.endTime = endTime
        self.confidence = confidence
    }
}

extension KeywordResult: Codable {

    private enum CodingKeys: String, CodingKey {
        case normalizedText = "normalized_text"
        case startTime = "start_time"
        case endTime = "end_time"
        case confidence = "confidence"
        static let allValues = [normalizedText, startTime, endTime, confidence]
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        normalizedText = try container.decode(String.self, forKey: .normalizedText)
        startTime = try container.decode(Double.self, forKey: .startTime)
        endTime = try container.decode(Double.self, forKey: .endTime)
        confidence = try container.decode(Double.self, forKey: .confidence)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(normalizedText, forKey: .normalizedText)
        try container.encode(startTime, forKey: .startTime)
        try container.encode(endTime, forKey: .endTime)
        try container.encode(confidence, forKey: .confidence)
    }

}
