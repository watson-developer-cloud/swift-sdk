/**
 * (C) Copyright IBM Corp. 2018, 2020.
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

    /**
     Whether the order in which disambiguation suggestions are presented should be randomized (but still influenced by
     relative confidence).
     */
    public var randomize: Bool?

    /**
     The maximum number of disambigation suggestions that can be included in a `suggestion` response.
     */
    public var maxSuggestions: Int?

    /**
     For internal use only.
     */
    public var suggestionTextPolicy: String?

    // Map each property name to the key that shall be used for encoding/decoding.
    private enum CodingKeys: String, CodingKey {
        case prompt = "prompt"
        case noneOfTheAbovePrompt = "none_of_the_above_prompt"
        case enabled = "enabled"
        case sensitivity = "sensitivity"
        case randomize = "randomize"
        case maxSuggestions = "max_suggestions"
        case suggestionTextPolicy = "suggestion_text_policy"
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
      - parameter randomize: Whether the order in which disambiguation suggestions are presented should be randomized
        (but still influenced by relative confidence).
      - parameter maxSuggestions: The maximum number of disambigation suggestions that can be included in a
        `suggestion` response.
      - parameter suggestionTextPolicy: For internal use only.

      - returns: An initialized `WorkspaceSystemSettingsDisambiguation`.
     */
    public init(
        prompt: String? = nil,
        noneOfTheAbovePrompt: String? = nil,
        enabled: Bool? = nil,
        sensitivity: String? = nil,
        randomize: Bool? = nil,
        maxSuggestions: Int? = nil,
        suggestionTextPolicy: String? = nil
    )
    {
        self.prompt = prompt
        self.noneOfTheAbovePrompt = noneOfTheAbovePrompt
        self.enabled = enabled
        self.sensitivity = sensitivity
        self.randomize = randomize
        self.maxSuggestions = maxSuggestions
        self.suggestionTextPolicy = suggestionTextPolicy
    }

}
