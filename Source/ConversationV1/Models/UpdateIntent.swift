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

/** UpdateIntent. */
public struct UpdateIntent {

    /// The name of the intent.
    public var intent: String?

    /// The description of the intent.
    public var description: String?

    /// An array of user input examples for the intent.
    public var examples: [CreateExample]?

    /**
     Initialize a `UpdateIntent` with member variables.

     - parameter intent: The name of the intent.
     - parameter description: The description of the intent.
     - parameter examples: An array of user input examples for the intent.

     - returns: An initialized `UpdateIntent`.
    */
    public init(intent: String? = nil, description: String? = nil, examples: [CreateExample]? = nil) {
        self.intent = intent
        self.description = description
        self.examples = examples
    }
}

extension UpdateIntent: Codable {

    private enum CodingKeys: String, CodingKey {
        case intent = "intent"
        case description = "description"
        case examples = "examples"
        static let allValues = [intent, description, examples]
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        intent = try container.decodeIfPresent(String.self, forKey: .intent)
        description = try container.decodeIfPresent(String.self, forKey: .description)
        examples = try container.decodeIfPresent([CreateExample].self, forKey: .examples)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(intent, forKey: .intent)
        try container.encodeIfPresent(description, forKey: .description)
        try container.encodeIfPresent(examples, forKey: .examples)
    }

}
