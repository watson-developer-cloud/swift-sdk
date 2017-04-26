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

/** ExampleResponse. */
public struct ExampleResponse: JSONDecodable, JSONEncodable {

    /// The timestamp for creation of the example.
    public let created: String

    /// The timestamp for the last update to the example.
    public let updated: String

    /// The text of the example.
    public let text: String

    /**
     Initialize a `ExampleResponse` with member variables.

     - parameter created: The timestamp for creation of the example.
     - parameter updated: The timestamp for the last update to the example.
     - parameter text: The text of the example.

     - returns: An initialized `ExampleResponse`.
    */
    public init(created: String, updated: String, text: String) {
        self.created = created
        self.updated = updated
        self.text = text
    }

    // MARK: JSONDecodable
    /// Used internally to initialize a `ExampleResponse` model from JSON.
    public init(json: JSON) throws {
        created = try json.getString(at: "created")
        updated = try json.getString(at: "updated")
        text = try json.getString(at: "text")
    }

    // MARK: JSONEncodable
    /// Used internally to serialize a `ExampleResponse` model to JSON.
    public func toJSONObject() -> Any {
        var json = [String: Any]()
        json["created"] = created
        json["updated"] = updated
        json["text"] = text
        return json
    }
}
