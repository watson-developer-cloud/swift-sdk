/**
 * Copyright IBM Corporation 2017
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

/** EmotionScores. */
public struct EmotionScores {

    /// Anger score from 0 to 1. A higher score means that the text is more likely to convey anger.
    public var anger: Double?

    /// Disgust score from 0 to 1. A higher score means that the text is more likely to convey disgust.
    public var disgust: Double?

    /// Fear score from 0 to 1. A higher score means that the text is more likely to convey fear.
    public var fear: Double?

    /// Joy score from 0 to 1. A higher score means that the text is more likely to convey joy.
    public var joy: Double?

    /// Sadness score from 0 to 1. A higher score means that the text is more likely to convey sadness.
    public var sadness: Double?

    /**
     Initialize a `EmotionScores` with member variables.

     - parameter anger: Anger score from 0 to 1. A higher score means that the text is more likely to convey anger.
     - parameter disgust: Disgust score from 0 to 1. A higher score means that the text is more likely to convey disgust.
     - parameter fear: Fear score from 0 to 1. A higher score means that the text is more likely to convey fear.
     - parameter joy: Joy score from 0 to 1. A higher score means that the text is more likely to convey joy.
     - parameter sadness: Sadness score from 0 to 1. A higher score means that the text is more likely to convey sadness.

     - returns: An initialized `EmotionScores`.
    */
    public init(anger: Double? = nil, disgust: Double? = nil, fear: Double? = nil, joy: Double? = nil, sadness: Double? = nil) {
        self.anger = anger
        self.disgust = disgust
        self.fear = fear
        self.joy = joy
        self.sadness = sadness
    }
}

extension EmotionScores: Codable {

    private enum CodingKeys: String, CodingKey {
        case anger = "anger"
        case disgust = "disgust"
        case fear = "fear"
        case joy = "joy"
        case sadness = "sadness"
        static let allValues = [anger, disgust, fear, joy, sadness]
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        anger = try container.decodeIfPresent(Double.self, forKey: .anger)
        disgust = try container.decodeIfPresent(Double.self, forKey: .disgust)
        fear = try container.decodeIfPresent(Double.self, forKey: .fear)
        joy = try container.decodeIfPresent(Double.self, forKey: .joy)
        sadness = try container.decodeIfPresent(Double.self, forKey: .sadness)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(anger, forKey: .anger)
        try container.encodeIfPresent(disgust, forKey: .disgust)
        try container.encodeIfPresent(fear, forKey: .fear)
        try container.encodeIfPresent(joy, forKey: .joy)
        try container.encodeIfPresent(sadness, forKey: .sadness)
    }

}
