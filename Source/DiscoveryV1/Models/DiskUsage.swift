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

/** Summary of the disk usage statistics for the environment. */
public struct DiskUsage {

    /// Number of bytes used on the environment's disk capacity.
    public var usedBytes: Int?

    /// Total number of bytes available in the environment's disk capacity.
    public var maximumAllowedBytes: Int?

    /// **Deprecated**: Total number of bytes available in the environment's disk capacity.
    public var totalBytes: Int?

    /// **Deprecated**: Amount of disk capacity used, in KB or GB format.
    public var used: String?

    /// **Deprecated**: Total amount of the environment's disk capacity, in KB or GB format.
    public var total: String?

    /// **Deprecated**: Percentage of the environment's disk capacity that is being used.
    public var percentUsed: Double?

    /**
     Initialize a `DiskUsage` with member variables.

     - parameter usedBytes: Number of bytes used on the environment's disk capacity.
     - parameter maximumAllowedBytes: Total number of bytes available in the environment's disk capacity.
     - parameter totalBytes: **Deprecated**: Total number of bytes available in the environment's disk capacity.
     - parameter used: **Deprecated**: Amount of disk capacity used, in KB or GB format.
     - parameter total: **Deprecated**: Total amount of the environment's disk capacity, in KB or GB format.
     - parameter percentUsed: **Deprecated**: Percentage of the environment's disk capacity that is being used.

     - returns: An initialized `DiskUsage`.
    */
    public init(usedBytes: Int? = nil, maximumAllowedBytes: Int? = nil, totalBytes: Int? = nil, used: String? = nil, total: String? = nil, percentUsed: Double? = nil) {
        self.usedBytes = usedBytes
        self.maximumAllowedBytes = maximumAllowedBytes
        self.totalBytes = totalBytes
        self.used = used
        self.total = total
        self.percentUsed = percentUsed
    }
}

extension DiskUsage: Codable {

    private enum CodingKeys: String, CodingKey {
        case usedBytes = "used_bytes"
        case maximumAllowedBytes = "maximum_allowed_bytes"
        case totalBytes = "total_bytes"
        case used = "used"
        case total = "total"
        case percentUsed = "percent_used"
        static let allValues = [usedBytes, maximumAllowedBytes, totalBytes, used, total, percentUsed]
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        usedBytes = try container.decodeIfPresent(Int.self, forKey: .usedBytes)
        maximumAllowedBytes = try container.decodeIfPresent(Int.self, forKey: .maximumAllowedBytes)
        totalBytes = try container.decodeIfPresent(Int.self, forKey: .totalBytes)
        used = try container.decodeIfPresent(String.self, forKey: .used)
        total = try container.decodeIfPresent(String.self, forKey: .total)
        percentUsed = try container.decodeIfPresent(Double.self, forKey: .percentUsed)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(usedBytes, forKey: .usedBytes)
        try container.encodeIfPresent(maximumAllowedBytes, forKey: .maximumAllowedBytes)
        try container.encodeIfPresent(totalBytes, forKey: .totalBytes)
        try container.encodeIfPresent(used, forKey: .used)
        try container.encodeIfPresent(total, forKey: .total)
        try container.encodeIfPresent(percentUsed, forKey: .percentUsed)
    }

}
