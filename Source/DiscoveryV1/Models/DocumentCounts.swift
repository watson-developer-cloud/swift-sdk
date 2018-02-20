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

/** DocumentCounts. */
public struct DocumentCounts {

    /// The total number of available documents in the collection.
    public var available: Int?

    /// The number of documents in the collection that are currently being processed.
    public var processing: Int?

    /// The number of documents in the collection that failed to be ingested.
    public var failed: Int?

    /**
     Initialize a `DocumentCounts` with member variables.

     - parameter available: The total number of available documents in the collection.
     - parameter processing: The number of documents in the collection that are currently being processed.
     - parameter failed: The number of documents in the collection that failed to be ingested.

     - returns: An initialized `DocumentCounts`.
    */
    public init(available: Int? = nil, processing: Int? = nil, failed: Int? = nil) {
        self.available = available
        self.processing = processing
        self.failed = failed
    }
}

extension DocumentCounts: Codable {

    private enum CodingKeys: String, CodingKey {
        case available = "available"
        case processing = "processing"
        case failed = "failed"
        static let allValues = [available, processing, failed]
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        available = try container.decodeIfPresent(Int.self, forKey: .available)
        processing = try container.decodeIfPresent(Int.self, forKey: .processing)
        failed = try container.decodeIfPresent(Int.self, forKey: .failed)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(available, forKey: .available)
        try container.encodeIfPresent(processing, forKey: .processing)
        try container.encodeIfPresent(failed, forKey: .failed)
    }

}
