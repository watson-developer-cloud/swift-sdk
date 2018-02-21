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

/** QueryRelationsRelationship. */
public struct QueryRelationsRelationship {

    /// The identified relationship type.
    public var type: String?

    /// The number of times the relationship is mentioned.
    public var frequency: Int?

    /// Information about the relationship.
    public var arguments: [QueryRelationsArgument]?

    /**
     Initialize a `QueryRelationsRelationship` with member variables.

     - parameter type: The identified relationship type.
     - parameter frequency: The number of times the relationship is mentioned.
     - parameter arguments: Information about the relationship.

     - returns: An initialized `QueryRelationsRelationship`.
    */
    public init(type: String? = nil, frequency: Int? = nil, arguments: [QueryRelationsArgument]? = nil) {
        self.type = type
        self.frequency = frequency
        self.arguments = arguments
    }
}

extension QueryRelationsRelationship: Codable {

    private enum CodingKeys: String, CodingKey {
        case type = "type"
        case frequency = "frequency"
        case arguments = "arguments"
        static let allValues = [type, frequency, arguments]
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        type = try container.decodeIfPresent(String.self, forKey: .type)
        frequency = try container.decodeIfPresent(Int.self, forKey: .frequency)
        arguments = try container.decodeIfPresent([QueryRelationsArgument].self, forKey: .arguments)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(type, forKey: .type)
        try container.encodeIfPresent(frequency, forKey: .frequency)
        try container.encodeIfPresent(arguments, forKey: .arguments)
    }

}
