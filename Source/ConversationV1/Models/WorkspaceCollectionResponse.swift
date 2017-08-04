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
import RestKit

/** WorkspaceCollectionResponse. */
public struct WorkspaceCollectionResponse: JSONDecodable, JSONEncodable {

    /// An array of WorkspaceResponse objects describing the workspaces associated with the service instance.
    public let workspaces: [WorkspaceResponse]

    /// A PaginationResponse object defining the pagination data for the returned objects.
    public let pagination: PaginationResponse

    /**
     Initialize a `WorkspaceCollectionResponse` with member variables.

     - parameter workspaces: An array of WorkspaceResponse objects describing the workspaces associated with the service instance.
     - parameter pagination: A PaginationResponse object defining the pagination data for the returned objects.

     - returns: An initialized `WorkspaceCollectionResponse`.
    */
    public init(workspaces: [WorkspaceResponse], pagination: PaginationResponse) {
        self.workspaces = workspaces
        self.pagination = pagination
    }

    // MARK: JSONDecodable
    /// Used internally to initialize a `WorkspaceCollectionResponse` model from JSON.
    public init(json: JSON) throws {
        workspaces = try json.decodedArray(at: "workspaces", type: WorkspaceResponse.self)
        pagination = try json.decode(at: "pagination", type: PaginationResponse.self)
    }

    // MARK: JSONEncodable
    /// Used internally to serialize a `WorkspaceCollectionResponse` model to JSON.
    public func toJSONObject() -> Any {
        var json = [String: Any]()
        json["workspaces"] = workspaces.map { $0.toJSONObject() }
        json["pagination"] = pagination.toJSONObject()
        return json
    }
}
