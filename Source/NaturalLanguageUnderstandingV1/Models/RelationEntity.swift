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


public struct RelationEntity: JSONDecodable,JSONEncodable {
    /// Text that corresponds to the entity
    public let text: String?
    /// Entity type
    public let type: String?

    /**
     Initialize a `RelationEntity` with required member variables.


     - returns: An initialized `RelationEntity`.
    */
    public init() {
    }

    /**
    Initialize a `RelationEntity` with all member variables.

     - parameter text: Text that corresponds to the entity
     - parameter type: Entity type

    - returns: An initialized `RelationEntity`.
    */
    public init(text: String, type: String) {
        self.text = text
        self.type = type
    }

    // MARK: JSONDecodable
    /// Used internally to initialize a `RelationEntity` model from JSON.
    public init(json: JSON) throws {
        text = try? json.getString(at: "text")
        type = try? json.getString(at: "type")
    }

    // MARK: JSONEncodable
    /// Used internally to serialize a `RelationEntity` model to JSON.
    func toJSONObject() -> Any {
        var json = [String: Any]()
        if let text = text { json["text"] = text }
        if let type = type { json["type"] = type }
        return json
    }
}
