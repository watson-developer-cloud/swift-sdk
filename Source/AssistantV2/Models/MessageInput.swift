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
 The user input.
 */
public struct MessageInput: Codable {

    /**
     The type of user input. Currently, only text input is supported.
     */
    public enum MessageType: String {
        case text = "text"
    }

    /**
     The type of user input. Currently, only text input is supported.
     */
    public var messageType: String?

    /**
     The text of the user input. This string cannot contain carriage return, newline, or tab characters, and it must be
     no longer than 2048 characters.
     */
    public var text: String?

    /**
     Properties that control how the assistant responds.
     */
    public var options: MessageInputOptions?

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
     For internal use only.
     */
    public var suggestionID: String?

    // Map each property name to the key that shall be used for encoding/decoding.
    private enum CodingKeys: String, CodingKey {
        case messageType = "message_type"
        case text = "text"
        case options = "options"
        case intents = "intents"
        case entities = "entities"
        case suggestionID = "suggestion_id"
    }

    /**
     Initialize a `MessageInput` with member variables.

     - parameter messageType: The type of user input. Currently, only text input is supported.
     - parameter text: The text of the user input. This string cannot contain carriage return, newline, or tab
       characters, and it must be no longer than 2048 characters.
     - parameter options: Properties that control how the assistant responds.
     - parameter intents: Intents to use when evaluating the user input. Include intents from the previous response
       to continue using those intents rather than trying to recognize intents in the new input.
     - parameter entities: Entities to use when evaluating the message. Include entities from the previous response
       to continue using those entities rather than detecting entities in the new input.
     - parameter suggestionID: For internal use only.

     - returns: An initialized `MessageInput`.
    */
    public init(
        messageType: String? = nil,
        text: String? = nil,
        options: MessageInputOptions? = nil,
        intents: [RuntimeIntent]? = nil,
        entities: [RuntimeEntity]? = nil,
        suggestionID: String? = nil
    )
    {
        self.messageType = messageType
        self.text = text
        self.options = options
        self.intents = intents
        self.entities = entities
        self.suggestionID = suggestionID
    }

}
