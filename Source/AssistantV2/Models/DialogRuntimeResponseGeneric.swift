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

/** DialogRuntimeResponseGeneric. */
public struct DialogRuntimeResponseGeneric: Decodable {

    /**
     The type of response returned by the dialog node. The specified response type must be supported by the client
     application or channel.
     **Note:** The **suggestion** response type is part of the disambiguation feature, which is only available for
     Premium users.
     */
    public enum ResponseType: String {
        case text = "text"
        case pause = "pause"
        case image = "image"
        case option = "option"
        case connectToAgent = "connect_to_agent"
        case suggestion = "suggestion"
    }

    /**
     The preferred type of control to display.
     */
    public enum Preference: String {
        case dropdown = "dropdown"
        case button = "button"
    }

    /**
     The type of response returned by the dialog node. The specified response type must be supported by the client
     application or channel.
     **Note:** The **suggestion** response type is part of the disambiguation feature, which is only available for
     Premium users.
     */
    public var responseType: String

    /**
     The text of the response.
     */
    public var text: String?

    /**
     How long to pause, in milliseconds.
     */
    public var time: Int?

    /**
     Whether to send a "user is typing" event during the pause.
     */
    public var typing: Bool?

    /**
     The URL of the image.
     */
    public var source: String?

    /**
     The title to show before the response.
     */
    public var title: String?

    /**
     The description to show with the the response.
     */
    public var description: String?

    /**
     The preferred type of control to display.
     */
    public var preference: String?

    /**
     An array of objects describing the options from which the user can choose.
     */
    public var options: [DialogNodeOutputOptionsElement]?

    /**
     A message to be sent to the human agent who will be taking over the conversation.
     */
    public var messageToHumanAgent: String?

    /**
     A label identifying the topic of the conversation, derived from the **user_label** property of the relevant node.
     */
    public var topic: String?

    /**
     An array of objects describing the possible matching dialog nodes from which the user can choose.
     **Note:** The **suggestions** property is part of the disambiguation feature, which is only available for Premium
     users.
     */
    public var suggestions: [DialogSuggestion]?

    // Map each property name to the key that shall be used for encoding/decoding.
    private enum CodingKeys: String, CodingKey {
        case responseType = "response_type"
        case text = "text"
        case time = "time"
        case typing = "typing"
        case source = "source"
        case title = "title"
        case description = "description"
        case preference = "preference"
        case options = "options"
        case messageToHumanAgent = "message_to_human_agent"
        case topic = "topic"
        case suggestions = "suggestions"
    }

}
