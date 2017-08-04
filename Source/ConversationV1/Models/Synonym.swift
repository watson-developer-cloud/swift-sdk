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

/** Synonym. */
public struct Synonym: JSONDecodable, JSONEncodable {

    /// The text of the synonym.
    public let synonym: String

    /// The timestamp for creation of the synonym.
    public let created: String

    /// The timestamp for the most recent update to the synonym.
    public let updated: String

    /**
     Initialize a `Synonym` with member variables.

     - parameter synonym: The text of the synonym.
     - parameter created: The timestamp for creation of the synonym.
     - parameter updated: The timestamp for the most recent update to the synonym.

     - returns: An initialized `Synonym`.
    */
    public init(synonym: String, created: String, updated: String) {
        self.synonym = synonym
        self.created = created
        self.updated = updated
    }

    // MARK: JSONDecodable
    /// Used internally to initialize a `Synonym` model from JSON.
    public init(json: JSON) throws {
        synonym = try json.getString(at: "synonym")
        created = try json.getString(at: "created")
        updated = try json.getString(at: "updated")
    }

    // MARK: JSONEncodable
    /// Used internally to serialize a `Synonym` model to JSON.
    public func toJSONObject() -> Any {
        var json = [String: Any]()
        json["synonym"] = synonym
        json["created"] = created
        json["updated"] = updated
        return json
    }
}
