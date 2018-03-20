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

/** UpdateDialogNode. */
public struct UpdateDialogNode {

    /// How the dialog node is processed.
    public enum NodeType: String {
        case standard = "standard"
        case eventHandler = "event_handler"
        case frame = "frame"
        case slot = "slot"
        case responseCondition = "response_condition"
        case folder = "folder"
    }

    /// How an `event_handler` node is processed.
    public enum EventName: String {
        case focus = "focus"
        case input = "input"
        case filled = "filled"
        case validate = "validate"
        case filledMultiple = "filled_multiple"
        case generic = "generic"
        case nomatch = "nomatch"
        case nomatchResponsesDepleted = "nomatch_responses_depleted"
    }

    /// Whether this top-level dialog node can be digressed into.
    public enum DigressIn: String {
        case notAvailable = "not_available"
        case returns = "returns"
        case doesNotReturn = "does_not_return"
    }

    /// Whether this dialog node can be returned to after a digression.
    public enum DigressOut: String {
        case returning = "allow_returning"
        case all = "allow_all"
        case allNeverReturn = "allow_all_never_return"
    }

    /// Whether the user can digress to top-level nodes while filling out slots.
    public enum DigressOutSlots: String {
        case notAllowed = "not_allowed"
        case allowReturning = "allow_returning"
        case allowAll = "allow_all"
    }

    /// The dialog node ID. This string must conform to the following restrictions:  - It can contain only Unicode alphanumeric, space, underscore, hyphen, and dot characters.  - It must be no longer than 1024 characters.
    public var dialogNode: String?

    /// The description of the dialog node. This string cannot contain carriage return, newline, or tab characters, and it must be no longer than 128 characters.
    public var description: String?

    /// The condition that will trigger the dialog node. This string cannot contain carriage return, newline, or tab characters, and it must be no longer than 2048 characters.
    public var conditions: String?

    /// The ID of the parent dialog node.
    public var parent: String?

    /// The ID of the previous sibling dialog node.
    public var previousSibling: String?

    /// The output of the dialog node. For more information about how to specify dialog node output, see the [documentation](https://console.bluemix.net/docs/services/conversation/dialog-overview.html#complex).
    public var output: [String: JSON]?

    /// The context for the dialog node.
    public var context: [String: JSON]?

    /// The metadata for the dialog node.
    public var metadata: [String: JSON]?

    /// The next step to be executed in dialog processing.
    public var nextStep: DialogNodeNextStep?

    /// The alias used to identify the dialog node. This string must conform to the following restrictions:  - It can contain only Unicode alphanumeric, space, underscore, hyphen, and dot characters.  - It must be no longer than 64 characters.
    public var title: String?

    /// How the dialog node is processed.
    public var nodeType: String?

    /// How an `event_handler` node is processed.
    public var eventName: String?

    /// The location in the dialog context where output is stored.
    public var variable: String?

    /// An array of objects describing any actions to be invoked by the dialog node.
    public var actions: [DialogNodeAction]?

    /// Whether this top-level dialog node can be digressed into.
    public var digressIn: String?

    /// Whether this dialog node can be returned to after a digression.
    public var digressOut: String?

    /// Whether the user can digress to top-level nodes while filling out slots.
    public var digressOutSlots: String?

    /**
     Initialize a `UpdateDialogNode` with member variables.

     - parameter dialogNode: The dialog node ID. This string must conform to the following restrictions:  - It can contain only Unicode alphanumeric, space, underscore, hyphen, and dot characters.  - It must be no longer than 1024 characters.
     - parameter description: The description of the dialog node. This string cannot contain carriage return, newline, or tab characters, and it must be no longer than 128 characters.
     - parameter conditions: The condition that will trigger the dialog node. This string cannot contain carriage return, newline, or tab characters, and it must be no longer than 2048 characters.
     - parameter parent: The ID of the parent dialog node.
     - parameter previousSibling: The ID of the previous sibling dialog node.
     - parameter output: The output of the dialog node. For more information about how to specify dialog node output, see the [documentation](https://console.bluemix.net/docs/services/conversation/dialog-overview.html#complex).
     - parameter context: The context for the dialog node.
     - parameter metadata: The metadata for the dialog node.
     - parameter nextStep: The next step to be executed in dialog processing.
     - parameter title: The alias used to identify the dialog node. This string must conform to the following restrictions:  - It can contain only Unicode alphanumeric, space, underscore, hyphen, and dot characters.  - It must be no longer than 64 characters.
     - parameter nodeType: How the dialog node is processed.
     - parameter eventName: How an `event_handler` node is processed.
     - parameter variable: The location in the dialog context where output is stored.
     - parameter actions: An array of objects describing any actions to be invoked by the dialog node.
     - parameter digressIn: Whether this top-level dialog node can be digressed into.
     - parameter digressOut: Whether this dialog node can be returned to after a digression.
     - parameter digressOutSlots: Whether the user can digress to top-level nodes while filling out slots.

     - returns: An initialized `UpdateDialogNode`.
    */
    public init(dialogNode: String? = nil, description: String? = nil, conditions: String? = nil, parent: String? = nil, previousSibling: String? = nil, output: [String: JSON]? = nil, context: [String: JSON]? = nil, metadata: [String: JSON]? = nil, nextStep: DialogNodeNextStep? = nil, title: String? = nil, nodeType: String? = nil, eventName: String? = nil, variable: String? = nil, actions: [DialogNodeAction]? = nil, digressIn: String? = nil, digressOut: String? = nil, digressOutSlots: String? = nil) {
        self.dialogNode = dialogNode
        self.description = description
        self.conditions = conditions
        self.parent = parent
        self.previousSibling = previousSibling
        self.output = output
        self.context = context
        self.metadata = metadata
        self.nextStep = nextStep
        self.title = title
        self.nodeType = nodeType
        self.eventName = eventName
        self.variable = variable
        self.actions = actions
        self.digressIn = digressIn
        self.digressOut = digressOut
        self.digressOutSlots = digressOutSlots
    }
}

