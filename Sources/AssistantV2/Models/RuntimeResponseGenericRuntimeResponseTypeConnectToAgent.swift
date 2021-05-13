/**
 * (C) Copyright IBM Corp. 2020, 2021.
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
 RuntimeResponseGenericRuntimeResponseTypeConnectToAgent.

 Enums with an associated value of RuntimeResponseGenericRuntimeResponseTypeConnectToAgent:
    RuntimeResponseGeneric
 */
public struct RuntimeResponseGenericRuntimeResponseTypeConnectToAgent: Codable, Equatable {

    /**
     The type of response returned by the dialog node. The specified response type must be supported by the client
     application or channel.
     */
    public var responseType: String

    /**
     A message to be sent to the human agent who will be taking over the conversation.
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

    /**
     A label identifying the topic of the conversation, derived from the **title** property of the relevant node or the
     **topic** property of the dialog node response.
     */
    public var topic: String?

    /**
     An array of objects specifying channels for which the response is intended. If **channels** is present, the
     response is intended for a built-in integration and should not be handled by an API client.
     */
    public var channels: [ResponseGenericChannel]?

    // Map each property name to the key that shall be used for encoding/decoding.
    private enum CodingKeys: String, CodingKey {
        case responseType = "response_type"
        case messageToHumanAgent = "message_to_human_agent"
        case agentAvailable = "agent_available"
        case agentUnavailable = "agent_unavailable"
        case transferInfo = "transfer_info"
        case topic = "topic"
        case channels = "channels"
    }

}
