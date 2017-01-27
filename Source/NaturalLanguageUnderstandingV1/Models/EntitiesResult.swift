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

public struct EntitiesResult: JSONDecodable,JSONEncodable {
    /// Entity type
    public let type: String?
    /// Relevance score from 0 to 1. Higher values indicate greater relevance
    public let relevance: Double?
    /// How many times the entity was mentioned in the text
    public let count: Int?
    /// The name of the entity
    public let text: String?

    /**
     Initialize a `EntitiesResult` with required member variables.

     - returns: An initialized `EntitiesResult`.
    */
    public init() {
        self.type = nil
        self.relevance = nil
        self.count = nil
        self.text = nil
    }

    /**
    Initialize a `EntitiesResult` with all member variables.

     - parameter type: Entity type
     - parameter relevance: Relevance score from 0 to 1. Higher values indicate greater relevance
     - parameter count: How many times the entity was mentioned in the text
     - parameter text: The name of the entity

    - returns: An initialized `EntitiesResult`.
    */
    public init(type: String, relevance: Double, count: Int, text: String) {
        self.type = type
        self.relevance = relevance
        self.count = count
        self.text = text
    }

    // MARK: JSONDecodable
    /// Used internally to initialize a `EntitiesResult` model from JSON.
    public init(json: JSON) throws {
        type = try? json.getString(at: "type")
        relevance = try? json.getDouble(at: "relevance")
        count = try? json.getInt(at: "count")
        text = try? json.getString(at: "text")
    }

    // MARK: JSONEncodable
    /// Used internally to serialize a `EntitiesResult` model to JSON.
    public func toJSONObject() -> Any {
        var json = [String: Any]()
        if let type = type { json["type"] = type }
        if let relevance = relevance { json["relevance"] = relevance }
        if let count = count { json["count"] = count }
        if let text = text { json["text"] = text }
        return json
    }
}