extension UpdateDialogNode: Codable {

    private enum CodingKeys: String, CodingKey {
        case dialogNode = "dialog_node"
        case description = "description"
        case conditions = "conditions"
        case parent = "parent"
        case previousSibling = "previous_sibling"
        case output = "output"
        case context = "context"
        case metadata = "metadata"
        case nextStep = "next_step"
        case title = "title"
        case nodeType = "type"
        case eventName = "event_name"
        case variable = "variable"
        case actions = "actions"
        case digressIn = "digress_in"
        case digressOut = "digress_out"
        case digressOutSlots = "digress_out_slots"
        static let allValues = [dialogNode, description, conditions, parent, previousSibling, output, context, metadata, nextStep, title, nodeType, eventName, variable, actions, digressIn, digressOut, digressOutSlots]
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        dialogNode = try container.decodeIfPresent(String.self, forKey: .dialogNode)
        description = try container.decodeIfPresent(String.self, forKey: .description)
        conditions = try container.decodeIfPresent(String.self, forKey: .conditions)
        parent = try container.decodeIfPresent(String.self, forKey: .parent)
        previousSibling = try container.decodeIfPresent(String.self, forKey: .previousSibling)
        output = try container.decodeIfPresent([String: JSON].self, forKey: .output)
        context = try container.decodeIfPresent([String: JSON].self, forKey: .context)
        metadata = try container.decodeIfPresent([String: JSON].self, forKey: .metadata)
        nextStep = try container.decodeIfPresent(DialogNodeNextStep.self, forKey: .nextStep)
        title = try container.decodeIfPresent(String.self, forKey: .title)
        nodeType = try container.decodeIfPresent(String.self, forKey: .nodeType)
        eventName = try container.decodeIfPresent(String.self, forKey: .eventName)
        variable = try container.decodeIfPresent(String.self, forKey: .variable)
        actions = try container.decodeIfPresent([DialogNodeAction].self, forKey: .actions)
        digressIn = try container.decodeIfPresent(String.self, forKey: .digressIn)
        digressOut = try container.decodeIfPresent(String.self, forKey: .digressOut)
        digressOutSlots = try container.decodeIfPresent(String.self, forKey: .digressOutSlots)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(dialogNode, forKey: .dialogNode)
        try container.encodeIfPresent(description, forKey: .description)
        try container.encodeIfPresent(conditions, forKey: .conditions)
        try container.encodeIfPresent(parent, forKey: .parent)
        try container.encodeIfPresent(previousSibling, forKey: .previousSibling)
        try container.encodeIfPresent(output, forKey: .output)
        try container.encodeIfPresent(context, forKey: .context)
        try container.encodeIfPresent(metadata, forKey: .metadata)
        try container.encodeIfPresent(nextStep, forKey: .nextStep)
        try container.encodeIfPresent(title, forKey: .title)
        try container.encodeIfPresent(nodeType, forKey: .nodeType)
        try container.encodeIfPresent(eventName, forKey: .eventName)
        try container.encodeIfPresent(variable, forKey: .variable)
        try container.encodeIfPresent(actions, forKey: .actions)
        try container.encodeIfPresent(digressIn, forKey: .digressIn)
        try container.encodeIfPresent(digressOut, forKey: .digressOut)
        try container.encodeIfPresent(digressOutSlots, forKey: .digressOutSlots)
    }

}
