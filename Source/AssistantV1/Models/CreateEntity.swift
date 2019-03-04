/**
 * Copyright IBM Corporation 2019
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
import RestKit

/** CreateEntity. */
public struct CreateEntity: Codable, Equatable {

    /**
     The name of the entity. This string must conform to the following restrictions:
     - It can contain only Unicode alphanumeric, underscore, and hyphen characters.
     - It must be no longer than 64 characters.
     If you specify an entity name beginning with the reserved prefix `sys-`, it must be the name of a system entity
     that you want to enable. (Any entity content specified with the request is ignored.).
     */
    public var entity: String

    /**
     The description of the entity. This string cannot contain carriage return, newline, or tab characters, and it must
     be no longer than 128 characters.
     */
    public var description: String?

    /**
     Any metadata related to the entity.
     */
    public var metadata: [String: JSON]?

    /**
     Whether to use fuzzy matching for the entity.
     */
    public var fuzzyMatch: Bool?

    /**
     The timestamp for creation of the object.
     */
    public var created: Date?

    /**
     The timestamp for the most recent update to the object.
     */
    public var updated: Date?

    /**
     An array of objects describing the entity values.
     */
    public var values: [CreateValue]?

    // Map each property name to the key that shall be used for encoding/decoding.
    private enum CodingKeys: String, CodingKey {
        case entity = "entity"
        case description = "description"
        case metadata = "metadata"
        case fuzzyMatch = "fuzzy_match"
        case created = "created"
        case updated = "updated"
        case values = "values"
    }

    /**
     Initialize a `CreateEntity` with member variables.

     - parameter entity: The name of the entity. This string must conform to the following restrictions:
       - It can contain only Unicode alphanumeric, underscore, and hyphen characters.
       - It must be no longer than 64 characters.
       If you specify an entity name beginning with the reserved prefix `sys-`, it must be the name of a system entity
       that you want to enable. (Any entity content specified with the request is ignored.).
     - parameter description: The description of the entity. This string cannot contain carriage return, newline, or
       tab characters, and it must be no longer than 128 characters.
     - parameter metadata: Any metadata related to the entity.
     - parameter fuzzyMatch: Whether to use fuzzy matching for the entity.
     - parameter created: The timestamp for creation of the object.
     - parameter updated: The timestamp for the most recent update to the object.
     - parameter values: An array of objects describing the entity values.

     - returns: An initialized `CreateEntity`.
    */
    public init(
        entity: String,
        description: String? = nil,
        metadata: [String: JSON]? = nil,
        fuzzyMatch: Bool? = nil,
        created: Date? = nil,
        updated: Date? = nil,
        values: [CreateValue]? = nil
    )
    {
        self.entity = entity
        self.description = description
        self.metadata = metadata
        self.fuzzyMatch = fuzzyMatch
        self.created = created
        self.updated = updated
        self.values = values
    }

}
