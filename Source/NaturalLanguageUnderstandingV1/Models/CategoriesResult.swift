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

/** The hierarchical 5-level taxonomy the content is categorized into. */
public struct CategoriesResult {

    /// The path to the category through the taxonomy hierarchy.
    public var label: String?

    /// Confidence score for the category classification. Higher values indicate greater confidence.
    public var score: Double?

    /**
     Initialize a `CategoriesResult` with member variables.

     - parameter label: The path to the category through the taxonomy hierarchy.
     - parameter score: Confidence score for the category classification. Higher values indicate greater confidence.

     - returns: An initialized `CategoriesResult`.
    */
    public init(label: String? = nil, score: Double? = nil) {
        self.label = label
        self.score = score
    }
}

extension CategoriesResult: Codable {

    private enum CodingKeys: String, CodingKey {
        case label = "label"
        case score = "score"
        static let allValues = [label, score]
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        label = try container.decodeIfPresent(String.self, forKey: .label)
        score = try container.decodeIfPresent(Double.self, forKey: .score)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(label, forKey: .label)
        try container.encodeIfPresent(score, forKey: .score)
    }

}
