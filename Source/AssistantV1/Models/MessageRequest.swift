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
 A message request formatted for the Watson Assistant service.
 */
public struct MessageRequest: Codable, Equatable {

    /**
     The user input.
     */
    public var input: InputData?

    /**
     Whether to return more than one intent. Set to `true` to return all matching intents.
     */
    public var alternateIntents: Bool?

    /**
     State information for the conversation. To maintain state, include the context from the previous response.
     */
    public var context: Context?

    /**
     Entities to use when evaluating the message. Include entities from the previous response to continue using those
     entities rather than detecting entities in the new input.
     */
    public var entities: [RuntimeEntity]?

    /**
     Intents to use when evaluating the user input. Include intents from the previous response to continue using those
     intents rather than trying to recognize intents in the new input.
     */
    public var intents: [RuntimeIntent]?

    /**
     An output object that includes the response to the user, the dialog nodes that were triggered, and messages from
     the log.
     */
    public var output: OutputData?

    // Map each property name to the key that shall be used for encoding/decoding.
    private enum CodingKeys: String, CodingKey {
        case input = "input"
        case alternateIntents = "alternate_intents"
        case context = "context"
        case entities = "entities"
        case intents = "intents"
        case output = "output"
    }

    /**
     Initialize a `MessageRequest` with member variables.

     - parameter input: The user input.
     - parameter alternateIntents: Whether to return more than one intent. Set to `true` to return all matching
       intents.
     - parameter context: State information for the conversation. To maintain state, include the context from the
       previous response.
     - parameter entities: Entities to use when evaluating the message. Include entities from the previous response
       to continue using those entities rather than detecting entities in the new input.
     - parameter intents: Intents to use when evaluating the user input. Include intents from the previous response
       to continue using those intents rather than trying to recognize intents in the new input.
     - parameter output: An output object that includes the response to the user, the dialog nodes that were
       triggered, and messages from the log.

     - returns: An initialized `MessageRequest`.
    */
    public init(
        input: InputData? = nil,
        alternateIntents: Bool? = nil,
        context: Context? = nil,
        entities: [RuntimeEntity]? = nil,
        intents: [RuntimeIntent]? = nil,
        output: OutputData? = nil
    )
    {
        self.input = input
        self.alternateIntents = alternateIntents
        self.context = context
        self.entities = entities
        self.intents = intents
        self.output = output
    }

}
