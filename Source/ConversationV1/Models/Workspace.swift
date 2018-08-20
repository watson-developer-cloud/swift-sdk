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

/** Workspace. */
public struct Workspace: Decodable {

    /**
     The name of the workspace.
     */
    public var name: String

    /**
     The language of the workspace.
     */
    public var language: String

    /**
     The timestamp for creation of the workspace.
     */
    public var created: String?

    /**
     The timestamp for the last update to the workspace.
     */
    public var updated: String?

    /**
     The workspace ID.
     */
    public var workspaceID: String

    /**
     The description of the workspace.
     */
    public var description: String?

    /**
     Any metadata related to the workspace.
     */
    public var metadata: [String: JSON]?

    /**
     Whether training data from the workspace (including artifacts such as intents and entities) can be used by IBM for
     general service improvements. `true` indicates that workspace training data is not to be used.
     */
    public var learningOptOut: Bool?

    /**
     Global settings for the workspace.
     */
    public var systemSettings: WorkspaceSystemSettings?

    // Map each property name to the key that shall be used for encoding/decoding.
    private enum CodingKeys: String, CodingKey {
        case name = "name"
        case language = "language"
        case created = "created"
        case updated = "updated"
        case workspaceID = "workspace_id"
        case description = "description"
        case metadata = "metadata"
        case learningOptOut = "learning_opt_out"
        case systemSettings = "system_settings"
    }

}
