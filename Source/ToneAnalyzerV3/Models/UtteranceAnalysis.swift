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

/** UtteranceAnalysis. */
public struct UtteranceAnalysis {

    /// The unique identifier of the utterance. The first utterance has ID 0, and the ID of each subsequent utterance is incremented by one.
    public var utteranceID: Int

    /// The text of the utterance.
    public var utteranceText: String

    /// An array of `ToneChatScore` objects that provides results for the most prevalent tones of the utterance. The array includes results for any tone whose score is at least 0.5. The array is empty if no tone has a score that meets this threshold.
    public var tones: [ToneChatScore]

    /// **`2017-09-21`:** An error message if the utterance contains more than 500 characters. The service does not analyze the utterance. **`2016-05-19`:** Not returned.
    public var error: String?

    /**
     Initialize a `UtteranceAnalysis` with member variables.

     - parameter utteranceID: The unique identifier of the utterance. The first utterance has ID 0, and the ID of each subsequent utterance is incremented by one.
     - parameter utteranceText: The text of the utterance.
     - parameter tones: An array of `ToneChatScore` objects that provides results for the most prevalent tones of the utterance. The array includes results for any tone whose score is at least 0.5. The array is empty if no tone has a score that meets this threshold.
     - parameter error: **`2017-09-21`:** An error message if the utterance contains more than 500 characters. The service does not analyze the utterance. **`2016-05-19`:** Not returned.

     - returns: An initialized `UtteranceAnalysis`.
    */
    public init(utteranceID: Int, utteranceText: String, tones: [ToneChatScore], error: String? = nil) {
        self.utteranceID = utteranceID
        self.utteranceText = utteranceText
        self.tones = tones
        self.error = error
    }
}

extension UtteranceAnalysis: Codable {

    private enum CodingKeys: String, CodingKey {
        case utteranceID = "utterance_id"
        case utteranceText = "utterance_text"
        case tones = "tones"
        case error = "error"
        static let allValues = [utteranceID, utteranceText, tones, error]
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        utteranceID = try container.decode(Int.self, forKey: .utteranceID)
        utteranceText = try container.decode(String.self, forKey: .utteranceText)
        tones = try container.decode([ToneChatScore].self, forKey: .tones)
        error = try container.decodeIfPresent(String.self, forKey: .error)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(utteranceID, forKey: .utteranceID)
        try container.encode(utteranceText, forKey: .utteranceText)
        try container.encode(tones, forKey: .tones)
        try container.encodeIfPresent(error, forKey: .error)
    }

}
