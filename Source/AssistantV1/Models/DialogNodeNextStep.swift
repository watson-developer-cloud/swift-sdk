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
 The next step to execute following this dialog node.
 */
public struct DialogNodeNextStep: Codable, Equatable {

    /**
     What happens after the dialog node completes. The valid values depend on the node type:
     - The following values are valid for any node:
       - `get_user_input`
       - `skip_user_input`
       - `jump_to`
     - If the node is of type `event_handler` and its parent node is of type `slot` or `frame`, additional values are
     also valid:
       - if **event_name**=`filled` and the type of the parent node is `slot`:
         - `reprompt`
         - `skip_all_slots`
     - if **event_name**=`nomatch` and the type of the parent node is `slot`:
         - `reprompt`
         - `skip_slot`
         - `skip_all_slots`
     - if **event_name**=`generic` and the type of the parent node is `frame`:
         - `reprompt`
         - `skip_slot`
         - `skip_all_slots`
     If you specify `jump_to`, then you must also specify a value for the `dialog_node` property.
     */
    public enum Behavior: String {
        case getUserInput = "get_user_input"
        case skipUserInput = "skip_user_input"
        case jumpTo = "jump_to"
        case reprompt = "reprompt"
        case skipSlot = "skip_slot"
        case skipAllSlots = "skip_all_slots"
    }

    /**
     Which part of the dialog node to process next.
     */
    public enum Selector: String {
        case condition = "condition"
        case client = "client"
        case userInput = "user_input"
        case body = "body"
    }

    /**
     What happens after the dialog node completes. The valid values depend on the node type:
     - The following values are valid for any node:
       - `get_user_input`
       - `skip_user_input`
       - `jump_to`
     - If the node is of type `event_handler` and its parent node is of type `slot` or `frame`, additional values are
     also valid:
       - if **event_name**=`filled` and the type of the parent node is `slot`:
         - `reprompt`
         - `skip_all_slots`
     - if **event_name**=`nomatch` and the type of the parent node is `slot`:
         - `reprompt`
         - `skip_slot`
         - `skip_all_slots`
     - if **event_name**=`generic` and the type of the parent node is `frame`:
         - `reprompt`
         - `skip_slot`
         - `skip_all_slots`
     If you specify `jump_to`, then you must also specify a value for the `dialog_node` property.
     */
    public var behavior: String

    /**
     The ID of the dialog node to process next. This parameter is required if **behavior**=`jump_to`.
     */
    public var dialogNode: String?

    /**
     Which part of the dialog node to process next.
     */
    public var selector: String?

    // Map each property name to the key that shall be used for encoding/decoding.
    private enum CodingKeys: String, CodingKey {
        case behavior = "behavior"
        case dialogNode = "dialog_node"
        case selector = "selector"
    }

    /**
     Initialize a `DialogNodeNextStep` with member variables.

     - parameter behavior: What happens after the dialog node completes. The valid values depend on the node type:
       - The following values are valid for any node:
         - `get_user_input`
         - `skip_user_input`
         - `jump_to`
       - If the node is of type `event_handler` and its parent node is of type `slot` or `frame`, additional values are
       also valid:
         - if **event_name**=`filled` and the type of the parent node is `slot`:
           - `reprompt`
           - `skip_all_slots`
       - if **event_name**=`nomatch` and the type of the parent node is `slot`:
           - `reprompt`
           - `skip_slot`
           - `skip_all_slots`
       - if **event_name**=`generic` and the type of the parent node is `frame`:
           - `reprompt`
           - `skip_slot`
           - `skip_all_slots`
       If you specify `jump_to`, then you must also specify a value for the `dialog_node` property.
     - parameter dialogNode: The ID of the dialog node to process next. This parameter is required if
       **behavior**=`jump_to`.
     - parameter selector: Which part of the dialog node to process next.

     - returns: An initialized `DialogNodeNextStep`.
    */
    public init(
        behavior: String,
        dialogNode: String? = nil,
        selector: String? = nil
    )
    {
        self.behavior = behavior
        self.dialogNode = dialogNode
        self.selector = selector
    }

}
