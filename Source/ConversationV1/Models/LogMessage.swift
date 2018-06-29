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
 Log message details.
 */
public struct LogMessage: Codable {

    /**
     The severity of the log message.
     */
    public enum Level: String {
        case info = "info"
        case error = "error"
        case warn = "warn"
    }

    /**
     The severity of the log message.
     */
    public var level: String

    /**
     The text of the log message.
     */
    public var msg: String

    /// Additional properties associated with this model.
    public var additionalProperties: [String: JSON]

    // Map each property name to the key that shall be used for encoding/decoding.
    private enum CodingKeys: String, CodingKey {
        case level = "level"
        case msg = "msg"
        static let allValues = [level, msg]
    }

    /**
     Initialize a `LogMessage` with member variables.

     - parameter level: The severity of the log message.
     - parameter msg: The text of the log message.

     - returns: An initialized `LogMessage`.
    */
    public init(
        level: String,
        msg: String,
        additionalProperties: [String: JSON] = [:]
    )
    {
        self.level = level
        self.msg = msg
        self.additionalProperties = additionalProperties
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        level = try container.decode(String.self, forKey: .level)
        msg = try container.decode(String.self, forKey: .msg)
        let dynamicContainer = try decoder.container(keyedBy: DynamicKeys.self)
        additionalProperties = try dynamicContainer.decode([String: JSON].self, excluding: CodingKeys.allValues)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(level, forKey: .level)
        try container.encode(msg, forKey: .msg)
        var dynamicContainer = encoder.container(keyedBy: DynamicKeys.self)
        try dynamicContainer.encodeIfPresent(additionalProperties)
    }

}
