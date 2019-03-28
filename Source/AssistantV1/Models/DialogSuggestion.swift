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
import RestKit

/** DialogSuggestion. */
public struct DialogSuggestion: Codable, Equatable {

    /**
     The user-facing label for the disambiguation option. This label is taken from the **user_label** property of the
     corresponding dialog node.
     */
    public var label: String

    /**
     An object defining the message input, intents, and entities to be sent to the Watson Assistant service if the user
     selects the corresponding disambiguation option.
     */
    public var value: DialogSuggestionValue

    /**
     The dialog output that will be returned from the Watson Assistant service if the user selects the corresponding
     option.
     */
    public var output: [String: JSON]?

    /**
     The ID of the dialog node that the **label** property is taken from. The **label** property is populated using the
     value of the dialog node's **user_label** property.
     */
    public var dialogNode: String?

    // Map each property name to the key that shall be used for encoding/decoding.
    private enum CodingKeys: String, CodingKey {
        case label = "label"
        case value = "value"
        case output = "output"
        case dialogNode = "dialog_node"
    }

    /**
     Initialize a `DialogSuggestion` with member variables.

     - parameter label: The user-facing label for the disambiguation option. This label is taken from the
       **user_label** property of the corresponding dialog node.
     - parameter value: An object defining the message input, intents, and entities to be sent to the Watson
       Assistant service if the user selects the corresponding disambiguation option.
     - parameter output: The dialog output that will be returned from the Watson Assistant service if the user
       selects the corresponding option.
     - parameter dialogNode: The ID of the dialog node that the **label** property is taken from. The **label**
       property is populated using the value of the dialog node's **user_label** property.

     - returns: An initialized `DialogSuggestion`.
    */
    public init(
        label: String,
        value: DialogSuggestionValue,
        output: [String: JSON]? = nil,
        dialogNode: String? = nil
    )
    {
        self.label = label
        self.value = value
        self.output = output
        self.dialogNode = dialogNode
    }

}
