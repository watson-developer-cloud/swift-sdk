/**
 * Copyright IBM Corporation 2016
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
public struct Environment: JSONDecodable {

    /// Unique identifier for this environment.
    public let environmentID: String

    /// Name that identifies this environment.
    public let name: String

    /// Description of the environment.
    public let description: String

    /// Creation date of the environment, in the format yyyy-MM-dd'T'HH:mm:ss.SSS'Z'.
    public let created: String

    /// Date of most recent environment update, in the format yyyy-MM-dd'T'HH:mm:ss.SSS'Z'.
    public let updated: String

    /// Status of the environment.
    public let status: String

    /// If true, then the environment contains read-only collections which are maintained by IBM.
    public let readOnly: Bool?

    /// Object containing information about disk and memory usage.
    public let indexCapacity: IndexCapacity?

    /// Used internally to initialize an `Environment` model from JSON.
    public init(json: JSONWrapper) throws {
        environmentID = try json.getString(at: "environment_id")
        name = try json.getString(at: "name")
        description = try json.getString(at: "description")
        // Some environments (e.g. System environment) do not contain created or updated
        created = (try? json.getString(at: "created")) ?? ""
        updated = (try? json.getString(at: "updated")) ?? ""
        // Some instances of environment do not contain status
        status = (try? json.getString(at: "status")) ?? ""
        readOnly = try? json.getBool(at: "read_only")
        indexCapacity = try? json.decode(at: "index_capacity")
    }
}

/** Details about the disk and memory usage of this environment. */
public struct IndexCapacity: JSONDecodable {

    /// Summary of the disk usage of the environment.
    public let diskUsage: DiskUsage

    /// Summary of the memory usage of the environment.
    public let memoryUsage: MemoryUsage

    /// Used internally to initialize an `IndexCapacity` model from JSON.
    public init(json: JSONWrapper) throws {
        diskUsage = try json.decode(at: "disk_usage")
        memoryUsage = try json.decode(at: "memory_usage")
    }
}

/** Summary of the disk usage statistics for this environment. */
public struct DiskUsage: JSONDecodable {

    /// Number of bytes used on the environment's disk capacity.
    public let usedBytes: Int

    /// Total number of bytes available in the environment's disk capacity.
    public let totalBytes: Int

    /// Amount of disk capacity used, in KB or GB format.
    public let used: String

    /// Total amount of the environment's disk capacity, in KB or GB format.
    public let total: String

    /// Percentage of the environment's disk capacity that is being used.
    public let percentUsed: Double

    /// Used internally to initialize a `DiskUsage` model from JSON.
    public init(json: JSONWrapper) throws {
        usedBytes = try json.getInt(at: "used_bytes")
        totalBytes = try json.getInt(at: "total_bytes")
        used = try json.getString(at: "used")
        total = try json.getString(at: "total")
        percentUsed = try json.getDouble(at: "percent_used")
    }
}

/** Summary of the memory usage statistics for this environment. */
public struct MemoryUsage: JSONDecodable {

    /// Number of bytes used in the environment's memory capacity.
    public let usedBytes: Int

    /// Total number of bytes available in the environment's memory capacity.
    public let totalBytes: Int

    /// Amount of memory capacity used, in KB or GB format.
    public let used: String

    /// Total amount of the environment's memory capacity, in KB or GB format.
    public let total: String

    /// Percentage of the environment's memory capacity that is being used.
    public let percentUsed: Double

    /// Used internally to initialize a `MemoryUsage` model from JSON.
    public init(json: JSONWrapper) throws {
        usedBytes = try json.getInt(at: "used_bytes")
        totalBytes = try json.getInt(at: "total_bytes")
        used = try json.getString(at: "used")
        total = try json.getString(at: "total")
        percentUsed = try json.getDouble(at: "percent_used")
    }
}

/** The size of the environment. */
public enum EnvironmentSize: Int {

    /// A free trial environment. 2GB disk space, 1GB RAM, unlimited enrichments, single search
    /// node, so therefore no high availability. 30-day trial only.
    /// Only one free trial environment per service instance is allowed.
    case zero = 0

    /// 48GB disk space, 2GB RAM, 4000 enrichments.
    case one = 1

    /// 192GB disk space, 8GB RAM, 16000 enrichments.
    case two = 2

    /// 384GB disk space, 16GB RAM, 32000 enrichments.
    case three = 3
}
