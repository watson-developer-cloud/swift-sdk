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

/** Details about an environment. */
public struct Environment {

    /// Status of the environment.
    public enum Status: String {
        case active = "active"
        case pending = "pending"
        case maintenance = "maintenance"
    }

    /// Unique identifier for the environment.
    public var environmentID: String?

    /// Name that identifies the environment.
    public var name: String?

    /// Description of the environment.
    public var description: String?

    /// Creation date of the environment, in the format yyyy-MM-dd'T'HH:mm:ss.SSS'Z'.
    public var created: String?

    /// Date of most recent environment update, in the format yyyy-MM-dd'T'HH:mm:ss.SSS'Z'.
    public var updated: String?

    /// Status of the environment.
    public var status: String?

    /// If true, then the environment contains read-only collections which are maintained by IBM.
    public var readOnly: Bool?

    /// **Deprecated**: Size of the environment.
    public var size: Int?

    /// Details about the resource usage and capacity of the environment.
    public var indexCapacity: IndexCapacity?

    /**
     Initialize a `Environment` with member variables.

     - parameter environmentID: Unique identifier for the environment.
     - parameter name: Name that identifies the environment.
     - parameter description: Description of the environment.
     - parameter created: Creation date of the environment, in the format yyyy-MM-dd'T'HH:mm:ss.SSS'Z'.
     - parameter updated: Date of most recent environment update, in the format yyyy-MM-dd'T'HH:mm:ss.SSS'Z'.
     - parameter status: Status of the environment.
     - parameter readOnly: If true, then the environment contains read-only collections which are maintained by IBM.
     - parameter size: **Deprecated**: Size of the environment.
     - parameter indexCapacity: Details about the resource usage and capacity of the environment.

     - returns: An initialized `Environment`.
    */
    public init(environmentID: String? = nil, name: String? = nil, description: String? = nil, created: String? = nil, updated: String? = nil, status: String? = nil, readOnly: Bool? = nil, size: Int? = nil, indexCapacity: IndexCapacity? = nil) {
        self.environmentID = environmentID
        self.name = name
        self.description = description
        self.created = created
        self.updated = updated
        self.status = status
        self.readOnly = readOnly
        self.size = size
        self.indexCapacity = indexCapacity
    }
}

extension Environment: Codable {

    private enum CodingKeys: String, CodingKey {
        case environmentID = "environment_id"
        case name = "name"
        case description = "description"
        case created = "created"
        case updated = "updated"
        case status = "status"
        case readOnly = "read_only"
        case size = "size"
        case indexCapacity = "index_capacity"
        static let allValues = [environmentID, name, description, created, updated, status, readOnly, size, indexCapacity]
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        environmentID = try container.decodeIfPresent(String.self, forKey: .environmentID)
        name = try container.decodeIfPresent(String.self, forKey: .name)
        description = try container.decodeIfPresent(String.self, forKey: .description)
        created = try container.decodeIfPresent(String.self, forKey: .created)
        updated = try container.decodeIfPresent(String.self, forKey: .updated)
        status = try container.decodeIfPresent(String.self, forKey: .status)
        readOnly = try container.decodeIfPresent(Bool.self, forKey: .readOnly)
        size = try container.decodeIfPresent(Int.self, forKey: .size)
        indexCapacity = try container.decodeIfPresent(IndexCapacity.self, forKey: .indexCapacity)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(environmentID, forKey: .environmentID)
        try container.encodeIfPresent(name, forKey: .name)
        try container.encodeIfPresent(description, forKey: .description)
        try container.encodeIfPresent(created, forKey: .created)
        try container.encodeIfPresent(updated, forKey: .updated)
        try container.encodeIfPresent(status, forKey: .status)
        try container.encodeIfPresent(readOnly, forKey: .readOnly)
        try container.encodeIfPresent(size, forKey: .size)
        try container.encodeIfPresent(indexCapacity, forKey: .indexCapacity)
    }

}
