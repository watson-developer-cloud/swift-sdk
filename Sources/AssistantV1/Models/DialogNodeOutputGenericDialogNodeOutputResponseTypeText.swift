/**
 * (C) Copyright IBM Corp. 2020.
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
 An object that describes a response with response type `text`.

 Enums with an associated value of DialogNodeOutputGenericDialogNodeOutputResponseTypeText:
    DialogNodeOutputGeneric
 */
public struct DialogNodeOutputGenericDialogNodeOutputResponseTypeText: Codable, Equatable {

    /**
     The type of response returned by the dialog node. The specified response type must be supported by the client
     application or channel.
     */
    public enum ResponseType: String {
        case text = "text"
    }

    /**
     How a response is selected from the list, if more than one response is specified.
     */
    public enum SelectionPolicy: String {
        case sequential = "sequential"
        case random = "random"
        case multiline = "multiline"
    }

    /**
     The type of response returned by the dialog node. The specified response type must be supported by the client
     application or channel.
     */
    public var responseType: String

    /**
     A list of one or more objects defining text responses.
     */
    public var values: [DialogNodeOutputTextValuesElement]

    /**
     How a response is selected from the list, if more than one response is specified.
     */
    public var selectionPolicy: String?

    /**
     The delimiter to use as a separator between responses when `selection_policy`=`multiline`.
     */
    public var delimiter: String?

    // Map each property name to the key that shall be used for encoding/decoding.
    private enum CodingKeys: String, CodingKey {
        case responseType = "response_type"
        case values = "values"
        case selectionPolicy = "selection_policy"
        case delimiter = "delimiter"
    }

    /**
      Initialize a `DialogNodeOutputGenericDialogNodeOutputResponseTypeText` with member variables.

      - parameter responseType: The type of response returned by the dialog node. The specified response type must be
        supported by the client application or channel.
      - parameter values: A list of one or more objects defining text responses.
      - parameter selectionPolicy: How a response is selected from the list, if more than one response is specified.
      - parameter delimiter: The delimiter to use as a separator between responses when
        `selection_policy`=`multiline`.

      - returns: An initialized `DialogNodeOutputGenericDialogNodeOutputResponseTypeText`.
     */
    public init(
        responseType: String,
        values: [DialogNodeOutputTextValuesElement],
        selectionPolicy: String? = nil,
        delimiter: String? = nil
    )
    {
        self.responseType = responseType
        self.values = values
        self.selectionPolicy = selectionPolicy
        self.delimiter = delimiter
    }

}
