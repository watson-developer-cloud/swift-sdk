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

/** UpdateCollectionRequest. */
public struct UpdateCollectionRequest {

    /// The name of the collection.
    public var name: String

    /// A description of the collection.
    public var description: String?

    /// The ID of the configuration in which the collection is to be updated.
    public var configurationID: String?

    /**
     Initialize a `UpdateCollectionRequest` with member variables.

     - parameter name: The name of the collection.
     - parameter description: A description of the collection.
     - parameter configurationID: The ID of the configuration in which the collection is to be updated.

     - returns: An initialized `UpdateCollectionRequest`.
    */
    public init(name: String, description: String? = nil, configurationID: String? = nil) {
        self.name = name
        self.description = description
        self.configurationID = configurationID
    }
}

extension UpdateCollectionRequest: Codable {

    private enum CodingKeys: String, CodingKey {
        case name = "name"
        case description = "description"
        case configurationID = "configuration_id"
        static let allValues = [name, description, configurationID]
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decode(String.self, forKey: .name)
        description = try container.decodeIfPresent(String.self, forKey: .description)
        configurationID = try container.decodeIfPresent(String.self, forKey: .configurationID)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encodeIfPresent(description, forKey: .description)
        try container.encodeIfPresent(configurationID, forKey: .configurationID)
    }

}
