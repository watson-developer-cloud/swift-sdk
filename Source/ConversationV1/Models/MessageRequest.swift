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

/** A request formatted for the Conversation service. */
public struct MessageRequest {

    /// An input object that includes the input text.
    public var input: InputData?

    /// Whether to return more than one intent. Set to `true` to return all matching intents.
    public var alternateIntents: Bool?

    /// State information for the conversation. Continue a conversation by including the context object from the previous response.
    public var context: Context?

    /// Include the entities from the previous response when they do not need to change and to prevent Watson from trying to identify them.
    public var entities: [RuntimeEntity]?

    /// An array of name-confidence pairs for the user input. Include the intents from the previous response when they do not need to change and to prevent Watson from trying to identify them.
    public var intents: [RuntimeIntent]?

    /// System output. Include the output from the request when you have several requests within the same Dialog turn to pass back in the intermediate information.
    public var output: OutputData?

    /**
     Initialize a `MessageRequest` with member variables.

     - parameter input: An input object that includes the input text.
     - parameter alternateIntents: Whether to return more than one intent. Set to `true` to return all matching intents.
     - parameter context: State information for the conversation. Continue a conversation by including the context object from the previous response.
     - parameter entities: Include the entities from the previous response when they do not need to change and to prevent Watson from trying to identify them.
     - parameter intents: An array of name-confidence pairs for the user input. Include the intents from the previous response when they do not need to change and to prevent Watson from trying to identify them.
     - parameter output: System output. Include the output from the request when you have several requests within the same Dialog turn to pass back in the intermediate information.

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
