/**
 * (C) Copyright IBM Corp. 2018, 2021.
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
 The response sent by the workspace, including the output text, detected intents and entities, and context.
 */
public struct MessageResponse: Codable, Equatable {

    /**
     An input object that includes the input text.
     */
    public var input: MessageInput

    /**
     An array of intents recognized in the user input, sorted in descending order of confidence.
     */
    public var intents: [RuntimeIntent]

    /**
     An array of entities identified in the user input.
     */
    public var entities: [RuntimeEntity]

    /**
     Whether to return more than one intent. A value of `true` indicates that all matching intents are returned.
     */
    public var alternateIntents: Bool?

    /**
     State information for the conversation. To maintain state, include the context from the previous response.
     */
    public var context: Context

    /**
     An output object that includes the response to the user, the dialog nodes that were triggered, and messages from
     the log.
     */
    public var output: OutputData

    /**
     An array of objects describing any actions requested by the dialog node.
     */
    public var actions: [DialogNodeAction]?

    /**
     A string value that identifies the user who is interacting with the workspace. The client must provide a unique
     identifier for each individual end user who accesses the application. For user-based plans, this user ID is used to
     identify unique users for billing purposes. This string cannot contain carriage return, newline, or tab characters.
     If no value is specified in the input, **user_id** is automatically set to the value of
     **context.conversation_id**.
     **Note:** This property is the same as the **user_id** property in the context metadata. If **user_id** is
     specified in both locations in a message request, the value specified at the root is used.
     */
    public var userID: String

    // Map each property name to the key that shall be used for encoding/decoding.
    private enum CodingKeys: String, CodingKey {
        case input = "input"
        case intents = "intents"
        case entities = "entities"
        case alternateIntents = "alternate_intents"
        case context = "context"
        case output = "output"
        case actions = "actions"
        case userID = "user_id"
    }

}
