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

/** The detected anger, disgust, fear, joy, or sadness that is conveyed by the content. Emotion information can be returned for detected entities, keywords, or user-specified target phrases found in the text. */
public struct EmotionResult {

    /// The returned emotion results across the document.
    public var document: DocumentEmotionResults?

    /// The returned emotion results per specified target.
    public var targets: [TargetedEmotionResults]?

    /**
     Initialize a `EmotionResult` with member variables.

     - parameter document: The returned emotion results across the document.
     - parameter targets: The returned emotion results per specified target.

     - returns: An initialized `EmotionResult`.
    */
    public init(document: DocumentEmotionResults? = nil, targets: [TargetedEmotionResults]? = nil) {
        self.document = document
        self.targets = targets
    }
}

extension EmotionResult: Codable {

    private enum CodingKeys: String, CodingKey {
        case document = "document"
        case targets = "targets"
        static let allValues = [document, targets]
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        document = try container.decodeIfPresent(DocumentEmotionResults.self, forKey: .document)
        targets = try container.decodeIfPresent([TargetedEmotionResults].self, forKey: .targets)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(document, forKey: .document)
        try container.encodeIfPresent(targets, forKey: .targets)
    }

}
