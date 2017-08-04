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

/** CreateWorkspace. */
public struct CreateWorkspace: JSONDecodable, JSONEncodable {

    /// The name of the workspace.
    public let name: String?

    /// The description of the workspace.
    public let description: String?

    /// The language of the workspace.
    public let language: String?

    /// An array of CreateIntent objects defining the intents for the workspace.
    public let intents: [CreateIntent]?

    /// An array of CreateEntity objects defining the entities for the workspace.
    public let entities: [CreateEntity]?

    /// An array of CreateDialogNode objects defining the nodes in the workspace dialog.
    public let dialogNodes: [CreateDialogNode]?

    /// An array of CreateExample objects defining input examples that have been marked as irrelevant input.
    public let counterexamples: [CreateExample]?

    /// Any metadata that is required by the workspace.
    public let metadata: [String: Any]?

    /**
     Initialize a `CreateWorkspace` with member variables.

     - parameter name: The name of the workspace.
     - parameter description: The description of the workspace.
     - parameter language: The language of the workspace.
     - parameter intents: An array of CreateIntent objects defining the intents for the workspace.
     - parameter entities: An array of CreateEntity objects defining the entities for the workspace.
     - parameter dialogNodes: An array of CreateDialogNode objects defining the nodes in the workspace dialog.
     - parameter counterexamples: An array of CreateExample objects defining input examples that have been marked as irrelevant input.
     - parameter metadata: Any metadata that is required by the workspace.

     - returns: An initialized `CreateWorkspace`.
    */
    public init(name: String? = nil, description: String? = nil, language: String? = nil, intents: [CreateIntent]? = nil, entities: [CreateEntity]? = nil, dialogNodes: [CreateDialogNode]? = nil, counterexamples: [CreateExample]? = nil, metadata: [String: Any]? = nil) {
        self.name = name
        self.description = description
        self.language = language
        self.intents = intents
        self.entities = entities
        self.dialogNodes = dialogNodes
        self.counterexamples = counterexamples
        self.metadata = metadata
    }

    // MARK: JSONDecodable
    /// Used internally to initialize a `CreateWorkspace` model from JSON.
    public init(json: JSON) throws {
        name = try? json.getString(at: "name")
        description = try? json.getString(at: "description")
        language = try? json.getString(at: "language")
        intents = try? json.decodedArray(at: "intents", type: CreateIntent.self)
        entities = try? json.decodedArray(at: "entities", type: CreateEntity.self)
        dialogNodes = try? json.decodedArray(at: "dialog_nodes", type: CreateDialogNode.self)
        counterexamples = try? json.decodedArray(at: "counterexamples", type: CreateExample.self)
        metadata = try? json.getDictionaryObject(at: "metadata")
    }

    // MARK: JSONEncodable
    /// Used internally to serialize a `CreateWorkspace` model to JSON.
    public func toJSONObject() -> Any {
        var json = [String: Any]()
        if let name = name { json["name"] = name }
        if let description = description { json["description"] = description }
        if let language = language { json["language"] = language }
        if let intents = intents {
            json["intents"] = intents.map { $0.toJSONObject() }
        }
        if let entities = entities {
            json["entities"] = entities.map { $0.toJSONObject() }
        }
        if let dialogNodes = dialogNodes {
            json["dialog_nodes"] = dialogNodes.map { $0.toJSONObject() }
        }
        if let counterexamples = counterexamples {
            json["counterexamples"] = counterexamples.map { $0.toJSONObject() }
        }
        if let metadata = metadata { json["metadata"] = metadata }
        return json
    }
}
