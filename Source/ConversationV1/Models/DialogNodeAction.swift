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

/** DialogNodeAction. */
public struct DialogNodeAction {

    /// The type of action to invoke.
    public enum ActionType: String {
        case client = "client"
        case server = "server"
    }

    /// The name of the action.
    public let name: String

    /// The type of action to invoke.
    public let actionType: String?

    /// A map of key/value pairs to be provided to the action.
    public let parameters: [String: JSON]?

    /// The location in the dialog context where the result of the action is stored.
    public let resultVariable: String

    /**
     Initialize a `DialogNodeAction` with member variables.

     - parameter name: The name of the action.
     - parameter resultVariable: The location in the dialog context where the result of the action is stored.
     - parameter actionType: The type of action to invoke.
     - parameter parameters: A map of key/value pairs to be provided to the action.

     - returns: An initialized `DialogNodeAction`.
    */
    public init(name: String, resultVariable: String, actionType: String? = nil, parameters: [String: JSON]? = nil) {
        self.name = name
        self.resultVariable = resultVariable
        self.actionType = actionType
        self.parameters = parameters
    }
}

extension DialogNodeAction: Codable {

    private enum CodingKeys: String, CodingKey {
        case name = "name"
        case actionType = "type"
        case parameters = "parameters"
        case resultVariable = "result_variable"
        static let allValues = [name, actionType, parameters, resultVariable]
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decode(String.self, forKey: .name)
        actionType = try container.decodeIfPresent(String.self, forKey: .actionType)
        parameters = try container.decodeIfPresent([String: JSON].self, forKey: .parameters)
        resultVariable = try container.decode(String.self, forKey: .resultVariable)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encodeIfPresent(actionType, forKey: .actionType)
        try container.encodeIfPresent(parameters, forKey: .parameters)
        try container.encode(resultVariable, forKey: .resultVariable)
    }

}
