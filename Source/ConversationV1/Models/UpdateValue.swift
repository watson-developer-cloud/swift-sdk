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

/** UpdateValue. */
public struct UpdateValue {

    /// The text of the entity value.
    public let value: String?

    /// Any metadata related to the entity value.
    public let metadata: [String: JSON]?

    /// An array of synonyms for the entity value.
    public let synonyms: [String]?

    /**
     Initialize a `UpdateValue` with member variables.

     - parameter value: The text of the entity value.
     - parameter metadata: Any metadata related to the entity value.
     - parameter synonyms: An array of synonyms for the entity value.

     - returns: An initialized `UpdateValue`.
    */
    public init(value: String? = nil, metadata: [String: JSON]? = nil, synonyms: [String]? = nil) {
        self.value = value
        self.metadata = metadata
        self.synonyms = synonyms
    }
}

extension UpdateValue: Codable {

    private enum CodingKeys: String, CodingKey {
        case value = "value"
        case metadata = "metadata"
        case synonyms = "synonyms"
        static let allValues = [value, metadata, synonyms]
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        value = try container.decodeIfPresent(String.self, forKey: .value)
        metadata = try container.decodeIfPresent([String: JSON].self, forKey: .metadata)
        synonyms = try container.decodeIfPresent([String].self, forKey: .synonyms)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(value, forKey: .value)
        try container.encodeIfPresent(metadata, forKey: .metadata)
        try container.encodeIfPresent(synonyms, forKey: .synonyms)
    }

}
