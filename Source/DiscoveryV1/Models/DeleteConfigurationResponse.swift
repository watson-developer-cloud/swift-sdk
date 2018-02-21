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

/** DeleteConfigurationResponse. */
public struct DeleteConfigurationResponse {

    /// Status of the configuration. A deleted configuration has the status deleted.
    public enum Status: String {
        case deleted = "deleted"
    }

    /// The unique identifier for the configuration.
    public var configurationID: String

    /// Status of the configuration. A deleted configuration has the status deleted.
    public var status: String

    /// An array of notice messages, if any.
    public var notices: [Notice]?

    /**
     Initialize a `DeleteConfigurationResponse` with member variables.

     - parameter configurationID: The unique identifier for the configuration.
     - parameter status: Status of the configuration. A deleted configuration has the status deleted.
     - parameter notices: An array of notice messages, if any.

     - returns: An initialized `DeleteConfigurationResponse`.
    */
    public init(configurationID: String, status: String, notices: [Notice]? = nil) {
        self.configurationID = configurationID
        self.status = status
        self.notices = notices
    }
}

extension DeleteConfigurationResponse: Codable {

    private enum CodingKeys: String, CodingKey {
        case configurationID = "configuration_id"
        case status = "status"
        case notices = "notices"
        static let allValues = [configurationID, status, notices]
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        configurationID = try container.decode(String.self, forKey: .configurationID)
        status = try container.decode(String.self, forKey: .status)
        notices = try container.decodeIfPresent([Notice].self, forKey: .notices)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(configurationID, forKey: .configurationID)
        try container.encode(status, forKey: .status)
        try container.encodeIfPresent(notices, forKey: .notices)
    }

}
