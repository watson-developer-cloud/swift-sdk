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

/** Summary of the disk usage statistics for this collection. */
public struct CollectionDiskUsage {

    /// Number of bytes used by the collection.
    public var usedBytes: Int?

    /**
     Initialize a `CollectionDiskUsage` with member variables.

     - parameter usedBytes: Number of bytes used by the collection.

     - returns: An initialized `CollectionDiskUsage`.
    */
    public init(usedBytes: Int? = nil) {
        self.usedBytes = usedBytes
    }
}

extension CollectionDiskUsage: Codable {

    private enum CodingKeys: String, CodingKey {
        case usedBytes = "used_bytes"
        static let allValues = [usedBytes]
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        usedBytes = try container.decodeIfPresent(Int.self, forKey: .usedBytes)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(usedBytes, forKey: .usedBytes)
    }

}
