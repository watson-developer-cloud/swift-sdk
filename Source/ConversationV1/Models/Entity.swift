/**
 * Copyright IBM Corporation 2016
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

/** A term from the request that was identified as an entity. */
public struct Entity: JSONEncodable, JSONDecodable {

    /// The raw JSON object used to construct this model.
    public let json: [String: Any]

    /// The recognized entity from a term in the input.
    public let entity: String

    /// The zero-based character offset that indicates
    /// where the entity value begins in the input text.
    public let startIndex: Int

    /// The zero-based character offset that indicates
    /// where the entity value ends in the input text.
    public let endIndex: Int

    /// The term in the input text that was recognized.
    public let value: String

    /// Used internally to initialize an `Entity` model from JSON.
    public init(json: JSON) throws {
        self.json = try json.getDictionaryObject()
        entity = try json.getString(at: "entity")
        let indices = try json.decodedArray(at: "location", type: Swift.Int.self)
        startIndex = indices[0]
        endIndex = indices[1]
        value = try json.getString(at: "value")
    }

    /// Used internally to serialize an `Entity` model to JSON.
    public func toJSONObject() -> Any {
        return json
    }
}
