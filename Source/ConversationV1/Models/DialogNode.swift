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
import RestKit

/** DialogNode. */
public struct DialogNode: Decodable {

    /**
     How the dialog node is processed.
     */
    public enum NodeType: String {
        case standard = "standard"
        case eventHandler = "event_handler"
        case frame = "frame"
        case slot = "slot"
        case responseCondition = "response_condition"
        case folder = "folder"
    }

    /**
     How an `event_handler` node is processed.
     */
    public enum EventName: String {
        case focus = "focus"
        case input = "input"
        case filled = "filled"
        case validate = "validate"
        case filledMultiple = "filled_multiple"
        case generic = "generic"
        case nomatch = "nomatch"
        case nomatchResponsesDepleted = "nomatch_responses_depleted"
        case digressionReturnPrompt = "digression_return_prompt"
    }

    /**
     Whether this top-level dialog node can be digressed into.
     */
    public enum DigressIn: String {
        case notAvailable = "not_available"
        case returns = "returns"
        case doesNotReturn = "does_not_return"
    }

    /**
     Whether this dialog node can be returned to after a digression.
     */
    public enum DigressOut: String {
        case returning = "allow_returning"
        case all = "allow_all"
        case allNeverReturn = "allow_all_never_return"
    }

    /**
     Whether the user can digress to top-level nodes while filling out slots.
     */
    public enum DigressOutSlots: String {
        case notAllowed = "not_allowed"
        case allowReturning = "allow_returning"
        case allowAll = "allow_all"
    }

    /**
     The dialog node ID.
     */
    public var dialogNodeID: String

    /**
     The description of the dialog node.
     */
    public var description: String?

    /**
     The condition that triggers the dialog node.
     */
    public var conditions: String?

    /**
     The ID of the parent dialog node. This property is not returned if the dialog node has no parent.
     */
    public var parent: String?

    /**
     The ID of the previous sibling dialog node. This property is not returned if the dialog node has no previous
     sibling.
     */
    public var previousSibling: String?

    /**
     The output of the dialog node. For more information about how to specify dialog node output, see the
     [documentation](https://console.bluemix.net/docs/services/conversation/dialog-overview.html#complex).
     */
    public var output: DialogNodeOutput?

    /**
     The context (if defined) for the dialog node.
     */
    public var context: [String: JSON]?

    /**
     Any metadata for the dialog node.
     */
    public var metadata: [String: JSON]?

    /**
     The next step to execute following this dialog node.
     */
    public var nextStep: DialogNodeNextStep?

    /**
     The timestamp for creation of the dialog node.
     */
    public var created: String?

    /**
     The timestamp for the most recent update to the dialog node.
     */
    public var updated: String?

    /**
     The actions for the dialog node.
     */
    public var actions: [DialogNodeAction]?

    /**
     The alias used to identify the dialog node.
     */
    public var title: String?

    /**
     How the dialog node is processed.
     */
    public var nodeType: String?

    /**
     How an `event_handler` node is processed.
     */
    public var eventName: String?

    /**
     The location in the dialog context where output is stored.
     */
    public var variable: String?

    /**
     Whether this top-level dialog node can be digressed into.
     */
    public var digressIn: String?

    /**
     Whether this dialog node can be returned to after a digression.
     */
    public var digressOut: String?

    /**
     Whether the user can digress to top-level nodes while filling out slots.
     */
    public var digressOutSlots: String?

    /**
     A label that can be displayed externally to describe the purpose of the node to users. This string must be no
     longer than 512 characters.
     */
    public var userLabel: String?

    // Map each property name to the key that shall be used for encoding/decoding.
    private enum CodingKeys: String, CodingKey {
        case dialogNodeID = "dialog_node"
        case description = "description"
        case conditions = "conditions"
        case parent = "parent"
        case previousSibling = "previous_sibling"
        case output = "output"
        case context = "context"
        case metadata = "metadata"
        case nextStep = "next_step"
        case created = "created"
        case updated = "updated"
        case actions = "actions"
        case title = "title"
        case nodeType = "type"
        case eventName = "event_name"
        case variable = "variable"
        case digressIn = "digress_in"
        case digressOut = "digress_out"
        case digressOutSlots = "digress_out_slots"
        case userLabel = "user_label"
    }

}
