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

/** DialogNodeCollection. */
public struct DialogNodeCollection {

    public var dialogNodes: [DialogNode]

    /// An object defining the pagination data for the returned objects.
    public var pagination: Pagination

    /**
     Initialize a `DialogNodeCollection` with member variables.

     - parameter dialogNodes:
     - parameter pagination: An object defining the pagination data for the returned objects.

     - returns: An initialized `DialogNodeCollection`.
    */
    public init(dialogNodes: [DialogNode], pagination: Pagination) {
        self.dialogNodes = dialogNodes
        self.pagination = pagination
    }
}

extension DialogNodeCollection: Codable {

    private enum CodingKeys: String, CodingKey {
        case dialogNodes = "dialog_nodes"
        case pagination = "pagination"
        static let allValues = [dialogNodes, pagination]
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        dialogNodes = try container.decode([DialogNode].self, forKey: .dialogNodes)
        pagination = try container.decode(Pagination.self, forKey: .pagination)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(dialogNodes, forKey: .dialogNodes)
        try container.encode(pagination, forKey: .pagination)
    }

}
