/**
 * (C) Copyright IBM Corp. 2022.
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
import IBMSwiftSDKCore

/**
 Global settings for the workspace.
 */
public struct WorkspaceSystemSettings: Codable, Equatable {

    /**
     Workspace settings related to the Watson Assistant user interface.
     */
    public var tooling: WorkspaceSystemSettingsTooling?

    /**
     Workspace settings related to the disambiguation feature.
     */
    public var disambiguation: WorkspaceSystemSettingsDisambiguation?

    /**
     For internal use only.
     */
    public var humanAgentAssist: [String: JSON]?

    /**
     Whether spelling correction is enabled for the workspace.
     */
    public var spellingSuggestions: Bool?

    /**
     Whether autocorrection is enabled for the workspace. If spelling correction is enabled and this property is
     `false`, any suggested corrections are returned in the **suggested_text** property of the message response. If this
     property is `true`, any corrections are automatically applied to the user input, and the original text is returned
     in the **original_text** property of the message response.
     */
    public var spellingAutoCorrect: Bool?

    /**
     Workspace settings related to the behavior of system entities.
     */
    public var systemEntities: WorkspaceSystemSettingsSystemEntities?

    /**
     Workspace settings related to detection of irrelevant input.
     */
    public var offTopic: WorkspaceSystemSettingsOffTopic?

    /// Additional properties associated with this model.
    public var additionalProperties: [String: JSON]

    // Map each property name to the key that shall be used for encoding/decoding.
    private enum CodingKeys: String, CodingKey {
        case tooling = "tooling"
        case disambiguation = "disambiguation"
        case humanAgentAssist = "human_agent_assist"
        case spellingSuggestions = "spelling_suggestions"
        case spellingAutoCorrect = "spelling_auto_correct"
        case systemEntities = "system_entities"
        case offTopic = "off_topic"
        static let allValues = [tooling, disambiguation, humanAgentAssist, spellingSuggestions, spellingAutoCorrect, systemEntities, offTopic]
    }

    /**
      Initialize a `WorkspaceSystemSettings` with member variables.

      - parameter tooling: Workspace settings related to the Watson Assistant user interface.
      - parameter disambiguation: Workspace settings related to the disambiguation feature.
      - parameter humanAgentAssist: For internal use only.
      - parameter spellingSuggestions: Whether spelling correction is enabled for the workspace.
      - parameter spellingAutoCorrect: Whether autocorrection is enabled for the workspace. If spelling correction is
        enabled and this property is `false`, any suggested corrections are returned in the **suggested_text** property
        of the message response. If this property is `true`, any corrections are automatically applied to the user input,
        and the original text is returned in the **original_text** property of the message response.
      - parameter systemEntities: Workspace settings related to the behavior of system entities.
      - parameter offTopic: Workspace settings related to detection of irrelevant input.

      - returns: An initialized `WorkspaceSystemSettings`.
     */
    public init(
        tooling: WorkspaceSystemSettingsTooling? = nil,
        disambiguation: WorkspaceSystemSettingsDisambiguation? = nil,
        humanAgentAssist: [String: JSON]? = nil,
        spellingSuggestions: Bool? = nil,
        spellingAutoCorrect: Bool? = nil,
        systemEntities: WorkspaceSystemSettingsSystemEntities? = nil,
        offTopic: WorkspaceSystemSettingsOffTopic? = nil,
        additionalProperties: [String: JSON] = [:]
    )
    {
        self.tooling = tooling
        self.disambiguation = disambiguation
        self.humanAgentAssist = humanAgentAssist
        self.spellingSuggestions = spellingSuggestions
        self.spellingAutoCorrect = spellingAutoCorrect
        self.systemEntities = systemEntities
        self.offTopic = offTopic
        self.additionalProperties = additionalProperties
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        tooling = try container.decodeIfPresent(WorkspaceSystemSettingsTooling.self, forKey: .tooling)
        disambiguation = try container.decodeIfPresent(WorkspaceSystemSettingsDisambiguation.self, forKey: .disambiguation)
        humanAgentAssist = try container.decodeIfPresent([String: JSON].self, forKey: .humanAgentAssist)
        spellingSuggestions = try container.decodeIfPresent(Bool.self, forKey: .spellingSuggestions)
        spellingAutoCorrect = try container.decodeIfPresent(Bool.self, forKey: .spellingAutoCorrect)
        systemEntities = try container.decodeIfPresent(WorkspaceSystemSettingsSystemEntities.self, forKey: .systemEntities)
        offTopic = try container.decodeIfPresent(WorkspaceSystemSettingsOffTopic.self, forKey: .offTopic)
        let dynamicContainer = try decoder.container(keyedBy: DynamicKeys.self)
        additionalProperties = try dynamicContainer.decode([String: JSON].self, excluding: CodingKeys.allValues)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(tooling, forKey: .tooling)
        try container.encodeIfPresent(disambiguation, forKey: .disambiguation)
        try container.encodeIfPresent(humanAgentAssist, forKey: .humanAgentAssist)
        try container.encodeIfPresent(spellingSuggestions, forKey: .spellingSuggestions)
        try container.encodeIfPresent(spellingAutoCorrect, forKey: .spellingAutoCorrect)
        try container.encodeIfPresent(systemEntities, forKey: .systemEntities)
        try container.encodeIfPresent(offTopic, forKey: .offTopic)
        var dynamicContainer = encoder.container(keyedBy: DynamicKeys.self)
        try dynamicContainer.encodeIfPresent(additionalProperties)
    }

}
