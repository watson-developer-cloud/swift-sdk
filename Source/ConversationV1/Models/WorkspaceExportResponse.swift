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

/** WorkspaceExportResponse. */
public struct WorkspaceExportResponse: JSONDecodable, JSONEncodable {

    /// The name of the workspace.
    public let name: String

    /// The description of the workspace.
    public let description: String

    /// The language of the workspace.
    public let language: String

    /// Any metadata that is required by the workspace.
    public let metadata: [String: Any]

    /// The timestamp for creation of the workspace.
    public let created: String

    /// The timestamp for the last update to the workspace.
    public let updated: String

    /// The workspace ID.
    public let workspaceID: String

    /// The current status of the workspace (`Non Existent`, `Training`, `Failed`, `Available`, or `Unavailable`).
    public let status: String

    /// An array of intents.
    public let intents: [IntentExportResponse]?

    /// An array of entities.
    public let entities: [EntityExport]?

    /// An array of counterexamples.
    public let counterexamples: [ExampleResponse]?

    /**
     Initialize a `WorkspaceExportResponse` with member variables.

     - parameter name: The name of the workspace.
     - parameter description: The description of the workspace.
     - parameter language: The language of the workspace.
     - parameter metadata: Any metadata that is required by the workspace.
     - parameter created: The timestamp for creation of the workspace.
     - parameter updated: The timestamp for the last update to the workspace.
     - parameter workspaceID: The workspace ID.
     - parameter status: The current status of the workspace (`Non Existent`, `Training`, `Failed`, `Available`, or `Unavailable`).
     - parameter intents: An array of intents.
     - parameter entities: An array of entities.
     - parameter counterexamples: An array of counterexamples.

     - returns: An initialized `WorkspaceExportResponse`.
    */
    public init(name: String, description: String, language: String, metadata: [String: Any], created: String, updated: String, workspaceID: String, status: String, intents: [IntentExportResponse]? = nil, entities: [EntityExport]? = nil, counterexamples: [ExampleResponse]? = nil) {
        self.name = name
        self.description = description
        self.language = language
        self.metadata = metadata
        self.created = created
        self.updated = updated
        self.workspaceID = workspaceID
        self.status = status
        self.intents = intents
        self.entities = entities
        self.counterexamples = counterexamples
    }

    // MARK: JSONDecodable
    /// Used internally to initialize a `WorkspaceExportResponse` model from JSON.
    public init(json: JSON) throws {
        name = try json.getString(at: "name")
        description = try json.getString(at: "description")
        language = try json.getString(at: "language")
        metadata = try json.getDictionaryObject(at: "metadata")
        created = try json.getString(at: "created")
        updated = try json.getString(at: "updated")
        workspaceID = try json.getString(at: "workspace_id")
        status = try json.getString(at: "status")
        intents = try? json.decodedArray(at: "intents", type: IntentExportResponse.self)
        entities = try? json.decodedArray(at: "entities", type: EntityExport.self)
        counterexamples = try? json.decodedArray(at: "counterexamples", type: ExampleResponse.self)
    }

    // MARK: JSONEncodable
    /// Used internally to serialize a `WorkspaceExportResponse` model to JSON.
    public func toJSONObject() -> Any {
        var json = [String: Any]()
        json["name"] = name
        json["description"] = description
        json["language"] = language
        json["metadata"] = metadata
        json["created"] = created
        json["updated"] = updated
        json["workspace_id"] = workspaceID
        json["status"] = status
        if let intents = intents {
            json["intents"] = intents.map { $0.toJSONObject() }
        }
        if let entities = entities {
            json["entities"] = entities.map { $0.toJSONObject() }
        }
        if let counterexamples = counterexamples {
            json["counterexamples"] = counterexamples.map { $0.toJSONObject() }
        }
        return json
    }
}
