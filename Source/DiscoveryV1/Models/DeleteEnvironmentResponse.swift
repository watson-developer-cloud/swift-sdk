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

/** DeleteEnvironmentResponse. */
public struct DeleteEnvironmentResponse {

    /// Status of the environment.
    public enum Status: String {
        case deleted = "deleted"
    }

    /// The unique identifier for the environment.
    public var environmentID: String

    /// Status of the environment.
    public var status: String

    /**
     Initialize a `DeleteEnvironmentResponse` with member variables.

     - parameter environmentID: The unique identifier for the environment.
     - parameter status: Status of the environment.

     - returns: An initialized `DeleteEnvironmentResponse`.
    */
    public init(environmentID: String, status: String) {
        self.environmentID = environmentID
        self.status = status
    }
}

extension DeleteEnvironmentResponse: Codable {

    private enum CodingKeys: String, CodingKey {
        case environmentID = "environment_id"
        case status = "status"
        static let allValues = [environmentID, status]
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        environmentID = try container.decode(String.self, forKey: .environmentID)
        status = try container.decode(String.self, forKey: .status)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(environmentID, forKey: .environmentID)
        try container.encode(status, forKey: .status)
    }

}
