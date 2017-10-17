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

/** Example. */
public struct Example {

    /// The text of the example.
    public var exampleText: String

    /// The timestamp for creation of the example.
    public var created: String

    /// The timestamp for the last update to the example.
    public var updated: String

    /**
     Initialize a `Example` with member variables.

     - parameter exampleText: The text of the example.
     - parameter created: The timestamp for creation of the example.
     - parameter updated: The timestamp for the last update to the example.

     - returns: An initialized `Example`.
    */
    public init(exampleText: String, created: String, updated: String) {
        self.exampleText = exampleText
        self.created = created
        self.updated = updated
    }
}

extension Example: Codable {

    private enum CodingKeys: String, CodingKey {
        case exampleText = "text"
        case created = "created"
        case updated = "updated"
        static let allValues = [exampleText, created, updated]
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        exampleText = try container.decode(String.self, forKey: .exampleText)
        created = try container.decode(String.self, forKey: .created)
        updated = try container.decode(String.self, forKey: .updated)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(exampleText, forKey: .exampleText)
        try container.encode(created, forKey: .created)
        try container.encode(updated, forKey: .updated)
    }

}
