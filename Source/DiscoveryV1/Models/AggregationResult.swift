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

/** AggregationResult. */
public struct AggregationResult {

    /// Key that matched the aggregation type.
    public var key: String?

    /// Number of matching results.
    public var matchingResults: Int?

    /// Aggregations returned in the case of chained aggregations.
    public var aggregations: [QueryAggregation]?

    /**
     Initialize a `AggregationResult` with member variables.

     - parameter key: Key that matched the aggregation type.
     - parameter matchingResults: Number of matching results.
     - parameter aggregations: Aggregations returned in the case of chained aggregations.

     - returns: An initialized `AggregationResult`.
    */
    public init(key: String? = nil, matchingResults: Int? = nil, aggregations: [QueryAggregation]? = nil) {
        self.key = key
        self.matchingResults = matchingResults
        self.aggregations = aggregations
    }
}

extension AggregationResult: Codable {

    private enum CodingKeys: String, CodingKey {
        case key = "key"
        case matchingResults = "matching_results"
        case aggregations = "aggregations"
        static let allValues = [key, matchingResults, aggregations]
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        key = try container.decodeIfPresent(String.self, forKey: .key)
        matchingResults = try container.decodeIfPresent(Int.self, forKey: .matchingResults)
        aggregations = try container.decodeIfPresent([QueryAggregation].self, forKey: .aggregations)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(key, forKey: .key)
        try container.encodeIfPresent(matchingResults, forKey: .matchingResults)
        try container.encodeIfPresent(aggregations, forKey: .aggregations)
    }

}
