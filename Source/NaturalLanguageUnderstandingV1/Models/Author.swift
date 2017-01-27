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

public struct Author: JSONDecodable,JSONEncodable {
    /// Name of the author
    public let name: String?

    /**
     Initialize a `Author` with required member variables.

     - returns: An initialized `Author`.
    */
    public init() {
        self.name = nil
    }

    /**
    Initialize a `Author` with all member variables.

     - parameter name: Name of the author

    - returns: An initialized `Author`.
    */
    public init(name: String) {
        self.name = name
    }

    // MARK: JSONDecodable
    /// Used internally to initialize a `Author` model from JSON.
    public init(json: JSON) throws {
        name = try? json.getString(at: "name")
    }

    // MARK: JSONEncodable
    /// Used internally to serialize a `Author` model to JSON.
    public func toJSONObject() -> Any {
        var json = [String: Any]()
        if let name = name { json["name"] = name }
        return json
    }
}
