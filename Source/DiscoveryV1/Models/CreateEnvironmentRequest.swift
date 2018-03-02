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

/** CreateEnvironmentRequest. */
public struct CreateEnvironmentRequest {

    /// Name that identifies the environment.
    public var name: String

    /// Description of the environment.
    public var description: String?

    /// **Deprecated**: Size of the environment.
    public var size: Int?

    /**
     Initialize a `CreateEnvironmentRequest` with member variables.

     - parameter name: Name that identifies the environment.
     - parameter description: Description of the environment.
     - parameter size: **Deprecated**: Size of the environment.

     - returns: An initialized `CreateEnvironmentRequest`.
    */
    public init(name: String, description: String? = nil, size: Int? = nil) {
        self.name = name
        self.description = description
        self.size = size
    }
}

extension CreateEnvironmentRequest: Codable {

    private enum CodingKeys: String, CodingKey {
        case name = "name"
        case description = "description"
        case size = "size"
        static let allValues = [name, description, size]
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decode(String.self, forKey: .name)
        description = try container.decodeIfPresent(String.self, forKey: .description)
        size = try container.decodeIfPresent(Int.self, forKey: .size)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encodeIfPresent(description, forKey: .description)
        try container.encodeIfPresent(size, forKey: .size)
    }

}
