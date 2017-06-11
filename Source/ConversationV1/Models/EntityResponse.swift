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
import RestKit

/** EntityResponse. */
public struct EntityResponse: JSONDecodable, JSONEncodable {

    /// The name of the entity.
    public let entity: String

    /// The timestamp for creation of the entity.
    public let created: String

    /// The timestamp for the last update to the entity.
    public let updated: String

    /// The description of the entity.
    public let description: String?

    /// Any metadata related to the entity.
    public let metadata: [String: Any]?

    /// Whether fuzzy matching is used for the entity.
    public let fuzzyMatch: Bool?

    /**
     Initialize a `EntityResponse` with member variables.

     - parameter entity: The name of the entity.
     - parameter created: The timestamp for creation of the entity.
     - parameter updated: The timestamp for the last update to the entity.
     - parameter description: The description of the entity.
     - parameter metadata: Any metadata related to the entity.
     - parameter fuzzyMatch: Whether fuzzy matching is used for the entity.

     - returns: An initialized `EntityResponse`.
    */
    public init(entity: String, created: String, updated: String, description: String? = nil, metadata: [String: Any]? = nil, fuzzyMatch: Bool? = nil) {
        self.entity = entity
        self.created = created
        self.updated = updated
        self.description = description
        self.metadata = metadata
        self.fuzzyMatch = fuzzyMatch
    }

    // MARK: JSONDecodable
    /// Used internally to initialize a `EntityResponse` model from JSON.
    public init(json: JSON) throws {
        entity = try json.getString(at: "entity")
        created = try json.getString(at: "created")
        updated = try json.getString(at: "updated")
        description = try? json.getString(at: "description")
        metadata = try? json.getDictionaryObject(at: "metadata")
        fuzzyMatch = try? json.getBool(at: "fuzzy_match")
    }

    // MARK: JSONEncodable
    /// Used internally to serialize a `EntityResponse` model to JSON.
    public func toJSONObject() -> Any {
        var json = [String: Any]()
        json["entity"] = entity
        json["created"] = created
        json["updated"] = updated
        if let description = description { json["description"] = description }
        if let metadata = metadata { json["metadata"] = metadata }
        if let fuzzyMatch = fuzzyMatch { json["fuzzy_match"] = fuzzyMatch }
        return json
    }
}
