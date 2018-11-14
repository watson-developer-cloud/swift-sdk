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

/** Entity. */
public struct Entity: Codable, Equatable {

    /**
     The name of the entity.
     */
    public var entityName: String

    /**
     The timestamp for creation of the entity.
     */
    public var created: Date?

    /**
     The timestamp for the last update to the entity.
     */
    public var updated: Date?

    /**
     The description of the entity.
     */
    public var description: String?

    /**
     Any metadata related to the entity.
     */
    public var metadata: [String: JSON]?

    /**
     Whether fuzzy matching is used for the entity.
     */
    public var fuzzyMatch: Bool?

    // Map each property name to the key that shall be used for encoding/decoding.
    private enum CodingKeys: String, CodingKey {
        case entityName = "entity"
        case created = "created"
        case updated = "updated"
        case description = "description"
        case metadata = "metadata"
        case fuzzyMatch = "fuzzy_match"
    }

}
