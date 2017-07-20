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

/** UpdateSynonym. */
public struct UpdateSynonym: JSONDecodable, JSONEncodable {

    /// The text of the synonym.
    public let synonym: String?

    /**
     Initialize a `UpdateSynonym` with member variables.

     - parameter synonym: The text of the synonym.

     - returns: An initialized `UpdateSynonym`.
    */
    public init(synonym: String? = nil) {
        self.synonym = synonym
    }

    // MARK: JSONDecodable
    /// Used internally to initialize a `UpdateSynonym` model from JSON.
    public init(json: JSON) throws {
        synonym = try? json.getString(at: "synonym")
    }

    // MARK: JSONEncodable
    /// Used internally to serialize a `UpdateSynonym` model to JSON.
    public func toJSONObject() -> Any {
        var json = [String: Any]()
        if let synonym = synonym { json["synonym"] = synonym }
        return json
    }
}
