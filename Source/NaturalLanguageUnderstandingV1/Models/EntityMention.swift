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

/** EntityMention. */
public struct EntityMention {

    /// Entity mention text.
    public var text: String?

    /// Character offsets indicating the beginning and end of the mention in the analyzed text.
    public var location: [Int]?

    /**
     Initialize a `EntityMention` with member variables.

     - parameter text: Entity mention text.
     - parameter location: Character offsets indicating the beginning and end of the mention in the analyzed text.

     - returns: An initialized `EntityMention`.
    */
    public init(text: String? = nil, location: [Int]? = nil) {
        self.text = text
        self.location = location
    }
}

extension EntityMention: Codable {

    private enum CodingKeys: String, CodingKey {
        case text = "text"
        case location = "location"
        static let allValues = [text, location]
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        text = try container.decodeIfPresent(String.self, forKey: .text)
        location = try container.decodeIfPresent([Int].self, forKey: .location)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(text, forKey: .text)
        try container.encodeIfPresent(location, forKey: .location)
    }

}
