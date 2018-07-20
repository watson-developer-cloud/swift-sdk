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
 The output of the dialog node. For more information about how to specify dialog node output, see the
 [documentation](https://console.bluemix.net/docs/services/conversation/dialog-overview.html#complex).
 */
public struct DialogNodeOutput: Codable {

    /**
     An array of objects describing the output defined for the dialog node.
     */
    public var generic: [DialogNodeOutputGeneric]?

    /**
     Options that modify how specified output is handled.
     */
    public var modifiers: DialogNodeOutputModifiers?

    /**
     An object defining text responses in dialog nodes that do not use the `output.generic` object to define responses.
     New dialog nodes should use `output.generic`. For more information about how to specify dialog node output, see the
     [documentation](https://console.bluemix.net/docs/services/conversation/dialog-overview.html#complex).
     */
    public var text: [String: JSON]?

    /// Additional properties associated with this model.
    public var additionalProperties: [String: JSON]

    // Map each property name to the key that shall be used for encoding/decoding.
    private enum CodingKeys: String, CodingKey {
        case generic = "generic"
        case modifiers = "modifiers"
        case text = "text"
        static let allValues = [generic, modifiers, text]
    }

    /**
     Initialize a `DialogNodeOutput` with member variables.

     - parameter generic: An array of objects describing the output defined for the dialog node.
     - parameter modifiers: Options that modify how specified output is handled.
     - parameter text: An object defining text responses in dialog nodes that do not use the `output.generic` object
       to define responses. New dialog nodes should use `output.generic`. For more information about how to specify
       dialog node output, see the
       [documentation](https://console.bluemix.net/docs/services/conversation/dialog-overview.html#complex).

     - returns: An initialized `DialogNodeOutput`.
    */
    public init(
        generic: [DialogNodeOutputGeneric]? = nil,
        modifiers: DialogNodeOutputModifiers? = nil,
        text: [String: JSON]? = nil,
        additionalProperties: [String: JSON] = [:]
    )
    {
        self.generic = generic
        self.modifiers = modifiers
        self.text = text
        self.additionalProperties = additionalProperties
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        generic = try container.decodeIfPresent([DialogNodeOutputGeneric].self, forKey: .generic)
        modifiers = try container.decodeIfPresent(DialogNodeOutputModifiers.self, forKey: .modifiers)
        text = try container.decodeIfPresent([String: JSON].self, forKey: .text)
        let dynamicContainer = try decoder.container(keyedBy: DynamicKeys.self)
        additionalProperties = try dynamicContainer.decode([String: JSON].self, excluding: CodingKeys.allValues)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(generic, forKey: .generic)
        try container.encodeIfPresent(modifiers, forKey: .modifiers)
        try container.encodeIfPresent(text, forKey: .text)
        var dynamicContainer = encoder.container(keyedBy: DynamicKeys.self)
        try dynamicContainer.encodeIfPresent(additionalProperties)
    }

}
