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

/** WorkspaceExport. */
public struct WorkspaceExport: Codable, Equatable {

    /**
     The current status of the workspace.
     */
    public enum Status: String {
        case nonExistent = "Non Existent"
        case training = "Training"
        case failed = "Failed"
        case available = "Available"
        case unavailable = "Unavailable"
    }

    /**
     The name of the workspace.
     */
    public var name: String

    /**
     The description of the workspace.
     */
    public var description: String

    /**
     The language of the workspace.
     */
    public var language: String

    /**
     Any metadata that is required by the workspace.
     */
    public var metadata: [String: JSON]

    /**
     The timestamp for creation of the workspace.
     */
    public var created: Date?

    /**
     The timestamp for the last update to the workspace.
     */
    public var updated: Date?

    /**
     The workspace ID of the workspace.
     */
    public var workspaceID: String

    /**
     The current status of the workspace.
     */
    public var status: String

    /**
     Whether training data from the workspace can be used by IBM for general service improvements. `true` indicates that
     workspace training data is not to be used.
     */
    public var learningOptOut: Bool

    /**
     Global settings for the workspace.
     */
    public var systemSettings: WorkspaceSystemSettings?

    /**
     An array of intents.
     */
    public var intents: [IntentExport]?

    /**
     An array of entities.
     */
    public var entities: [EntityExport]?

    /**
     An array of counterexamples.
     */
    public var counterexamples: [Counterexample]?

    /**
     An array of objects describing the dialog nodes in the workspace.
     */
    public var dialogNodes: [DialogNode]?

    // Map each property name to the key that shall be used for encoding/decoding.
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
        case systemSettings = "system_settings"
        case intents = "intents"
        case entities = "entities"
        case counterexamples = "counterexamples"
        case dialogNodes = "dialog_nodes"
    }

}
