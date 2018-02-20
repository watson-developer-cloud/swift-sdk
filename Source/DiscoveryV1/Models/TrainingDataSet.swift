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

/** TrainingDataSet. */
public struct TrainingDataSet {

    public var environmentID: String?

    public var collectionID: String?

    public var queries: [TrainingQuery]?

    /**
     Initialize a `TrainingDataSet` with member variables.

     - parameter environmentID:
     - parameter collectionID:
     - parameter queries:

     - returns: An initialized `TrainingDataSet`.
    */
    public init(environmentID: String? = nil, collectionID: String? = nil, queries: [TrainingQuery]? = nil) {
        self.environmentID = environmentID
        self.collectionID = collectionID
        self.queries = queries
    }
}

extension TrainingDataSet: Codable {

    private enum CodingKeys: String, CodingKey {
        case environmentID = "environment_id"
        case collectionID = "collection_id"
        case queries = "queries"
        static let allValues = [environmentID, collectionID, queries]
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        environmentID = try container.decodeIfPresent(String.self, forKey: .environmentID)
        collectionID = try container.decodeIfPresent(String.self, forKey: .collectionID)
        queries = try container.decodeIfPresent([TrainingQuery].self, forKey: .queries)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(environmentID, forKey: .environmentID)
        try container.encodeIfPresent(collectionID, forKey: .collectionID)
        try container.encodeIfPresent(queries, forKey: .queries)
    }

}
