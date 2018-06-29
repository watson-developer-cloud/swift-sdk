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

/** UpdateEntity. */
public struct UpdateEntity: Encodable {

    /**
     The name of the entity. This string must conform to the following restrictions:
     - It can contain only Unicode alphanumeric, underscore, and hyphen characters.
     - It cannot begin with the reserved prefix `sys-`.
     - It must be no longer than 64 characters.
     */
    public var entity: String?

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
     An array of entity values.
     */
    public var values: [CreateValue]?

    // Map each property name to the key that shall be used for encoding/decoding.
    private enum CodingKeys: String, CodingKey {
        case entity = "entity"
        case description = "description"
        case metadata = "metadata"
        case fuzzyMatch = "fuzzy_match"
        case values = "values"
    }

    /**
     Initialize a `UpdateEntity` with member variables.

     - parameter entity: The name of the entity. This string must conform to the following restrictions:
       - It can contain only Unicode alphanumeric, underscore, and hyphen characters.
       - It cannot begin with the reserved prefix `sys-`.
       - It must be no longer than 64 characters.
     - parameter description: The description of the entity. This string cannot contain carriage return, newline, or
       tab characters, and it must be no longer than 128 characters.
     - parameter metadata: Any metadata related to the entity.
     - parameter fuzzyMatch: Whether to use fuzzy matching for the entity.
     - parameter values: An array of entity values.

     - returns: An initialized `UpdateEntity`.
    */
    public init(
        entity: String? = nil,
        description: String? = nil,
        metadata: [String: JSON]? = nil,
        fuzzyMatch: Bool? = nil,
        values: [CreateValue]? = nil
    )
    {
        self.entity = entity
        self.description = description
        self.metadata = metadata
        self.fuzzyMatch = fuzzyMatch
        self.values = values
    }

}
