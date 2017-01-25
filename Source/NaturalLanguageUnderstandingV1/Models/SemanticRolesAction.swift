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


public struct SemanticRolesAction: JSONDecodable,JSONEncodable {
    /// Analyzed text that corresponds to the action
    public let text: String?
    /// normalized version of the action
    public let normalized: String?
    
    public let verb: Any?

    /**
     Initialize a `SemanticRolesAction` with required member variables.


     - returns: An initialized `SemanticRolesAction`.
    */
    public init() {
    }

    /**
    Initialize a `SemanticRolesAction` with all member variables.

     - parameter text: Analyzed text that corresponds to the action
     - parameter normalized: normalized version of the action
     - parameter verb: 

    - returns: An initialized `SemanticRolesAction`.
    */
    public init(text: String, normalized: String, verb: Any) {
        self.text = text
        self.normalized = normalized
        self.verb = verb
    }

    // MARK: JSONDecodable
    /// Used internally to initialize a `SemanticRolesAction` model from JSON.
    public init(json: JSON) throws {
        text = try? json.getString(at: "text")
        normalized = try? json.getString(at: "normalized")
        verb = try? json.getString(at: "verb")
    }

    // MARK: JSONEncodable
    /// Used internally to serialize a `SemanticRolesAction` model to JSON.
    func toJSONObject() -> Any {
        var json = [String: Any]()
        if let text = text { json["text"] = text }
        if let normalized = normalized { json["normalized"] = normalized }
        if let verb = verb { json["verb"] = verb }
        return json
    }
}
