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

/** An object containing the emotion results for the target. */
public struct TargetedEmotionResults {

    /// Targeted text.
    public var text: String?

    /// An object containing the emotion results for the target.
    public var emotion: EmotionScores?

    /**
     Initialize a `TargetedEmotionResults` with member variables.

     - parameter text: Targeted text.
     - parameter emotion: An object containing the emotion results for the target.

     - returns: An initialized `TargetedEmotionResults`.
    */
    public init(text: String? = nil, emotion: EmotionScores? = nil) {
        self.text = text
        self.emotion = emotion
    }
}

extension TargetedEmotionResults: Codable {

    private enum CodingKeys: String, CodingKey {
        case text = "text"
        case emotion = "emotion"
        static let allValues = [text, emotion]
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        text = try container.decodeIfPresent(String.self, forKey: .text)
        emotion = try container.decodeIfPresent(EmotionScores.self, forKey: .emotion)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(text, forKey: .text)
        try container.encodeIfPresent(emotion, forKey: .emotion)
    }

}
