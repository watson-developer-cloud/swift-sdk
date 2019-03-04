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

/**
 Workspace settings related to the disambiguation feature.
 **Note:** This feature is available only to Premium users.
 */
public struct WorkspaceSystemSettingsDisambiguation: Codable, Equatable {

    /**
     The sensitivity of the disambiguation feature to intent detection conflicts. Set to **high** if you want the
     disambiguation feature to be triggered more often. This can be useful for testing or demonstration purposes.
     */
    public enum Sensitivity: String {
        case auto = "auto"
        case high = "high"
    }

    /**
     The text of the introductory prompt that accompanies disambiguation options presented to the user.
     */
    public var prompt: String?

    /**
     The user-facing label for the option users can select if none of the suggested options is correct. If no value is
     specified for this property, this option does not appear.
     */
    public var noneOfTheAbovePrompt: String?

    /**
     Whether the disambiguation feature is enabled for the workspace.
     */
    public var enabled: Bool?

    /**
     The sensitivity of the disambiguation feature to intent detection conflicts. Set to **high** if you want the
     disambiguation feature to be triggered more often. This can be useful for testing or demonstration purposes.
     */
    public var sensitivity: String?

    // Map each property name to the key that shall be used for encoding/decoding.
    private enum CodingKeys: String, CodingKey {
        case prompt = "prompt"
        case noneOfTheAbovePrompt = "none_of_the_above_prompt"
        case enabled = "enabled"
        case sensitivity = "sensitivity"
    }

    /**
     Initialize a `WorkspaceSystemSettingsDisambiguation` with member variables.

     - parameter prompt: The text of the introductory prompt that accompanies disambiguation options presented to the
       user.
     - parameter noneOfTheAbovePrompt: The user-facing label for the option users can select if none of the suggested
       options is correct. If no value is specified for this property, this option does not appear.
     - parameter enabled: Whether the disambiguation feature is enabled for the workspace.
     - parameter sensitivity: The sensitivity of the disambiguation feature to intent detection conflicts. Set to
       **high** if you want the disambiguation feature to be triggered more often. This can be useful for testing or
       demonstration purposes.

     - returns: An initialized `WorkspaceSystemSettingsDisambiguation`.
    */
    public init(
        prompt: String? = nil,
        noneOfTheAbovePrompt: String? = nil,
        enabled: Bool? = nil,
        sensitivity: String? = nil
    )
    {
        self.prompt = prompt
        self.noneOfTheAbovePrompt = noneOfTheAbovePrompt
        self.enabled = enabled
        self.sensitivity = sensitivity
    }

}
