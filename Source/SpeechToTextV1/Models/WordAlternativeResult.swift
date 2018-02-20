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

/** WordAlternativeResult. */
public struct WordAlternativeResult {

    /// A confidence score for the word alternative hypothesis in the range of 0 to 1.
    public var confidence: Double

    /// An alternative hypothesis for a word from the input audio.
    public var word: String

    /**
     Initialize a `WordAlternativeResult` with member variables.

     - parameter confidence: A confidence score for the word alternative hypothesis in the range of 0 to 1.
     - parameter word: An alternative hypothesis for a word from the input audio.

     - returns: An initialized `WordAlternativeResult`.
    */
    public init(confidence: Double, word: String) {
        self.confidence = confidence
        self.word = word
    }
}

extension WordAlternativeResult: Codable {

    private enum CodingKeys: String, CodingKey {
        case confidence = "confidence"
        case word = "word"
        static let allValues = [confidence, word]
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        confidence = try container.decode(Double.self, forKey: .confidence)
        word = try container.decode(String.self, forKey: .word)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(confidence, forKey: .confidence)
        try container.encode(word, forKey: .word)
    }

}
