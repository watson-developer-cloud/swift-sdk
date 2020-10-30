/**
 * (C) Copyright IBM Corp. 2020.
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
 System context data used by the skill.
 */
public struct MessageContextSkillSystem: Codable, Equatable {

    /**
     An encoded string that represents the current conversation state. By saving this value and then sending it in the
     context of a subsequent message request, you can return to an earlier point in the conversation. If you are using
     stateful sessions, you can also use a stored state value to restore a paused conversation whose session is expired.
     */
    public var state: String?

    /// Additional properties associated with this model.
    public var additionalProperties: [String: JSON]

    // Map each property name to the key that shall be used for encoding/decoding.
    private enum CodingKeys: String, CodingKey {
        case state = "state"
        static let allValues = [state]
    }

    /**
      Initialize a `MessageContextSkillSystem` with member variables.

      - parameter state: An encoded string that represents the current conversation state. By saving this value and
        then sending it in the context of a subsequent message request, you can return to an earlier point in the
        conversation. If you are using stateful sessions, you can also use a stored state value to restore a paused
        conversation whose session is expired.

      - returns: An initialized `MessageContextSkillSystem`.
     */
    public init(
        state: String? = nil,
        additionalProperties: [String: JSON] = [:]
    )
    {
        self.state = state
        self.additionalProperties = additionalProperties
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        state = try container.decodeIfPresent(String.self, forKey: .state)
        let dynamicContainer = try decoder.container(keyedBy: DynamicKeys.self)
        additionalProperties = try dynamicContainer.decode([String: JSON].self, excluding: CodingKeys.allValues)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(state, forKey: .state)
        var dynamicContainer = encoder.container(keyedBy: DynamicKeys.self)
        try dynamicContainer.encodeIfPresent(additionalProperties)
    }

}
