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

/** ToneChatScore. */
public struct ToneChatScore {

    /// The score for the tone in the range of 0.5 to 1. A score greater than 0.75 indicates a high likelihood that the tone is perceived in the utterance.
    public var score: Double

    /// The unique, non-localized identifier of the tone for the results. The service can return results for the following tone IDs: `sad`, `frustrated`, `satisfied`, `excited`, `polite`, `impolite`, and `sympathetic`. The service returns results only for tones whose scores meet a minimum threshold of 0.5.
    public var toneID: String

    /// The user-visible, localized name of the tone.
    public var toneName: String

    /**
     Initialize a `ToneChatScore` with member variables.

     - parameter score: The score for the tone in the range of 0.5 to 1. A score greater than 0.75 indicates a high likelihood that the tone is perceived in the utterance.
     - parameter toneID: The unique, non-localized identifier of the tone for the results. The service can return results for the following tone IDs: `sad`, `frustrated`, `satisfied`, `excited`, `polite`, `impolite`, and `sympathetic`. The service returns results only for tones whose scores meet a minimum threshold of 0.5.
     - parameter toneName: The user-visible, localized name of the tone.

     - returns: An initialized `ToneChatScore`.
    */
    public init(score: Double, toneID: String, toneName: String) {
        self.score = score
        self.toneID = toneID
        self.toneName = toneName
    }
}

extension ToneChatScore: Codable {

    private enum CodingKeys: String, CodingKey {
        case score = "score"
        case toneID = "tone_id"
        case toneName = "tone_name"
        static let allValues = [score, toneID, toneName]
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        score = try container.decode(Double.self, forKey: .score)
        toneID = try container.decode(String.self, forKey: .toneID)
        toneName = try container.decode(String.self, forKey: .toneName)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(score, forKey: .score)
        try container.encode(toneID, forKey: .toneID)
        try container.encode(toneName, forKey: .toneName)
    }

}
