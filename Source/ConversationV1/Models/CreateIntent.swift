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

/** CreateIntent. */
public struct CreateIntent: JSONDecodable, JSONEncodable {

    /// The name of the intent.
    public let intent: String

    /// The description of the intent.
    public let description: String?

    /// An array of user input examples.
    public let examples: [CreateExample]?

    /**
     Initialize a `CreateIntent` with member variables.

     - parameter intent: The name of the intent.
     - parameter description: The description of the intent.
     - parameter examples: An array of user input examples.

     - returns: An initialized `CreateIntent`.
    */
    public init(intent: String, description: String? = nil, examples: [CreateExample]? = nil) {
        self.intent = intent
        self.description = description
        self.examples = examples
    }

    // MARK: JSONDecodable
    /// Used internally to initialize a `CreateIntent` model from JSON.
    public init(json: JSON) throws {
        intent = try json.getString(at: "intent")
        description = try? json.getString(at: "description")
        examples = try? json.decodedArray(at: "examples", type: CreateExample.self)
    }

    // MARK: JSONEncodable
    /// Used internally to serialize a `CreateIntent` model to JSON.
    public func toJSONObject() -> Any {
        var json = [String: Any]()
        json["intent"] = intent
        if let description = description { json["description"] = description }
        if let examples = examples {
            json["examples"] = examples.map { $0.toJSONObject() }
        }
        return json
    }
}
