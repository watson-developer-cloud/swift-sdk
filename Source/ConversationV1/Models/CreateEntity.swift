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

/** CreateEntity. */
public struct CreateEntity: JSONDecodable, JSONEncodable {

    /// The name of the entity.
    public let entity: String

    /// The description of the entity.
    public let description: String?

    /// An array of entity values.
    public let values: [CreateValue]?

    /**
     Initialize a `CreateEntity` with member variables.

     - parameter entity: The name of the entity.
     - parameter description: The description of the entity.
     - parameter values: An array of entity values.

     - returns: An initialized `CreateEntity`.
    */
    public init(entity: String, description: String? = nil, values: [CreateValue]? = nil) {
        self.entity = entity
        self.description = description
        self.values = values
    }

    // MARK: JSONDecodable
    /// Used internally to initialize a `CreateEntity` model from JSON.
    public init(json: JSON) throws {
        entity = try json.getString(at: "entity")
        description = try? json.getString(at: "description")
        values = try? json.decodedArray(at: "values", type: CreateValue.self)
    }

    // MARK: JSONEncodable
    /// Used internally to serialize a `CreateEntity` model to JSON.
    public func toJSONObject() -> Any {
        var json = [String: Any]()
        json["entity"] = entity
        if let description = description { json["description"] = description }
        if let values = values {
            json["values"] = values.map { $0.toJSONObject() }
        }
        return json
    }
}
