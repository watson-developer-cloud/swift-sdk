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


public struct SemanticRolesKeyword: JSONDecodable,JSONEncodable {
    /// The keyword text
    public let text: String?

    /**
     Initialize a `SemanticRolesKeyword` with required member variables.


     - returns: An initialized `SemanticRolesKeyword`.
    */
    public init() {
    }

    /**
    Initialize a `SemanticRolesKeyword` with all member variables.

     - parameter text: The keyword text

    - returns: An initialized `SemanticRolesKeyword`.
    */
    public init(text: String) {
        self.text = text
    }

    // MARK: JSONDecodable
    /// Used internally to initialize a `SemanticRolesKeyword` model from JSON.
    public init(json: JSON) throws {
        text = try? json.getString(at: "text")
    }

    // MARK: JSONEncodable
    /// Used internally to serialize a `SemanticRolesKeyword` model to JSON.
    func toJSONObject() -> Any {
        var json = [String: Any]()
        if let text = text { json["text"] = text }
        return json
    }
}
