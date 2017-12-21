/**
 * Copyright IBM Corporation 2017
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

/** The next step to execute following this dialog node. */
public struct DialogNodeNextStep {

    /// How the `next_step` reference is processed.
    public enum Behavior: String {
        // swiftlint:disable:next identifier_name
        case to = "jump_to"
    }

    /// Which part of the dialog node to process next.
    public enum Selector: String {
        case condition = "condition"
        case client = "client"
        case userInput = "user_input"
        case body = "body"
    }

    /// How the `next_step` reference is processed.
    public var behavior: String

    /// The ID of the dialog node to process next.
    public var dialogNode: String?

    /// Which part of the dialog node to process next.
    public var selector: String?

    /**
     Initialize a `DialogNodeNextStep` with member variables.

     - parameter behavior: How the `next_step` reference is processed.
     - parameter dialogNode: The ID of the dialog node to process next.
     - parameter selector: Which part of the dialog node to process next.

     - returns: An initialized `DialogNodeNextStep`.
    */
    public init(behavior: String, dialogNode: String? = nil, selector: String? = nil) {
        self.behavior = behavior
        self.dialogNode = dialogNode
        self.selector = selector
    }
}

extension DialogNodeNextStep: Codable {

    private enum CodingKeys: String, CodingKey {
        case behavior = "behavior"
        case dialogNode = "dialog_node"
        case selector = "selector"
        static let allValues = [behavior, dialogNode, selector]
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        behavior = try container.decode(String.self, forKey: .behavior)
        dialogNode = try container.decodeIfPresent(String.self, forKey: .dialogNode)
        selector = try container.decodeIfPresent(String.self, forKey: .selector)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(behavior, forKey: .behavior)
        try container.encodeIfPresent(dialogNode, forKey: .dialogNode)
        try container.encodeIfPresent(selector, forKey: .selector)
    }

}
