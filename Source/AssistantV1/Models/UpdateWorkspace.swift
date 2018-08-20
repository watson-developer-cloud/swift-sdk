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
import RestKit

/** UpdateWorkspace. */
public struct UpdateWorkspace: Encodable {

    /**
     The name of the workspace. This string cannot contain carriage return, newline, or tab characters, and it must be
     no longer than 64 characters.
     */
    public var name: String?

    /**
     The description of the workspace. This string cannot contain carriage return, newline, or tab characters, and it
     must be no longer than 128 characters.
     */
    public var description: String?

    /**
     The language of the workspace.
     */
    public var language: String?

    /**
     An array of objects defining the intents for the workspace.
     */
    public var intents: [CreateIntent]?

    /**
     An array of objects defining the entities for the workspace.
     */
    public var entities: [CreateEntity]?

    /**
     An array of objects defining the nodes in the workspace dialog.
     */
    public var dialogNodes: [CreateDialogNode]?

    /**
     An array of objects defining input examples that have been marked as irrelevant input.
     */
    public var counterexamples: [CreateCounterexample]?

    /**
     Any metadata related to the workspace.
     */
    public var metadata: [String: JSON]?

    /**
     Whether training data from the workspace can be used by IBM for general service improvements. `true` indicates that
     workspace training data is not to be used.
     */
    public var learningOptOut: Bool?

    /**
     Global settings for the workspace.
     */
    public var systemSettings: WorkspaceSystemSettings?

    // Map each property name to the key that shall be used for encoding/decoding.
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
        case systemSettings = "system_settings"
    }

    /**
     Initialize a `UpdateWorkspace` with member variables.

     - parameter name: The name of the workspace. This string cannot contain carriage return, newline, or tab
       characters, and it must be no longer than 64 characters.
     - parameter description: The description of the workspace. This string cannot contain carriage return, newline,
       or tab characters, and it must be no longer than 128 characters.
     - parameter language: The language of the workspace.
     - parameter intents: An array of objects defining the intents for the workspace.
     - parameter entities: An array of objects defining the entities for the workspace.
     - parameter dialogNodes: An array of objects defining the nodes in the workspace dialog.
     - parameter counterexamples: An array of objects defining input examples that have been marked as irrelevant
       input.
     - parameter metadata: Any metadata related to the workspace.
     - parameter learningOptOut: Whether training data from the workspace can be used by IBM for general service
       improvements. `true` indicates that workspace training data is not to be used.
     - parameter systemSettings: Global settings for the workspace.

     - returns: An initialized `UpdateWorkspace`.
    */
    public init(
        name: String? = nil,
        description: String? = nil,
        language: String? = nil,
        intents: [CreateIntent]? = nil,
        entities: [CreateEntity]? = nil,
        dialogNodes: [CreateDialogNode]? = nil,
        counterexamples: [CreateCounterexample]? = nil,
        metadata: [String: JSON]? = nil,
        learningOptOut: Bool? = nil,
        systemSettings: WorkspaceSystemSettings? = nil
    )
    {
        self.name = name
        self.description = description
        self.language = language
        self.intents = intents
        self.entities = entities
        self.dialogNodes = dialogNodes
        self.counterexamples = counterexamples
        self.metadata = metadata
        self.learningOptOut = learningOptOut
        self.systemSettings = systemSettings
    }

}
