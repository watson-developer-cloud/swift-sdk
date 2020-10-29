/**
 * (C) Copyright IBM Corp. 2019.
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
 The dialog output that will be returned from the Watson Assistant service if the user selects the corresponding option.
 */
public struct DialogSuggestionOutput: Codable, Equatable {

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

    /**
     An array of responses to the user.
     */
    public var text: [String]

    /**
     Output intended for any channel. It is the responsibility of the client application to implement the supported
     response types.
     */
    public var generic: [DialogSuggestionResponseGeneric]?

    /// Additional properties associated with this model.
    public var additionalProperties: [String: JSON]

    // Map each property name to the key that shall be used for encoding/decoding.
    private enum CodingKeys: String, CodingKey {
        case nodesVisited = "nodes_visited"
        case nodesVisitedDetails = "nodes_visited_details"
        case text = "text"
        case generic = "generic"
        static let allValues = [nodesVisited, nodesVisitedDetails, text, generic]
    }

    /**
      Initialize a `DialogSuggestionOutput` with member variables.

      - parameter text: An array of responses to the user.
      - parameter nodesVisited: An array of the nodes that were triggered to create the response, in the order in
        which they were visited. This information is useful for debugging and for tracing the path taken through the node
        tree.
      - parameter nodesVisitedDetails: An array of objects containing detailed diagnostic information about the nodes
        that were triggered during processing of the input message. Included only if **nodes_visited_details** is set to
        `true` in the message request.
      - parameter generic: Output intended for any channel. It is the responsibility of the client application to
        implement the supported response types.

      - returns: An initialized `DialogSuggestionOutput`.
     */
    public init(
        text: [String],
        nodesVisited: [String]? = nil,
        nodesVisitedDetails: [DialogNodeVisitedDetails]? = nil,
        generic: [DialogSuggestionResponseGeneric]? = nil,
        additionalProperties: [String: JSON] = [:]
    )
    {
        self.text = text
        self.nodesVisited = nodesVisited
        self.nodesVisitedDetails = nodesVisitedDetails
        self.generic = generic
        self.additionalProperties = additionalProperties
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        nodesVisited = try container.decodeIfPresent([String].self, forKey: .nodesVisited)
        nodesVisitedDetails = try container.decodeIfPresent([DialogNodeVisitedDetails].self, forKey: .nodesVisitedDetails)
        text = try container.decode([String].self, forKey: .text)
        generic = try container.decodeIfPresent([DialogSuggestionResponseGeneric].self, forKey: .generic)
        let dynamicContainer = try decoder.container(keyedBy: DynamicKeys.self)
        additionalProperties = try dynamicContainer.decode([String: JSON].self, excluding: CodingKeys.allValues)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(nodesVisited, forKey: .nodesVisited)
        try container.encodeIfPresent(nodesVisitedDetails, forKey: .nodesVisitedDetails)
        try container.encode(text, forKey: .text)
        try container.encodeIfPresent(generic, forKey: .generic)
        var dynamicContainer = encoder.container(keyedBy: DynamicKeys.self)
        try dynamicContainer.encodeIfPresent(additionalProperties)
    }

}
