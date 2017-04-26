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

/** IntentExportResponse. */
public struct IntentExportResponse: JSONDecodable, JSONEncodable {

    /// The name of the intent.
    public let intent: String

    /// The timestamp for creation of the intent.
    public let created: String

    /// The timestamp for the last update to the intent.
    public let updated: String

    /// The description of the intent.
    public let description: String?

    /// An array of Examples collection.
    public let examples: [ExampleResponse]?

    /**
     Initialize a `IntentExportResponse` with member variables.

     - parameter intent: The name of the intent.
     - parameter created: The timestamp for creation of the intent.
     - parameter updated: The timestamp for the last update to the intent.
     - parameter description: The description of the intent.
     - parameter examples: An array of Examples collection.

     - returns: An initialized `IntentExportResponse`.
    */
    public init(intent: String, created: String, updated: String, description: String? = nil, examples: [ExampleResponse]? = nil) {
        self.intent = intent
        self.created = created
        self.updated = updated
        self.description = description
        self.examples = examples
    }

    // MARK: JSONDecodable
    /// Used internally to initialize a `IntentExportResponse` model from JSON.
    public init(json: JSON) throws {
        intent = try json.getString(at: "intent")
        created = try json.getString(at: "created")
        updated = try json.getString(at: "updated")
        description = try? json.getString(at: "description")
        examples = try? json.decodedArray(at: "examples", type: ExampleResponse.self)
    }

    // MARK: JSONEncodable
    /// Used internally to serialize a `IntentExportResponse` model to JSON.
    public func toJSONObject() -> Any {
        var json = [String: Any]()
        json["intent"] = intent
        json["created"] = created
        json["updated"] = updated
        if let description = description { json["description"] = description }
        if let examples = examples {
            json["examples"] = examples.map { $0.toJSONObject() }
        }
        return json
    }
}
