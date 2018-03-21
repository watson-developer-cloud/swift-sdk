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

/** An array of entities. */
public struct EntityCollection {

    /// An array of objects describing the entities defined for the workspace.
    public var entities: [EntityExport]

    /// The pagination data for the returned objects.
    public var pagination: Pagination

    /**
     Initialize a `EntityCollection` with member variables.

     - parameter entities: An array of objects describing the entities defined for the workspace.
     - parameter pagination: The pagination data for the returned objects.

     - returns: An initialized `EntityCollection`.
    */
    public init(entities: [EntityExport], pagination: Pagination) {
        self.entities = entities
        self.pagination = pagination
    }
}

extension EntityCollection: Codable {

    private enum CodingKeys: String, CodingKey {
        case entities = "entities"
        case pagination = "pagination"
        static let allValues = [entities, pagination]
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        entities = try container.decode([EntityExport].self, forKey: .entities)
        pagination = try container.decode(Pagination.self, forKey: .pagination)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(entities, forKey: .entities)
        try container.encode(pagination, forKey: .pagination)
    }

}
