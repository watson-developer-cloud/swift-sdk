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

/** Counterexample. */
public struct Counterexample {

    /// The text of the counterexample.
    public var text: String

    /// The timestamp for creation of the counterexample.
    public var created: String

    /// The timestamp for the last update to the counterexample.
    public var updated: String

    /**
     Initialize a `Counterexample` with member variables.

     - parameter text: The text of the counterexample.
     - parameter created: The timestamp for creation of the counterexample.
     - parameter updated: The timestamp for the last update to the counterexample.

     - returns: An initialized `Counterexample`.
    */
    public init(text: String, created: String, updated: String) {
        self.text = text
        self.created = created
        self.updated = updated
    }
}

extension Counterexample: Codable {

    private enum CodingKeys: String, CodingKey {
        case text = "text"
        case created = "created"
        case updated = "updated"
        static let allValues = [text, created, updated]
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        text = try container.decode(String.self, forKey: .text)
        created = try container.decode(String.self, forKey: .created)
        updated = try container.decode(String.self, forKey: .updated)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(text, forKey: .text)
        try container.encode(created, forKey: .created)
        try container.encode(updated, forKey: .updated)
    }

}
