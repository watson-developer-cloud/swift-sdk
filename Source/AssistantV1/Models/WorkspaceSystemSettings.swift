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

/**
 Global settings for the workspace.
 */
public struct WorkspaceSystemSettings: Codable, Equatable {

    /**
     Workspace settings related to the Watson Assistant tool.
     */
    public var tooling: WorkspaceSystemSettingsTooling?

    /**
     Workspace settings related to the disambiguation feature.
     **Note:** This feature is available only to Premium users.
     */
    public var disambiguation: WorkspaceSystemSettingsDisambiguation?

    /**
     For internal use only.
     */
    public var humanAgentAssist: [String: JSON]?

    // Map each property name to the key that shall be used for encoding/decoding.
    private enum CodingKeys: String, CodingKey {
        case tooling = "tooling"
        case disambiguation = "disambiguation"
        case humanAgentAssist = "human_agent_assist"
    }

    /**
     Initialize a `WorkspaceSystemSettings` with member variables.

     - parameter tooling: Workspace settings related to the Watson Assistant tool.
     - parameter disambiguation: Workspace settings related to the disambiguation feature.
       **Note:** This feature is available only to Premium users.
     - parameter humanAgentAssist: For internal use only.

     - returns: An initialized `WorkspaceSystemSettings`.
    */
    public init(
        tooling: WorkspaceSystemSettingsTooling? = nil,
        disambiguation: WorkspaceSystemSettingsDisambiguation? = nil,
        humanAgentAssist: [String: JSON]? = nil
    )
    {
        self.tooling = tooling
        self.disambiguation = disambiguation
        self.humanAgentAssist = humanAgentAssist
    }

}
