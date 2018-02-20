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

/** UpdateEnvironmentRequest. */
public struct UpdateEnvironmentRequest {

    /// Name that identifies the environment.
    public var name: String?

    /// Description of the environment.
    public var description: String?

    /**
     Initialize a `UpdateEnvironmentRequest` with member variables.

     - parameter name: Name that identifies the environment.
     - parameter description: Description of the environment.

     - returns: An initialized `UpdateEnvironmentRequest`.
    */
    public init(name: String? = nil, description: String? = nil) {
        self.name = name
        self.description = description
    }
}

extension UpdateEnvironmentRequest: Codable {

    private enum CodingKeys: String, CodingKey {
        case name = "name"
        case description = "description"
        static let allValues = [name, description]
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decodeIfPresent(String.self, forKey: .name)
        description = try container.decodeIfPresent(String.self, forKey: .description)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(name, forKey: .name)
        try container.encodeIfPresent(description, forKey: .description)
    }

}
