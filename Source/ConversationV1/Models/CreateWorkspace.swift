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

/** CreateWorkspace. */
public struct CreateWorkspace {

    /// The name of the workspace.
    public var name: String?

    /// The description of the workspace.
    public var description: String?

    /// The language of the workspace.
    public var language: String?

    /// An array of objects defining the intents for the workspace.
    public var intents: [CreateIntent]?

    /// An array of objects defining the entities for the workspace.
    public var entities: [CreateEntity]?

    /// An array of objects defining the nodes in the workspace dialog.
    public var dialogNodes: [CreateDialogNode]?

    /// An array of objects defining input examples that have been marked as irrelevant input.
    public var counterexamples: [CreateCounterexample]?

    /// Any metadata related to the workspace.
    public var metadata: [String: JSON]?

    /// Whether training data from the workspace can be used by IBM for general service improvements. `true` indicates that workspace training data is not to be used.
    public var learningOptOut: Bool?

    /**
     Initialize a `CreateWorkspace` with member variables.

     - parameter name: The name of the workspace.
     - parameter description: The description of the workspace.
     - parameter language: The language of the workspace.
     - parameter intents: An array of objects defining the intents for the workspace.
     - parameter entities: An array of objects defining the entities for the workspace.
     - parameter dialogNodes: An array of objects defining the nodes in the workspace dialog.
     - parameter counterexamples: An array of objects defining input examples that have been marked as irrelevant input.
     - parameter metadata: Any metadata related to the workspace.
     - parameter learningOptOut: Whether training data from the workspace can be used by IBM for general service improvements. `true` indicates that workspace training data is not to be used.

     - returns: An initialized `CreateWorkspace`.
    */
    public init(name: String? = nil, description: String? = nil, language: String? = nil, intents: [CreateIntent]? = nil, entities: [CreateEntity]? = nil, dialogNodes: [CreateDialogNode]? = nil, counterexamples: [CreateCounterexample]? = nil, metadata: [String: JSON]? = nil, learningOptOut: Bool? = nil) {
        self.name = name
        self.description = description
        self.language = language
        self.intents = intents
        self.entities = entities
        self.dialogNodes = dialogNodes
        self.counterexamples = counterexamples
        self.metadata = metadata
        self.learningOptOut = learningOptOut
    }
}

extension CreateWorkspace: Codable {

    private enum CodingKeys: String, CodingKey {
        case name = "name"
        case description = "description"
        case language = "language"
        case intents = "intents"
        case entities = "entities"
        case dialogNodes = "dialog_nodes"
        case counterexamples = "counterexamples"
        case metadata = "metadata"
        case learningOptOut = "learning_opt_out"
        static let allValues = [name, description, language, intents, entities, dialogNodes, counterexamples, metadata, learningOptOut]
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decodeIfPresent(String.self, forKey: .name)
        description = try container.decodeIfPresent(String.self, forKey: .description)
        language = try container.decodeIfPresent(String.self, forKey: .language)
        intents = try container.decodeIfPresent([CreateIntent].self, forKey: .intents)
        entities = try container.decodeIfPresent([CreateEntity].self, forKey: .entities)
        dialogNodes = try container.decodeIfPresent([CreateDialogNode].self, forKey: .dialogNodes)
        counterexamples = try container.decodeIfPresent([CreateCounterexample].self, forKey: .counterexamples)
        metadata = try container.decodeIfPresent([String: JSON].self, forKey: .metadata)
        learningOptOut = try container.decodeIfPresent(Bool.self, forKey: .learningOptOut)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(name, forKey: .name)
        try container.encodeIfPresent(description, forKey: .description)
        try container.encodeIfPresent(language, forKey: .language)
        try container.encodeIfPresent(intents, forKey: .intents)
        try container.encodeIfPresent(entities, forKey: .entities)
        try container.encodeIfPresent(dialogNodes, forKey: .dialogNodes)
        try container.encodeIfPresent(counterexamples, forKey: .counterexamples)
        try container.encodeIfPresent(metadata, forKey: .metadata)
        try container.encodeIfPresent(learningOptOut, forKey: .learningOptOut)
    }

}
