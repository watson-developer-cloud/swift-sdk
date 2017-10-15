/**
 * Copyright IBM Corporation 2017
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

/** A response from the Conversation service. */
public struct MessageResponse {

    /// The user input from the request.
    public var input: MessageInput?

    /// An array of intents recognized in the user input, sorted in descending order of confidence.
    public var intents: [RuntimeIntent]

    /// An array of entities identified in the user input.
    public var entities: [RuntimeEntity]

    /// Whether to return more than one intent. `true` indicates that all matching intents are returned.
    public var alternateIntents: Bool?

    /// State information for the conversation.
    public var context: Context

    /// Output from the dialog, including the response to the user, the nodes that were triggered, and log messages.
    public var output: OutputData

    /// Additional properties associated with this model.
    public var additionalProperties: [String: JSON]

    /**
     Initialize a `MessageResponse` with member variables.

     - parameter intents: An array of intents recognized in the user input, sorted in descending order of confidence.
     - parameter entities: An array of entities identified in the user input.
     - parameter context: State information for the conversation.
     - parameter output: Output from the dialog, including the response to the user, the nodes that were triggered, and log messages.
     - parameter input: The user input from the request.
     - parameter alternateIntents: Whether to return more than one intent. `true` indicates that all matching intents are returned.

     - returns: An initialized `MessageResponse`.
    */
    public init(intents: [RuntimeIntent], entities: [RuntimeEntity], context: Context, output: OutputData, input: MessageInput? = nil, alternateIntents: Bool? = nil, additionalProperties: [String: JSON] = [:]) {
        self.intents = intents
        self.entities = entities
        self.context = context
        self.output = output
        self.input = input
        self.alternateIntents = alternateIntents
        self.additionalProperties = additionalProperties
    }
}

extension MessageResponse: Codable {

    private enum CodingKeys: String, CodingKey {
        case input = "input"
        case intents = "intents"
        case entities = "entities"
        case alternateIntents = "alternate_intents"
        case context = "context"
        case output = "output"
        static let allValues = [input, intents, entities, alternateIntents, context, output]
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        input = try container.decodeIfPresent(MessageInput.self, forKey: .input)
        intents = try container.decode([RuntimeIntent].self, forKey: .intents)
        entities = try container.decode([RuntimeEntity].self, forKey: .entities)
        alternateIntents = try container.decodeIfPresent(Bool.self, forKey: .alternateIntents)
        context = try container.decode(Context.self, forKey: .context)
        output = try container.decode(OutputData.self, forKey: .output)
        let dynamicContainer = try decoder.container(keyedBy: DynamicKeys.self)
        additionalProperties = try dynamicContainer.decode([String: JSON].self, excluding: CodingKeys.allValues)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(input, forKey: .input)
        try container.encode(intents, forKey: .intents)
        try container.encode(entities, forKey: .entities)
        try container.encodeIfPresent(alternateIntents, forKey: .alternateIntents)
        try container.encode(context, forKey: .context)
        try container.encode(output, forKey: .output)
        var dynamicContainer = encoder.container(keyedBy: DynamicKeys.self)
        try dynamicContainer.encodeIfPresent(additionalProperties)
    }

}
