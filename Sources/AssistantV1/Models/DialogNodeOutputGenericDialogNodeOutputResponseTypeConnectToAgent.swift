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

/**
 An object that describes a response with response type `connect_to_agent`.

 Enums with an associated value of DialogNodeOutputGenericDialogNodeOutputResponseTypeConnectToAgent:
    DialogNodeOutputGeneric
 */
public struct DialogNodeOutputGenericDialogNodeOutputResponseTypeConnectToAgent: Codable, Equatable {

    /**
     The type of response returned by the dialog node. The specified response type must be supported by the client
     application or channel.
     */
    public enum ResponseType: String {
        case connectToAgent = "connect_to_agent"
    }

    /**
     The type of response returned by the dialog node. The specified response type must be supported by the client
     application or channel.
     */
    public var responseType: String

    /**
     An optional message to be sent to the human agent who will be taking over the conversation.
     */
    public var messageToHumanAgent: String?

    /**
     An optional message to be displayed to the user to indicate that the conversation will be transferred to the next
     available agent.
     */
    public var agentAvailable: AgentAvailabilityMessage?

    /**
     An optional message to be displayed to the user to indicate that no online agent is available to take over the
     conversation.
     */
    public var agentUnavailable: AgentAvailabilityMessage?

    /**
     Routing or other contextual information to be used by target service desk systems.
     */
    public var transferInfo: DialogNodeOutputConnectToAgentTransferInfo?

    // Map each property name to the key that shall be used for encoding/decoding.
    private enum CodingKeys: String, CodingKey {
        case responseType = "response_type"
        case messageToHumanAgent = "message_to_human_agent"
        case agentAvailable = "agent_available"
        case agentUnavailable = "agent_unavailable"
        case transferInfo = "transfer_info"
    }

    /**
      Initialize a `DialogNodeOutputGenericDialogNodeOutputResponseTypeConnectToAgent` with member variables.

      - parameter responseType: The type of response returned by the dialog node. The specified response type must be
        supported by the client application or channel.
      - parameter messageToHumanAgent: An optional message to be sent to the human agent who will be taking over the
        conversation.
      - parameter agentAvailable: An optional message to be displayed to the user to indicate that the conversation
        will be transferred to the next available agent.
      - parameter agentUnavailable: An optional message to be displayed to the user to indicate that no online agent
        is available to take over the conversation.
      - parameter transferInfo: Routing or other contextual information to be used by target service desk systems.

      - returns: An initialized `DialogNodeOutputGenericDialogNodeOutputResponseTypeConnectToAgent`.
     */
    public init(
        responseType: String,
        messageToHumanAgent: String? = nil,
        agentAvailable: AgentAvailabilityMessage? = nil,
        agentUnavailable: AgentAvailabilityMessage? = nil,
        transferInfo: DialogNodeOutputConnectToAgentTransferInfo? = nil
    )
    {
        self.responseType = responseType
        self.messageToHumanAgent = messageToHumanAgent
        self.agentAvailable = agentAvailable
        self.agentUnavailable = agentUnavailable
        self.transferInfo = transferInfo
    }

}
