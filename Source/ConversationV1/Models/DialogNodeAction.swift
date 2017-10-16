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
    public var name: String

    /// The type of action to invoke.
    public var actionType: String?

    /// A map of key/value pairs to be provided to the action.
    public var parameters: [String: JSON]?

    /// The location in the dialog context where the result of the action is stored.
    public var resultVariable: String

    /// The name of the context variable that the client application will use to pass in credentials for the action.
    public var credentials: String?

    /**
     Initialize a `DialogNodeAction` with member variables.

     - parameter name: The name of the action.
     - parameter resultVariable: The location in the dialog context where the result of the action is stored.
     - parameter actionType: The type of action to invoke.
     - parameter parameters: A map of key/value pairs to be provided to the action.
     - parameter credentials: The name of the context variable that the client application will use to pass in credentials for the action.

     - returns: An initialized `DialogNodeAction`.
    */
    public init(name: String, resultVariable: String, actionType: String? = nil, parameters: [String: JSON]? = nil, credentials: String? = nil) {
        self.name = name
        self.resultVariable = resultVariable
        self.actionType = actionType
        self.parameters = parameters
        self.credentials = credentials
    }
}

extension DialogNodeAction: Codable {

    private enum CodingKeys: String, CodingKey {
        case name = "name"
        case actionType = "type"
        case parameters = "parameters"
        case resultVariable = "result_variable"
        case credentials = "credentials"
        static let allValues = [name, actionType, parameters, resultVariable, credentials]
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decode(String.self, forKey: .name)
        actionType = try container.decodeIfPresent(String.self, forKey: .actionType)
        parameters = try container.decodeIfPresent([String: JSON].self, forKey: .parameters)
        resultVariable = try container.decode(String.self, forKey: .resultVariable)
        credentials = try container.decodeIfPresent(String.self, forKey: .credentials)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encodeIfPresent(actionType, forKey: .actionType)
        try container.encodeIfPresent(parameters, forKey: .parameters)
        try container.encode(resultVariable, forKey: .resultVariable)
        try container.encodeIfPresent(credentials, forKey: .credentials)
    }

}
