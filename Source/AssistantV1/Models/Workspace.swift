/**
 * Copyright IBM Corporation 2019
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

/** Workspace. */
public struct Workspace: Codable, Equatable {

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
     The name of the workspace. This string cannot contain carriage return, newline, or tab characters, and it must be
     no longer than 64 characters.
     */
    public var name: String

    /**
     The description of the workspace. This string cannot contain carriage return, newline, or tab characters, and it
     must be no longer than 128 characters.
     */
    public var description: String?

    /**
     The language of the workspace.
     */
    public var language: String

    /**
     Any metadata related to the workspace.
     */
    public var metadata: [String: JSON]?

    /**
     Whether training data from the workspace (including artifacts such as intents and entities) can be used by IBM for
     general service improvements. `true` indicates that workspace training data is not to be used.
     */
    public var learningOptOut: Bool

    /**
     Global settings for the workspace.
     */
    public var systemSettings: WorkspaceSystemSettings?

    /**
     The workspace ID of the workspace.
     */
    public var workspaceID: String

    /**
     The current status of the workspace.
     */
    public var status: String?

    /**
     The timestamp for creation of the object.
     */
    public var created: Date?

    /**
     The timestamp for the most recent update to the object.
     */
    public var updated: Date?

    /**
     An array of intents.
     */
    public var intents: [Intent]?

    /**
     An array of objects describing the entities for the workspace.
     */
    public var entities: [Entity]?

    /**
     An array of objects describing the dialog nodes in the workspace.
     */
    public var dialogNodes: [DialogNode]?

    /**
     An array of counterexamples.
     */
    public var counterexamples: [Counterexample]?

    // Map each property name to the key that shall be used for encoding/decoding.
    private enum CodingKeys: String, CodingKey {
        case name = "name"
        case description = "description"
        case language = "language"
        case metadata = "metadata"
        case learningOptOut = "learning_opt_out"
        case systemSettings = "system_settings"
        case workspaceID = "workspace_id"
        case status = "status"
        case created = "created"
        case updated = "updated"
        case intents = "intents"
        case entities = "entities"
        case dialogNodes = "dialog_nodes"
        case counterexamples = "counterexamples"
    }

}
