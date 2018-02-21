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

/** QueryRelationsEntity. */
public struct QueryRelationsEntity {

    /// Entity text content.
    public var text: String?

    /// The type of the specified entity.
    public var type: String?

    /// If false, implicit disambiguation is performed. The default is `false`.
    public var exact: Bool?

    /**
     Initialize a `QueryRelationsEntity` with member variables.

     - parameter text: Entity text content.
     - parameter type: The type of the specified entity.
     - parameter exact: If false, implicit disambiguation is performed. The default is `false`.

     - returns: An initialized `QueryRelationsEntity`.
    */
    public init(text: String? = nil, type: String? = nil, exact: Bool? = nil) {
        self.text = text
        self.type = type
        self.exact = exact
    }
}

extension QueryRelationsEntity: Codable {

    private enum CodingKeys: String, CodingKey {
        case text = "text"
        case type = "type"
        case exact = "exact"
        static let allValues = [text, type, exact]
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        text = try container.decodeIfPresent(String.self, forKey: .text)
        type = try container.decodeIfPresent(String.self, forKey: .type)
        exact = try container.decodeIfPresent(Bool.self, forKey: .exact)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(text, forKey: .text)
        try container.encodeIfPresent(type, forKey: .type)
        try container.encodeIfPresent(exact, forKey: .exact)
    }

}
