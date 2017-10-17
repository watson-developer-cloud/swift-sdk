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

/** WorkspaceCollection. */
public struct WorkspaceCollection {

    /// An array of workspaces.
    public var workspaces: [Workspace]

    /// An object defining the pagination data for the returned objects.
    public var pagination: Pagination

    /**
     Initialize a `WorkspaceCollection` with member variables.

     - parameter workspaces: An array of workspaces.
     - parameter pagination: An object defining the pagination data for the returned objects.

     - returns: An initialized `WorkspaceCollection`.
    */
    public init(workspaces: [Workspace], pagination: Pagination) {
        self.workspaces = workspaces
        self.pagination = pagination
    }
}

extension WorkspaceCollection: Codable {

    private enum CodingKeys: String, CodingKey {
        case workspaces = "workspaces"
        case pagination = "pagination"
        static let allValues = [workspaces, pagination]
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        workspaces = try container.decode([Workspace].self, forKey: .workspaces)
        pagination = try container.decode(Pagination.self, forKey: .pagination)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(workspaces, forKey: .workspaces)
        try container.encode(pagination, forKey: .pagination)
    }

}
