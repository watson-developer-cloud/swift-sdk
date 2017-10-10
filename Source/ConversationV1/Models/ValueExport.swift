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

/** ValueExport. */
public struct ValueExport {

    /// The text of the entity value.
    public let entityValue: String

    /// Any metadata related to the entity value.
    public let metadata: [String: JSON]?

    /// The timestamp for creation of the entity value.
    public let created: String

    /// The timestamp for the last update to the entity value.
    public let updated: String

    /// An array of synonyms.
    public let synonyms: [String]?

    /**
     Initialize a `ValueExport` with member variables.

     - parameter entityValue: The text of the entity value.
     - parameter created: The timestamp for creation of the entity value.
     - parameter updated: The timestamp for the last update to the entity value.
     - parameter metadata: Any metadata related to the entity value.
     - parameter synonyms: An array of synonyms.

     - returns: An initialized `ValueExport`.
    */
    public init(entityValue: String, created: String, updated: String, metadata: [String: JSON]? = nil, synonyms: [String]? = nil) {
        self.entityValue = entityValue
        self.created = created
        self.updated = updated
        self.metadata = metadata
        self.synonyms = synonyms
    }
}

extension ValueExport: Codable {

    private enum CodingKeys: String, CodingKey {
        case entityValue = "value"
        case metadata = "metadata"
        case created = "created"
        case updated = "updated"
        case synonyms = "synonyms"
        static let allValues = [entityValue, metadata, created, updated, synonyms]
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        entityValue = try container.decode(String.self, forKey: .entityValue)
        metadata = try container.decodeIfPresent([String: JSON].self, forKey: .metadata)
        created = try container.decode(String.self, forKey: .created)
        updated = try container.decode(String.self, forKey: .updated)
        synonyms = try container.decodeIfPresent([String].self, forKey: .synonyms)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(entityValue, forKey: .entityValue)
        try container.encodeIfPresent(metadata, forKey: .metadata)
        try container.encode(created, forKey: .created)
        try container.encode(updated, forKey: .updated)
        try container.encodeIfPresent(synonyms, forKey: .synonyms)
    }

}
