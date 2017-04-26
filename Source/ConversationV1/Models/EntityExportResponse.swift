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

/** EntityExportResponse. */
public struct EntityExportResponse: JSONDecodable, JSONEncodable {

    /// The name of the entity.
    public let entity: String

    /// The timestamp for creation of the entity.
    public let created: String

    /// The timestamp for the last update to the entity.
    public let updated: String

    /// The description of the entity.
    public let description: String?

    /// An array of entity values.
    public let values: [ValueExportResponse]?

    /**
     Initialize a `EntityExportResponse` with member variables.

     - parameter entity: The name of the entity.
     - parameter created: The timestamp for creation of the entity.
     - parameter updated: The timestamp for the last update to the entity.
     - parameter description: The description of the entity.
     - parameter values: An array of entity values.

     - returns: An initialized `EntityExportResponse`.
    */
    public init(entity: String, created: String, updated: String, description: String? = nil, values: [ValueExportResponse]? = nil) {
        self.entity = entity
        self.created = created
        self.updated = updated
        self.description = description
        self.values = values
    }

    // MARK: JSONDecodable
    /// Used internally to initialize a `EntityExportResponse` model from JSON.
    public init(json: JSON) throws {
        entity = try json.getString(at: "entity")
        created = try json.getString(at: "created")
        updated = try json.getString(at: "updated")
        description = try? json.getString(at: "description")
        values = try? json.decodedArray(at: "values", type: ValueExportResponse.self)
    }

    // MARK: JSONEncodable
    /// Used internally to serialize a `EntityExportResponse` model to JSON.
    public func toJSONObject() -> Any {
        var json = [String: Any]()
        json["entity"] = entity
        json["created"] = created
        json["updated"] = updated
        if let description = description { json["description"] = description }
        if let values = values {
            json["values"] = values.map { $0.toJSONObject() }
        }
        return json
    }
}
