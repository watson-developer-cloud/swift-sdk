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
import RestKit

/** CreateEntity. */
public struct CreateEntity: Encodable {

    /**
     The name of the entity. This string must conform to the following restrictions:
     - It can contain only Unicode alphanumeric, underscore, and hyphen characters.
     - It cannot begin with the reserved prefix `sys-`.
     - It must be no longer than 64 characters.
     */
    public var entity: String

    /**
     The description of the entity. This string cannot contain carriage return, newline, or tab characters, and it must
     be no longer than 128 characters.
     */
    public var description: String?

    /**
     Any metadata related to the value.
     */
    public var metadata: [String: JSON]?

    /**
     An array of objects describing the entity values.
     */
    public var values: [CreateValue]?

    /**
     Whether to use fuzzy matching for the entity.
     */
    public var fuzzyMatch: Bool?

    // Map each property name to the key that shall be used for encoding/decoding.
    private enum CodingKeys: String, CodingKey {
        case entity = "entity"
        case description = "description"
        case metadata = "metadata"
        case values = "values"
        case fuzzyMatch = "fuzzy_match"
    }

    /**
     Initialize a `CreateEntity` with member variables.

     - parameter entity: The name of the entity. This string must conform to the following restrictions:
       - It can contain only Unicode alphanumeric, underscore, and hyphen characters.
       - It cannot begin with the reserved prefix `sys-`.
       - It must be no longer than 64 characters.
     - parameter description: The description of the entity. This string cannot contain carriage return, newline, or
       tab characters, and it must be no longer than 128 characters.
     - parameter metadata: Any metadata related to the value.
     - parameter values: An array of objects describing the entity values.
     - parameter fuzzyMatch: Whether to use fuzzy matching for the entity.

     - returns: An initialized `CreateEntity`.
    */
    public init(
        entity: String,
        description: String? = nil,
        metadata: [String: JSON]? = nil,
        values: [CreateValue]? = nil,
        fuzzyMatch: Bool? = nil
    )
    {
        self.entity = entity
        self.description = description
        self.metadata = metadata
        self.values = values
        self.fuzzyMatch = fuzzyMatch
    }

}
