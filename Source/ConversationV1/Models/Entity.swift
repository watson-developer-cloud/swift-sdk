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

/** Entity. */
public struct Entity {

    /// The name of the entity.
    public var entityName: String

    /// The timestamp for creation of the entity.
    public var created: String

    /// The timestamp for the last update to the entity.
    public var updated: String

    /// The description of the entity.
    public var description: String?

    /// Any metadata related to the entity.
    public var metadata: [String: JSON]?

    /// Whether fuzzy matching is used for the entity.
    public var fuzzyMatch: Bool?

    /**
     Initialize a `Entity` with member variables.

     - parameter entityName: The name of the entity.
     - parameter created: The timestamp for creation of the entity.
     - parameter updated: The timestamp for the last update to the entity.
     - parameter description: The description of the entity.
     - parameter metadata: Any metadata related to the entity.
     - parameter fuzzyMatch: Whether fuzzy matching is used for the entity.

     - returns: An initialized `Entity`.
    */
    public init(entityName: String, created: String, updated: String, description: String? = nil, metadata: [String: JSON]? = nil, fuzzyMatch: Bool? = nil) {
        self.entityName = entityName
        self.created = created
        self.updated = updated
        self.description = description
        self.metadata = metadata
        self.fuzzyMatch = fuzzyMatch
    }
}

extension Entity: Codable {

    private enum CodingKeys: String, CodingKey {
        case entityName = "entity"
        case created = "created"
        case updated = "updated"
        case description = "description"
        case metadata = "metadata"
        case fuzzyMatch = "fuzzy_match"
        static let allValues = [entityName, created, updated, description, metadata, fuzzyMatch]
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        entityName = try container.decode(String.self, forKey: .entityName)
        created = try container.decode(String.self, forKey: .created)
        updated = try container.decode(String.self, forKey: .updated)
        description = try container.decodeIfPresent(String.self, forKey: .description)
        metadata = try container.decodeIfPresent([String: JSON].self, forKey: .metadata)
        fuzzyMatch = try container.decodeIfPresent(Bool.self, forKey: .fuzzyMatch)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(entityName, forKey: .entityName)
        try container.encode(created, forKey: .created)
        try container.encode(updated, forKey: .updated)
        try container.encodeIfPresent(description, forKey: .description)
        try container.encodeIfPresent(metadata, forKey: .metadata)
        try container.encodeIfPresent(fuzzyMatch, forKey: .fuzzyMatch)
    }

}
