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

/**
 A request sent to the workspace, including the user input and context.
 */
public struct MessageRequest: Codable, Equatable {

    /**
     An input object that includes the input text.
     */
    public var input: MessageInput?

    /**
     Intents to use when evaluating the user input. Include intents from the previous response to continue using those
     intents rather than trying to recognize intents in the new input.
     */
    public var intents: [RuntimeIntent]?

    /**
     Entities to use when evaluating the message. Include entities from the previous response to continue using those
     entities rather than detecting entities in the new input.
     */
    public var entities: [RuntimeEntity]?

    /**
     Whether to return more than one intent. A value of `true` indicates that all matching intents are returned.
     */
    public var alternateIntents: Bool?

    /**
     State information for the conversation. To maintain state, include the context from the previous response.
     */
    public var context: Context?

    /**
     An output object that includes the response to the user, the dialog nodes that were triggered, and messages from
     the log.
     */
    public var output: OutputData?

    /**
     An array of objects describing any actions requested by the dialog node.
     */
    public var actions: [DialogNodeAction]?

    // Map each property name to the key that shall be used for encoding/decoding.
    private enum CodingKeys: String, CodingKey {
        case input = "input"
        case intents = "intents"
        case entities = "entities"
        case alternateIntents = "alternate_intents"
        case context = "context"
        case output = "output"
        case actions = "actions"
    }

    /**
     Initialize a `MessageRequest` with member variables.

     - parameter input: An input object that includes the input text.
     - parameter intents: Intents to use when evaluating the user input. Include intents from the previous response
       to continue using those intents rather than trying to recognize intents in the new input.
     - parameter entities: Entities to use when evaluating the message. Include entities from the previous response
       to continue using those entities rather than detecting entities in the new input.
     - parameter alternateIntents: Whether to return more than one intent. A value of `true` indicates that all
       matching intents are returned.
     - parameter context: State information for the conversation. To maintain state, include the context from the
       previous response.
     - parameter output: An output object that includes the response to the user, the dialog nodes that were
       triggered, and messages from the log.
     - parameter actions: An array of objects describing any actions requested by the dialog node.

     - returns: An initialized `MessageRequest`.
    */
    public init(
        input: MessageInput? = nil,
        intents: [RuntimeIntent]? = nil,
        entities: [RuntimeEntity]? = nil,
        alternateIntents: Bool? = nil,
        context: Context? = nil,
        output: OutputData? = nil,
        actions: [DialogNodeAction]? = nil
    )
    {
        self.input = input
        self.intents = intents
        self.entities = entities
        self.alternateIntents = alternateIntents
        self.context = context
        self.output = output
        self.actions = actions
    }

}
