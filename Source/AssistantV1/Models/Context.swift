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
 State information for the conversation. To maintain state, include the context from the previous response.
 */
public struct Context: Codable, Equatable {

    /**
     The unique identifier of the conversation.
     */
    public var conversationID: String?

    /**
     For internal use only.
     */
    public var system: SystemResponse?

    /**
     Metadata related to the message.
     */
    public var metadata: MessageContextMetadata?

    /// Additional properties associated with this model.
    public var additionalProperties: [String: JSON]

    // Map each property name to the key that shall be used for encoding/decoding.
    private enum CodingKeys: String, CodingKey {
        case conversationID = "conversation_id"
        case system = "system"
        case metadata = "metadata"
        static let allValues = [conversationID, system, metadata]
    }

    /**
     Initialize a `Context` with member variables.

     - parameter conversationID: The unique identifier of the conversation.
     - parameter system: For internal use only.
     - parameter metadata: Metadata related to the message.

     - returns: An initialized `Context`.
    */
    public init(
        conversationID: String? = nil,
        system: SystemResponse? = nil,
        metadata: MessageContextMetadata? = nil,
        additionalProperties: [String: JSON] = [:]
    )
    {
        self.conversationID = conversationID
        self.system = system
        self.metadata = metadata
        self.additionalProperties = additionalProperties
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        conversationID = try container.decodeIfPresent(String.self, forKey: .conversationID)
        system = try container.decodeIfPresent(SystemResponse.self, forKey: .system)
        metadata = try container.decodeIfPresent(MessageContextMetadata.self, forKey: .metadata)
        let dynamicContainer = try decoder.container(keyedBy: DynamicKeys.self)
        additionalProperties = try dynamicContainer.decode([String: JSON].self, excluding: CodingKeys.allValues)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(conversationID, forKey: .conversationID)
        try container.encodeIfPresent(system, forKey: .system)
        try container.encodeIfPresent(metadata, forKey: .metadata)
        var dynamicContainer = encoder.container(keyedBy: DynamicKeys.self)
        try dynamicContainer.encodeIfPresent(additionalProperties)
    }

}
