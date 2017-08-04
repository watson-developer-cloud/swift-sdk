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

/** UpdateEntity. */
public struct UpdateEntity: JSONDecodable, JSONEncodable {

    /// The name of the entity.
    public let entity: String?

    /// The description of the entity.
    public let description: String?

    /// Any metadata related to the entity.
    public let metadata: [String: Any]?

    /// Whether to use fuzzy matching for the entity.
    public let fuzzyMatch: Bool?

    /// An array of entity values.
    public let values: [CreateValue]?

    /**
     Initialize a `UpdateEntity` with member variables.

     - parameter entity: The name of the entity.
     - parameter description: The description of the entity.
     - parameter metadata: Any metadata related to the entity.
     - parameter fuzzyMatch: Whether to use fuzzy matching for the entity.
     - parameter values: An array of entity values.

     - returns: An initialized `UpdateEntity`.
    */
    public init(entity: String? = nil, description: String? = nil, metadata: [String: Any]? = nil, fuzzyMatch: Bool? = nil, values: [CreateValue]? = nil) {
        self.entity = entity
        self.description = description
        self.metadata = metadata
        self.fuzzyMatch = fuzzyMatch
        self.values = values
    }

    // MARK: JSONDecodable
    /// Used internally to initialize a `UpdateEntity` model from JSON.
    public init(json: JSON) throws {
        entity = try? json.getString(at: "entity")
        description = try? json.getString(at: "description")
        metadata = try? json.getDictionaryObject(at: "metadata")
        fuzzyMatch = try? json.getBool(at: "fuzzy_match")
        values = try? json.decodedArray(at: "values", type: CreateValue.self)
    }

    // MARK: JSONEncodable
    /// Used internally to serialize a `UpdateEntity` model to JSON.
    public func toJSONObject() -> Any {
        var json = [String: Any]()
        if let entity = entity { json["entity"] = entity }
        if let description = description { json["description"] = description }
        if let metadata = metadata { json["metadata"] = metadata }
        if let fuzzyMatch = fuzzyMatch { json["fuzzy_match"] = fuzzyMatch }
        if let values = values {
            json["values"] = values.map { $0.toJSONObject() }
        }
        return json
    }
}
