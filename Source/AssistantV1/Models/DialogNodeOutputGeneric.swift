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

/** DialogNodeOutputGeneric. */
public struct DialogNodeOutputGeneric: Codable, Equatable {

    /**
     The type of response returned by the dialog node. The specified response type must be supported by the client
     application or channel.
     */
    public enum ResponseType: String {
        case text = "text"
        case pause = "pause"
        case image = "image"
        case option = "option"
        case connectToAgent = "connect_to_agent"
    }

    /**
     How a response is selected from the list, if more than one response is specified. Valid only when
     **response_type**=`text`.
     */
    public enum SelectionPolicy: String {
        case sequential = "sequential"
        case random = "random"
        case multiline = "multiline"
    }

    /**
     The preferred type of control to display, if supported by the channel. Valid only when **response_type**=`option`.
     */
    public enum Preference: String {
        case dropdown = "dropdown"
        case button = "button"
    }

    /**
     The type of response returned by the dialog node. The specified response type must be supported by the client
     application or channel.
     */
    public var responseType: String

    /**
     A list of one or more objects defining text responses. Required when **response_type**=`text`.
     */
    public var values: [DialogNodeOutputTextValuesElement]?

    /**
     How a response is selected from the list, if more than one response is specified. Valid only when
     **response_type**=`text`.
     */
    public var selectionPolicy: String?

    /**
     The delimiter to use as a separator between responses when `selection_policy`=`multiline`.
     */
    public var delimiter: String?

    /**
     How long to pause, in milliseconds. The valid values are from 0 to 10000. Valid only when
     **response_type**=`pause`.
     */
    public var time: Int?

    /**
     Whether to send a "user is typing" event during the pause. Ignored if the channel does not support this event.
     Valid only when **response_type**=`pause`.
     */
    public var typing: Bool?

    /**
     The URL of the image. Required when **response_type**=`image`.
     */
    public var source: String?

    /**
     An optional title to show before the response. Valid only when **response_type**=`image` or `option`. This string
     must be no longer than 512 characters.
     */
    public var title: String?

    /**
     An optional description to show with the response. Valid only when **response_type**=`image` or `option`. This
     string must be no longer than 256 characters.
     */
    public var description: String?

    /**
     The preferred type of control to display, if supported by the channel. Valid only when **response_type**=`option`.
     */
    public var preference: String?

    /**
     An array of objects describing the options from which the user can choose. You can include up to 20 options.
     Required when **response_type**=`option`.
     */
    public var options: [DialogNodeOutputOptionsElement]?

    /**
     An optional message to be sent to the human agent who will be taking over the conversation. Valid only when
     **reponse_type**=`connect_to_agent`. This string must be no longer than 256 characters.
     */
    public var messageToHumanAgent: String?

    // Map each property name to the key that shall be used for encoding/decoding.
    private enum CodingKeys: String, CodingKey {
        case responseType = "response_type"
        case values = "values"
        case selectionPolicy = "selection_policy"
        case delimiter = "delimiter"
        case time = "time"
        case typing = "typing"
        case source = "source"
        case title = "title"
        case description = "description"
        case preference = "preference"
        case options = "options"
        case messageToHumanAgent = "message_to_human_agent"
    }

    /**
     Initialize a `DialogNodeOutputGeneric` with member variables.

     - parameter responseType: The type of response returned by the dialog node. The specified response type must be
       supported by the client application or channel.
     - parameter values: A list of one or more objects defining text responses. Required when
       **response_type**=`text`.
     - parameter selectionPolicy: How a response is selected from the list, if more than one response is specified.
       Valid only when **response_type**=`text`.
     - parameter delimiter: The delimiter to use as a separator between responses when
       `selection_policy`=`multiline`.
     - parameter time: How long to pause, in milliseconds. The valid values are from 0 to 10000. Valid only when
       **response_type**=`pause`.
     - parameter typing: Whether to send a "user is typing" event during the pause. Ignored if the channel does not
       support this event. Valid only when **response_type**=`pause`.
     - parameter source: The URL of the image. Required when **response_type**=`image`.
     - parameter title: An optional title to show before the response. Valid only when **response_type**=`image` or
       `option`. This string must be no longer than 512 characters.
     - parameter description: An optional description to show with the response. Valid only when
       **response_type**=`image` or `option`. This string must be no longer than 256 characters.
     - parameter preference: The preferred type of control to display, if supported by the channel. Valid only when
       **response_type**=`option`.
     - parameter options: An array of objects describing the options from which the user can choose. You can include
       up to 20 options. Required when **response_type**=`option`.
     - parameter messageToHumanAgent: An optional message to be sent to the human agent who will be taking over the
       conversation. Valid only when **reponse_type**=`connect_to_agent`. This string must be no longer than 256
       characters.

     - returns: An initialized `DialogNodeOutputGeneric`.
    */
    public init(
        responseType: String,
        values: [DialogNodeOutputTextValuesElement]? = nil,
        selectionPolicy: String? = nil,
        delimiter: String? = nil,
        time: Int? = nil,
        typing: Bool? = nil,
        source: String? = nil,
        title: String? = nil,
        description: String? = nil,
        preference: String? = nil,
        options: [DialogNodeOutputOptionsElement]? = nil,
        messageToHumanAgent: String? = nil
    )
    {
        self.responseType = responseType
        self.values = values
        self.selectionPolicy = selectionPolicy
        self.delimiter = delimiter
        self.time = time
        self.typing = typing
        self.source = source
        self.title = title
        self.description = description
        self.preference = preference
        self.options = options
        self.messageToHumanAgent = messageToHumanAgent
    }

}
