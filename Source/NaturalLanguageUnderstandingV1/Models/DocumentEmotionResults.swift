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

/** An object containing the emotion results of a document. */
public struct DocumentEmotionResults {

    /// An object containing the emotion results for the document.
    public var emotion: EmotionScores?

    /**
     Initialize a `DocumentEmotionResults` with member variables.

     - parameter emotion: An object containing the emotion results for the document.

     - returns: An initialized `DocumentEmotionResults`.
    */
    public init(emotion: EmotionScores? = nil) {
        self.emotion = emotion
    }
}

extension DocumentEmotionResults: Codable {

    private enum CodingKeys: String, CodingKey {
        case emotion = "emotion"
        static let allValues = [emotion]
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        emotion = try container.decodeIfPresent(EmotionScores.self, forKey: .emotion)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(emotion, forKey: .emotion)
    }

}
