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

/** A text string that appears within the entity text field. */
public struct QueryEntitiesEntity {

    /// Entity text content.
    public var text: String?

    /// The type of the specified entity.
    public var type: String?

    /**
     Initialize a `QueryEntitiesEntity` with member variables.

     - parameter text: Entity text content.
     - parameter type: The type of the specified entity.

     - returns: An initialized `QueryEntitiesEntity`.
    */
    public init(text: String? = nil, type: String? = nil) {
        self.text = text
        self.type = type
    }
}

extension QueryEntitiesEntity: Codable {

    private enum CodingKeys: String, CodingKey {
        case text = "text"
        case type = "type"
        static let allValues = [text, type]
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        text = try container.decodeIfPresent(String.self, forKey: .text)
        type = try container.decodeIfPresent(String.self, forKey: .type)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(text, forKey: .text)
        try container.encodeIfPresent(type, forKey: .type)
    }

}
