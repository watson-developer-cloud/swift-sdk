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


public struct SemanticRolesEntity: JSONDecodable,JSONEncodable {
    /// Entity type
    public let type: String?
    /// The entity text
    public let text: String?

    /**
     Initialize a `SemanticRolesEntity` with required member variables.


     - returns: An initialized `SemanticRolesEntity`.
    */
    public init() {
    }

    /**
    Initialize a `SemanticRolesEntity` with all member variables.

     - parameter type: Entity type
     - parameter text: The entity text

    - returns: An initialized `SemanticRolesEntity`.
    */
    public init(type: String, text: String) {
        self.type = type
        self.text = text
    }

    // MARK: JSONDecodable
    /// Used internally to initialize a `SemanticRolesEntity` model from JSON.
    public init(json: JSON) throws {
        type = try? json.getString(at: "type")
        text = try? json.getString(at: "text")
    }

    // MARK: JSONEncodable
    /// Used internally to serialize a `SemanticRolesEntity` model to JSON.
    func toJSONObject() -> Any {
        var json = [String: Any]()
        if let type = type { json["type"] = type }
        if let text = text { json["text"] = text }
        return json
    }
}
