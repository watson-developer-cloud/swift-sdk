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
 An output object that includes the response to the user, the nodes that were hit, and messages from the log.
 */
public struct OutputData: Codable {

    /**
     An array of up to 50 messages logged with the request.
     */
    public var logMessages: [LogMessage]

    /**
     An array of responses to the user.
     */
    public var text: [String]

    /**
     An array of the nodes that were triggered to create the response, in the order in which they were visited. This
     information is useful for debugging and for tracing the path taken through the node tree.
     */
    public var nodesVisited: [String]?

    /**
     An array of objects containing detailed diagnostic information about the nodes that were triggered during
     processing of the input message. Included only if **nodes_visited_details** is set to `true` in the message
     request.
     */
    public var nodesVisitedDetails: [DialogNodeVisitedDetails]?

    /// Additional properties associated with this model.
    public var additionalProperties: [String: JSON]

    // Map each property name to the key that shall be used for encoding/decoding.
    private enum CodingKeys: String, CodingKey {
        case logMessages = "log_messages"
        case text = "text"
        case nodesVisited = "nodes_visited"
        case nodesVisitedDetails = "nodes_visited_details"
        static let allValues = [logMessages, text, nodesVisited, nodesVisitedDetails]
    }

    /**
     Initialize a `OutputData` with member variables.

     - parameter logMessages: An array of up to 50 messages logged with the request.
     - parameter text: An array of responses to the user.
     - parameter nodesVisited: An array of the nodes that were triggered to create the response, in the order in
       which they were visited. This information is useful for debugging and for tracing the path taken through the node
       tree.
     - parameter nodesVisitedDetails: An array of objects containing detailed diagnostic information about the nodes
       that were triggered during processing of the input message. Included only if **nodes_visited_details** is set to
       `true` in the message request.

     - returns: An initialized `OutputData`.
    */
    public init(
        logMessages: [LogMessage],
        text: [String],
        nodesVisited: [String]? = nil,
        nodesVisitedDetails: [DialogNodeVisitedDetails]? = nil,
        additionalProperties: [String: JSON] = [:]
    )
    {
        self.logMessages = logMessages
        self.text = text
        self.nodesVisited = nodesVisited
        self.nodesVisitedDetails = nodesVisitedDetails
        self.additionalProperties = additionalProperties
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        logMessages = try container.decode([LogMessage].self, forKey: .logMessages)
        text = try container.decode([String].self, forKey: .text)
        nodesVisited = try container.decodeIfPresent([String].self, forKey: .nodesVisited)
        nodesVisitedDetails = try container.decodeIfPresent([DialogNodeVisitedDetails].self, forKey: .nodesVisitedDetails)
        let dynamicContainer = try decoder.container(keyedBy: DynamicKeys.self)
        additionalProperties = try dynamicContainer.decode([String: JSON].self, excluding: CodingKeys.allValues)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(logMessages, forKey: .logMessages)
        try container.encode(text, forKey: .text)
        try container.encodeIfPresent(nodesVisited, forKey: .nodesVisited)
        try container.encodeIfPresent(nodesVisitedDetails, forKey: .nodesVisitedDetails)
        var dynamicContainer = encoder.container(keyedBy: DynamicKeys.self)
        try dynamicContainer.encodeIfPresent(additionalProperties)
    }

}
