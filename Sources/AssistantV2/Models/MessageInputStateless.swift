/**
 * (C) Copyright IBM Corp. 2020, 2022.
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
 An input object that includes the input text.
 */
public struct MessageInputStateless: Codable, Equatable {

    /**
     The type of the message:
     - `text`: The user input is processed normally by the assistant.
     - `search`: Only search results are returned. (Any dialog or actions skill is bypassed.)
     **Note:** A `search` message results in an error if no search skill is configured for the assistant.
     */
    public enum MessageType: String {
        case text = "text"
        case search = "search"
    }

    /**
     The type of the message:
     - `text`: The user input is processed normally by the assistant.
     - `search`: Only search results are returned. (Any dialog or actions skill is bypassed.)
     **Note:** A `search` message results in an error if no search skill is configured for the assistant.
     */
    public var messageType: String?

    /**
     The text of the user input. This string cannot contain carriage return, newline, or tab characters.
     */
    public var text: String?

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

    /**
     An array of multimedia attachments to be sent with the message.
     **Note:** Attachments are not processed by the assistant itself, but can be sent to external services by webhooks.
     */
    public var attachments: [MessageInputAttachment]?

    /**
     Optional properties that control how the assistant responds.
     */
    public var options: MessageInputOptionsStateless?

    // Map each property name to the key that shall be used for encoding/decoding.
    private enum CodingKeys: String, CodingKey {
        case messageType = "message_type"
        case text = "text"
        case intents = "intents"
        case entities = "entities"
        case suggestionID = "suggestion_id"
        case attachments = "attachments"
        case options = "options"
    }

    /**
      Initialize a `MessageInputStateless` with member variables.

      - parameter messageType: The type of the message:
        - `text`: The user input is processed normally by the assistant.
        - `search`: Only search results are returned. (Any dialog or actions skill is bypassed.)
        **Note:** A `search` message results in an error if no search skill is configured for the assistant.
      - parameter text: The text of the user input. This string cannot contain carriage return, newline, or tab
        characters.
      - parameter intents: Intents to use when evaluating the user input. Include intents from the previous response
        to continue using those intents rather than trying to recognize intents in the new input.
      - parameter entities: Entities to use when evaluating the message. Include entities from the previous response
        to continue using those entities rather than detecting entities in the new input.
      - parameter suggestionID: For internal use only.
      - parameter attachments: An array of multimedia attachments to be sent with the message.
        **Note:** Attachments are not processed by the assistant itself, but can be sent to external services by
        webhooks.
      - parameter options: Optional properties that control how the assistant responds.

      - returns: An initialized `MessageInputStateless`.
     */
    public init(
        messageType: String? = nil,
        text: String? = nil,
        intents: [RuntimeIntent]? = nil,
        entities: [RuntimeEntity]? = nil,
        suggestionID: String? = nil,
        attachments: [MessageInputAttachment]? = nil,
        options: MessageInputOptionsStateless? = nil
    )
    {
        self.messageType = messageType
        self.text = text
        self.intents = intents
        self.entities = entities
        self.suggestionID = suggestionID
        self.attachments = attachments
        self.options = options
    }

}
