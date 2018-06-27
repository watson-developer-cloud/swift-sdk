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

/**
 State information for the conversation. To maintain state, include the context from the previous response.
 */
public struct Context: Codable {

    /**
     The unique identifier of the conversation.
     */
    public var conversationID: String?

    /**
     For internal use only.
     */
    public var system: SystemResponse?

    /// Additional properties associated with this model.
    public var additionalProperties: [String: JSON]

    // Map each property name to the key that shall be used for encoding/decoding.
    private enum CodingKeys: String, CodingKey {
        case conversationID = "conversation_id"
        case system = "system"
        static let allValues = [conversationID, system]
    }

    /**
     Initialize a `Context` with member variables.

     - parameter conversationID: The unique identifier of the conversation.
     - parameter system: For internal use only.

     - returns: An initialized `Context`.
    */
    public init(
        conversationID: String? = nil,
        system: SystemResponse? = nil,
        additionalProperties: [String: JSON] = [:]
    )
    {
        self.conversationID = conversationID
        self.system = system
        self.additionalProperties = additionalProperties
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        conversationID = try container.decodeIfPresent(String.self, forKey: .conversationID)
        system = try container.decodeIfPresent(SystemResponse.self, forKey: .system)
        let dynamicContainer = try decoder.container(keyedBy: DynamicKeys.self)
        additionalProperties = try dynamicContainer.decode([String: JSON].self, excluding: CodingKeys.allValues)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(conversationID, forKey: .conversationID)
        try container.encodeIfPresent(system, forKey: .system)
        var dynamicContainer = encoder.container(keyedBy: DynamicKeys.self)
        try dynamicContainer.encodeIfPresent(additionalProperties)
    }

}
