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

/** A request formatted for the Assistant service. */
public struct MessageRequest {

    /// An input object that includes the input text.
    public var input: InputData?

    /// Whether to return more than one intent. Set to `true` to return all matching intents.
    public var alternateIntents: Bool?

    /// State information for the conversation. Continue a conversation by including the context object from the previous response.
    public var context: Context?

    /// Entities to use when evaluating the message. Include entities from the previous response to continue using those entities rather than detecting entities in the new input.
    public var entities: [RuntimeEntity]?

    /// Intents to use when evaluating the user input. Include intents from the previous response to continue using those intents rather than trying to recognize intents in the new input.
    public var intents: [RuntimeIntent]?

    /// System output. Include the output from the previous response to maintain intermediate information over multiple requests.
    public var output: OutputData?

    /**
     Initialize a `MessageRequest` with member variables.

     - parameter input: An input object that includes the input text.
     - parameter alternateIntents: Whether to return more than one intent. Set to `true` to return all matching intents.
     - parameter context: State information for the conversation. Continue a conversation by including the context object from the previous response.
     - parameter entities: Entities to use when evaluating the message. Include entities from the previous response to continue using those entities rather than detecting entities in the new input.
     - parameter intents: Intents to use when evaluating the user input. Include intents from the previous response to continue using those intents rather than trying to recognize intents in the new input.
     - parameter output: System output. Include the output from the previous response to maintain intermediate information over multiple requests.

     - returns: An initialized `MessageRequest`.
    */
    public init(input: InputData? = nil, alternateIntents: Bool? = nil, context: Context? = nil, entities: [RuntimeEntity]? = nil, intents: [RuntimeIntent]? = nil, output: OutputData? = nil) {
        self.input = input
        self.alternateIntents = alternateIntents
        self.context = context
        self.entities = entities
        self.intents = intents
        self.output = output
    }
}

extension MessageRequest: Codable {

    private enum CodingKeys: String, CodingKey {
        case input = "input"
        case alternateIntents = "alternate_intents"
        case context = "context"
        case entities = "entities"
        case intents = "intents"
        case output = "output"
        static let allValues = [input, alternateIntents, context, entities, intents, output]
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        input = try container.decodeIfPresent(InputData.self, forKey: .input)
        alternateIntents = try container.decodeIfPresent(Bool.self, forKey: .alternateIntents)
        context = try container.decodeIfPresent(Context.self, forKey: .context)
        entities = try container.decodeIfPresent([RuntimeEntity].self, forKey: .entities)
        intents = try container.decodeIfPresent([RuntimeIntent].self, forKey: .intents)
        output = try container.decodeIfPresent(OutputData.self, forKey: .output)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(input, forKey: .input)
        try container.encodeIfPresent(alternateIntents, forKey: .alternateIntents)
        try container.encodeIfPresent(context, forKey: .context)
        try container.encodeIfPresent(entities, forKey: .entities)
        try container.encodeIfPresent(intents, forKey: .intents)
        try container.encodeIfPresent(output, forKey: .output)
    }

}
