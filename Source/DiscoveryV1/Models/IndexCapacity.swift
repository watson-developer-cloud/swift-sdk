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

/** Details about the resource usage and capacity of the environment. */
public struct IndexCapacity {

    /// Summary of the document usage statistics for the environment.
    public var documents: EnvironmentDocuments?

    /// Summary of the disk usage of the environment.
    public var diskUsage: DiskUsage?

    /// Summary of the collection usage in the environment.
    public var collections: CollectionUsage?

    /// **Deprecated**: Summary of the memory usage of the environment.
    public var memoryUsage: MemoryUsage?

    /**
     Initialize a `IndexCapacity` with member variables.

     - parameter documents: Summary of the document usage statistics for the environment.
     - parameter diskUsage: Summary of the disk usage of the environment.
     - parameter collections: Summary of the collection usage in the environment.
     - parameter memoryUsage: **Deprecated**: Summary of the memory usage of the environment.

     - returns: An initialized `IndexCapacity`.
    */
    public init(documents: EnvironmentDocuments? = nil, diskUsage: DiskUsage? = nil, collections: CollectionUsage? = nil, memoryUsage: MemoryUsage? = nil) {
        self.documents = documents
        self.diskUsage = diskUsage
        self.collections = collections
        self.memoryUsage = memoryUsage
    }
}

extension IndexCapacity: Codable {

    private enum CodingKeys: String, CodingKey {
        case documents = "documents"
        case diskUsage = "disk_usage"
        case collections = "collections"
        case memoryUsage = "memory_usage"
        static let allValues = [documents, diskUsage, collections, memoryUsage]
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        documents = try container.decodeIfPresent(EnvironmentDocuments.self, forKey: .documents)
        diskUsage = try container.decodeIfPresent(DiskUsage.self, forKey: .diskUsage)
        collections = try container.decodeIfPresent(CollectionUsage.self, forKey: .collections)
        memoryUsage = try container.decodeIfPresent(MemoryUsage.self, forKey: .memoryUsage)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(documents, forKey: .documents)
        try container.encodeIfPresent(diskUsage, forKey: .diskUsage)
        try container.encodeIfPresent(collections, forKey: .collections)
        try container.encodeIfPresent(memoryUsage, forKey: .memoryUsage)
    }

}
