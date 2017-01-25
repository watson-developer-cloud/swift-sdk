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


public struct SemanticRolesVerb: JSONDecodable,JSONEncodable {
    /// The keyword text
    public let text: String?
    /// Verb tense
    public let tense: String?

    /**
     Initialize a `SemanticRolesVerb` with required member variables.


     - returns: An initialized `SemanticRolesVerb`.
    */
    public init() {
    }

    /**
    Initialize a `SemanticRolesVerb` with all member variables.

     - parameter text: The keyword text
     - parameter tense: Verb tense

    - returns: An initialized `SemanticRolesVerb`.
    */
    public init(text: String, tense: String) {
        self.text = text
        self.tense = tense
    }

    // MARK: JSONDecodable
    /// Used internally to initialize a `SemanticRolesVerb` model from JSON.
    public init(json: JSON) throws {
        text = try? json.getString(at: "text")
        tense = try? json.getString(at: "tense")
    }

    // MARK: JSONEncodable
    /// Used internally to serialize a `SemanticRolesVerb` model to JSON.
    func toJSONObject() -> Any {
        var json = [String: Any]()
        if let text = text { json["text"] = text }
        if let tense = tense { json["tense"] = tense }
        return json
    }
}
