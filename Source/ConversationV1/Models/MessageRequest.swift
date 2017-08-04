/**
 * Copyright IBM Corporation 2016, 2017
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

/** A request formatted for the Conversation service. */
public struct MessageRequest: JSONDecodable, JSONEncodable {

    private let input: Input?
    private let alternateIntents: Bool?
    private let context: Context?
    private let entities: [Entity]?
    private let intents: [Intent]?
    private let output: Output?

    /**
     Create a `MessageRequest`.

     - parameter input: An input object that includes the input text.
     - parameter alternateIntents: Whether to return more than one intent. Set to `true` to return
        all matching intents. For example, return all intents when the confidence is not high
        to allow users to choose their intent.
     - parameter context: State information for the conversation. Include the context object from
        the previous response when you send multiple requests for the same conversation.
     - parameter entities: Include the entities from a previous response when they do not need to
        change and to prevent Watson from trying to identify them.
     - parameter intents: An array of name-confidence pairs for the user input. Include the intents
        from the request when they do not need to change so that Watson does not try to identify
        them.
     - parameter output: System output. Include the output from the request when you have several
        requests within the same Dialog turn to pass back in the intermediate information.
     */
    public init(
        input: Input? = nil,
        alternateIntents: Bool? = nil,
        context: Context? = nil,
        entities: [Entity]? = nil,
        intents: [Intent]? = nil,
        output: Output? = nil)
    {
        self.input = input
        self.alternateIntents = alternateIntents
        self.context = context
        self.entities = entities
        self.intents = intents
        self.output = output
    }

    /**
     Create a `MessageRequest`.

     - parameter text: The input text.
     - parameter alternateIntents: Whether to return more than one intent. Set to `true` to return
        all matching intents. For example, return all intents when the confidence is not high
        to allow users to choose their intent.
     - parameter context: State information for the conversation. Include the context object from
        the previous response when you send multiple requests for the same conversation.
     - parameter entities: Include the entities from a previous response when they do not need to
        change and to prevent Watson from trying to identify them.
     - parameter intents: An array of name-confidence pairs for the user input. Include the intents
        from the request when they do not need to change so that Watson does not try to identify
        them.
     - parameter output: System output. Include the output from the request when you have several
        requests within the same Dialog turn to pass back in the intermediate information.
     */
    public init(
        text: String,
        alternateIntents: Bool? = nil,
        context: Context? = nil,
        entities: [Entity]? = nil,
        intents: [Intent]? = nil,
        output: Output? = nil)
    {
        self.input = Input(text: text)
        self.alternateIntents = alternateIntents
        self.context = context
        self.entities = entities
        self.intents = intents
        self.output = output
    }

    // MARK: JSONDecodable
    /// Used internally to initialize a `MessageRequest` model from JSON.
    public init(json: JSON) throws {
        input = try? json.decode(at: "input", type: Input.self)
        alternateIntents = try? json.getBool(at: "alternate_intents")
        context = try? json.decode(at: "context", type: Context.self)
        entities = try? json.decodedArray(at: "entities", type: Entity.self)
        intents = try? json.decodedArray(at: "intents", type: Intent.self)
        output = try? json.decode(at: "output", type: Output.self)
    }

    /// Used internally to serialize a `MessageRequest` model to JSON.
    public func toJSONObject() -> Any {
        var json = [String: Any]()
        if let input = input { json["input"] = input.toJSONObject() }
        if let alternateIntents = alternateIntents {
            json["alternate_intents"] = alternateIntents
        }
        if let context = context {
            json["context"] = context.toJSONObject()
        }
        if let entities = entities {
            json["entities"] = entities.map { $0.toJSONObject() }
        }
        if let intents = intents {
            json["intents"] = intents.map { $0.toJSONObject() }
        }
        if let output = output {
            json["output"] = output.toJSONObject()
        }
        return json
    }
}
