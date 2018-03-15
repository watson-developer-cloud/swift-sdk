/**
 * Copyright IBM Corporation 2018
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

/** CreateIntent. */
public struct CreateIntent {

    /// The name of the intent. This string must conform to the following restrictions:  - It can contain only Unicode alphanumeric, underscore, hyphen, and dot characters.  - It cannot begin with the reserved prefix `sys-`.  - It must be no longer than 128 characters.
    public var intent: String

    /// The description of the intent. This string cannot contain carriage return, newline, or tab characters, and it must be no longer than 128 characters.
    public var description: String?

    /// An array of user input examples for the intent.
    public var examples: [CreateExample]?

    /**
     Initialize a `CreateIntent` with member variables.

     - parameter intent: The name of the intent. This string must conform to the following restrictions:  - It can contain only Unicode alphanumeric, underscore, hyphen, and dot characters.  - It cannot begin with the reserved prefix `sys-`.  - It must be no longer than 128 characters.
     - parameter description: The description of the intent. This string cannot contain carriage return, newline, or tab characters, and it must be no longer than 128 characters.
     - parameter examples: An array of user input examples for the intent.

     - returns: An initialized `CreateIntent`.
    */
    public init(intent: String, description: String? = nil, examples: [CreateExample]? = nil) {
        self.intent = intent
        self.description = description
        self.examples = examples
    }
}

extension CreateIntent: Codable {

    private enum CodingKeys: String, CodingKey {
        case intent = "intent"
        case description = "description"
        case examples = "examples"
        static let allValues = [intent, description, examples]
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        intent = try container.decode(String.self, forKey: .intent)
        description = try container.decodeIfPresent(String.self, forKey: .description)
        examples = try container.decodeIfPresent([CreateExample].self, forKey: .examples)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(intent, forKey: .intent)
        try container.encodeIfPresent(description, forKey: .description)
        try container.encodeIfPresent(examples, forKey: .examples)
    }

}
