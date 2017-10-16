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

/** Synonym. */
public struct Synonym {

    /// The text of the synonym.
    public var synonymText: String

    /// The timestamp for creation of the synonym.
    public var created: String

    /// The timestamp for the most recent update to the synonym.
    public var updated: String

    /**
     Initialize a `Synonym` with member variables.

     - parameter synonymText: The text of the synonym.
     - parameter created: The timestamp for creation of the synonym.
     - parameter updated: The timestamp for the most recent update to the synonym.

     - returns: An initialized `Synonym`.
    */
    public init(synonymText: String, created: String, updated: String) {
        self.synonymText = synonymText
        self.created = created
        self.updated = updated
    }
}

extension Synonym: Codable {

    private enum CodingKeys: String, CodingKey {
        case synonymText = "synonym"
        case created = "created"
        case updated = "updated"
        static let allValues = [synonymText, created, updated]
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        synonymText = try container.decode(String.self, forKey: .synonymText)
        created = try container.decode(String.self, forKey: .created)
        updated = try container.decode(String.self, forKey: .updated)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(synonymText, forKey: .synonymText)
        try container.encode(created, forKey: .created)
        try container.encode(updated, forKey: .updated)
    }

}
