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

/** RelationArgument. */
public struct RelationArgument {

    public var entities: [RelationEntity]?

    /// Text that corresponds to the argument.
    public var text: String?

    /**
     Initialize a `RelationArgument` with member variables.

     - parameter entities:
     - parameter text: Text that corresponds to the argument.

     - returns: An initialized `RelationArgument`.
    */
    public init(entities: [RelationEntity]? = nil, text: String? = nil) {
        self.entities = entities
        self.text = text
    }
}

extension RelationArgument: Codable {

    private enum CodingKeys: String, CodingKey {
        case entities = "entities"
        case text = "text"
        static let allValues = [entities, text]
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        entities = try container.decodeIfPresent([RelationEntity].self, forKey: .entities)
        text = try container.decodeIfPresent(String.self, forKey: .text)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(entities, forKey: .entities)
        try container.encodeIfPresent(text, forKey: .text)
    }

}
