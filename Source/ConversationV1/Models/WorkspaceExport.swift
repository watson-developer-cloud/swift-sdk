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

/** WorkspaceExport. */
public struct WorkspaceExport {

    /// The current status of the workspace.
    public enum Status: String {
        case nonExistent = "Non Existent"
        case training = "Training"
        case failed = "Failed"
        case available = "Available"
        case unavailable = "Unavailable"
    }

    /// The name of the workspace.
    public var name: String

    /// The description of the workspace.
    public var description: String

    /// The language of the workspace.
    public var language: String

    /// Any metadata that is required by the workspace.
    public var metadata: [String: JSON]

    /// The timestamp for creation of the workspace.
    public var created: String

    /// The timestamp for the last update to the workspace.
    public var updated: String

    /// The workspace ID.
    public var workspaceID: String

    /// The current status of the workspace.
    public var status: String

    /// Whether training data from the workspace can be used by IBM for general service improvements. `true` indicates that workspace training data is not to be used.
    public var learningOptOut: Bool

    /// An array of intents.
    public var intents: [IntentExport]?

    /// An array of entities.
    public var entities: [EntityExport]?

    /// An array of counterexamples.
    public var counterexamples: [Counterexample]?

    /// An array of objects describing the dialog nodes in the workspace.
    public var dialogNodes: [DialogNode]?

    /**
     Initialize a `WorkspaceExport` with member variables.

     - parameter name: The name of the workspace.
     - parameter description: The description of the workspace.
     - parameter language: The language of the workspace.
     - parameter metadata: Any metadata that is required by the workspace.
     - parameter created: The timestamp for creation of the workspace.
     - parameter updated: The timestamp for the last update to the workspace.
     - parameter workspaceID: The workspace ID.
     - parameter status: The current status of the workspace.
     - parameter learningOptOut: Whether training data from the workspace can be used by IBM for general service improvements. `true` indicates that workspace training data is not to be used.
     - parameter intents: An array of intents.
     - parameter entities: An array of entities.
     - parameter counterexamples: An array of counterexamples.
     - parameter dialogNodes: An array of objects describing the dialog nodes in the workspace.

     - returns: An initialized `WorkspaceExport`.
    */
    public init(name: String, description: String, language: String, metadata: [String: JSON], created: String, updated: String, workspaceID: String, status: String, learningOptOut: Bool, intents: [IntentExport]? = nil, entities: [EntityExport]? = nil, counterexamples: [Counterexample]? = nil, dialogNodes: [DialogNode]? = nil) {
        self.name = name
        self.description = description
        self.language = language
        self.metadata = metadata
        self.created = created
        self.updated = updated
        self.workspaceID = workspaceID
        self.status = status
        self.learningOptOut = learningOptOut
        self.intents = intents
        self.entities = entities
        self.counterexamples = counterexamples
        self.dialogNodes = dialogNodes
    }
}

extension WorkspaceExport: Codable {

    private enum CodingKeys: String, CodingKey {
        case name = "name"
        case description = "description"
        case language = "language"
        case metadata = "metadata"
        case created = "created"
        case updated = "updated"
        case workspaceID = "workspace_id"
        case status = "status"
        case learningOptOut = "learning_opt_out"
        case intents = "intents"
        case entities = "entities"
        case counterexamples = "counterexamples"
        case dialogNodes = "dialog_nodes"
        static let allValues = [name, description, language, metadata, created, updated, workspaceID, status, learningOptOut, intents, entities, counterexamples, dialogNodes]
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decode(String.self, forKey: .name)
        description = try container.decode(String.self, forKey: .description)
        language = try container.decode(String.self, forKey: .language)
        metadata = try container.decode([String: JSON].self, forKey: .metadata)
        created = try container.decode(String.self, forKey: .created)
        updated = try container.decode(String.self, forKey: .updated)
        workspaceID = try container.decode(String.self, forKey: .workspaceID)
        status = try container.decode(String.self, forKey: .status)
        learningOptOut = try container.decode(Bool.self, forKey: .learningOptOut)
        intents = try container.decodeIfPresent([IntentExport].self, forKey: .intents)
        entities = try container.decodeIfPresent([EntityExport].self, forKey: .entities)
        counterexamples = try container.decodeIfPresent([Counterexample].self, forKey: .counterexamples)
        dialogNodes = try container.decodeIfPresent([DialogNode].self, forKey: .dialogNodes)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(description, forKey: .description)
        try container.encode(language, forKey: .language)
        try container.encode(metadata, forKey: .metadata)
        try container.encode(created, forKey: .created)
        try container.encode(updated, forKey: .updated)
        try container.encode(workspaceID, forKey: .workspaceID)
        try container.encode(status, forKey: .status)
        try container.encode(learningOptOut, forKey: .learningOptOut)
        try container.encodeIfPresent(intents, forKey: .intents)
        try container.encodeIfPresent(entities, forKey: .entities)
        try container.encodeIfPresent(counterexamples, forKey: .counterexamples)
        try container.encodeIfPresent(dialogNodes, forKey: .dialogNodes)
    }

}
