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

/** A response containing the documents and aggregations for the query. */
public struct QueryResponse {

    public var matchingResults: Int?

    public var results: [QueryResult]?

    public var aggregations: [QueryAggregation]?

    public var passages: [QueryPassages]?

    public var duplicatesRemoved: Int?

    /**
     Initialize a `QueryResponse` with member variables.

     - parameter matchingResults:
     - parameter results:
     - parameter aggregations:
     - parameter passages:
     - parameter duplicatesRemoved:

     - returns: An initialized `QueryResponse`.
    */
    public init(matchingResults: Int? = nil, results: [QueryResult]? = nil, aggregations: [QueryAggregation]? = nil, passages: [QueryPassages]? = nil, duplicatesRemoved: Int? = nil) {
        self.matchingResults = matchingResults
        self.results = results
        self.aggregations = aggregations
        self.passages = passages
        self.duplicatesRemoved = duplicatesRemoved
    }
}

extension QueryResponse: Codable {

    private enum CodingKeys: String, CodingKey {
        case matchingResults = "matching_results"
        case results = "results"
        case aggregations = "aggregations"
        case passages = "passages"
        case duplicatesRemoved = "duplicates_removed"
        static let allValues = [matchingResults, results, aggregations, passages, duplicatesRemoved]
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        matchingResults = try container.decodeIfPresent(Int.self, forKey: .matchingResults)
        results = try container.decodeIfPresent([QueryResult].self, forKey: .results)
        aggregations = try container.decodeIfPresent([QueryAggregation].self, forKey: .aggregations)
        passages = try container.decodeIfPresent([QueryPassages].self, forKey: .passages)
        duplicatesRemoved = try container.decodeIfPresent(Int.self, forKey: .duplicatesRemoved)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(matchingResults, forKey: .matchingResults)
        try container.encodeIfPresent(results, forKey: .results)
        try container.encodeIfPresent(aggregations, forKey: .aggregations)
        try container.encodeIfPresent(passages, forKey: .passages)
        try container.encodeIfPresent(duplicatesRemoved, forKey: .duplicatesRemoved)
    }

}
