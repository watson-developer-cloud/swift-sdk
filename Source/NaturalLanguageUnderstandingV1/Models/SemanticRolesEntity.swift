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

/** SemanticRolesEntity. */
public struct SemanticRolesEntity {

    /// Entity type.
    public var type: String?

    /// The entity text.
    public var text: String?

    /**
     Initialize a `SemanticRolesEntity` with member variables.

     - parameter type: Entity type.
     - parameter text: The entity text.

     - returns: An initialized `SemanticRolesEntity`.
    */
    public init(type: String? = nil, text: String? = nil) {
        self.type = type
        self.text = text
    }
}

extension SemanticRolesEntity: Codable {

    private enum CodingKeys: String, CodingKey {
        case type = "type"
        case text = "text"
        static let allValues = [type, text]
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        type = try container.decodeIfPresent(String.self, forKey: .type)
        text = try container.decodeIfPresent(String.self, forKey: .text)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(type, forKey: .type)
        try container.encodeIfPresent(text, forKey: .text)
    }

}
