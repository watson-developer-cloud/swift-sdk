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

/** Value. */
public struct Value {

    /// The text of the entity value.
    public let entityValue: String

    /// Any metadata related to the entity value.
    public let metadata: [String: JSON]?

    /// The timestamp for creation of the entity value.
    public let created: String

    /// The timestamp for the last update to the entity value.
    public let updated: String

    /**
     Initialize a `Value` with member variables.

     - parameter entityValue: The text of the entity value.
     - parameter created: The timestamp for creation of the entity value.
     - parameter updated: The timestamp for the last update to the entity value.
     - parameter metadata: Any metadata related to the entity value.

     - returns: An initialized `Value`.
    */
    public init(entityValue: String, created: String, updated: String, metadata: [String: JSON]? = nil) {
        self.entityValue = entityValue
        self.created = created
        self.updated = updated
        self.metadata = metadata
    }
}

extension Value: Codable {

    private enum CodingKeys: String, CodingKey {
        case entityValue = "value"
        case metadata = "metadata"
        case created = "created"
        case updated = "updated"
        static let allValues = [entityValue, metadata, created, updated]
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        entityValue = try container.decode(String.self, forKey: .entityValue)
        metadata = try container.decodeIfPresent([String: JSON].self, forKey: .metadata)
        created = try container.decode(String.self, forKey: .created)
        updated = try container.decode(String.self, forKey: .updated)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(entityValue, forKey: .entityValue)
        try container.encodeIfPresent(metadata, forKey: .metadata)
        try container.encode(created, forKey: .created)
        try container.encode(updated, forKey: .updated)
    }

}
