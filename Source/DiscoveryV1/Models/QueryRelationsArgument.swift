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

/** QueryRelationsArgument. */
public struct QueryRelationsArgument {

    public var entities: [QueryEntitiesEntity]?

    /**
     Initialize a `QueryRelationsArgument` with member variables.

     - parameter entities:

     - returns: An initialized `QueryRelationsArgument`.
    */
    public init(entities: [QueryEntitiesEntity]? = nil) {
        self.entities = entities
    }
}

extension QueryRelationsArgument: Codable {

    private enum CodingKeys: String, CodingKey {
        case entities = "entities"
        static let allValues = [entities]
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        entities = try container.decodeIfPresent([QueryEntitiesEntity].self, forKey: .entities)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(entities, forKey: .entities)
    }

}
