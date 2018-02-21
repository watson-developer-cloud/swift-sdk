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

/** An aggregation produced by the Discovery service to analyze the input provided. */
public struct QueryAggregation {

    /// The type of aggregation command used. For example: term, filter, max, min, etc.
    public var type: String?

    /// The field where the aggregation is located in the document.
    public var field: String?

    public var results: [AggregationResult]?

    /// The match the aggregated results queried for.
    public var match: String?

    /// Number of matching results.
    public var matchingResults: Int?

    /// Aggregations returned by the Discovery service.
    public var aggregations: [QueryAggregation]?

    /**
     Initialize a `QueryAggregation` with member variables.

     - parameter type: The type of aggregation command used. For example: term, filter, max, min, etc.
     - parameter field: The field where the aggregation is located in the document.
     - parameter results:
     - parameter match: The match the aggregated results queried for.
     - parameter matchingResults: Number of matching results.
     - parameter aggregations: Aggregations returned by the Discovery service.

     - returns: An initialized `QueryAggregation`.
    */
    public init(type: String? = nil, field: String? = nil, results: [AggregationResult]? = nil, match: String? = nil, matchingResults: Int? = nil, aggregations: [QueryAggregation]? = nil) {
        self.type = type
        self.field = field
        self.results = results
        self.match = match
        self.matchingResults = matchingResults
        self.aggregations = aggregations
    }
}

extension QueryAggregation: Codable {

    private enum CodingKeys: String, CodingKey {
        case type = "type"
        case field = "field"
        case results = "results"
        case match = "match"
        case matchingResults = "matching_results"
        case aggregations = "aggregations"
        static let allValues = [type, field, results, match, matchingResults, aggregations]
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        type = try container.decodeIfPresent(String.self, forKey: .type)
        field = try container.decodeIfPresent(String.self, forKey: .field)
        results = try container.decodeIfPresent([AggregationResult].self, forKey: .results)
        match = try container.decodeIfPresent(String.self, forKey: .match)
        matchingResults = try container.decodeIfPresent(Int.self, forKey: .matchingResults)
        aggregations = try container.decodeIfPresent([QueryAggregation].self, forKey: .aggregations)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(type, forKey: .type)
        try container.encodeIfPresent(field, forKey: .field)
        try container.encodeIfPresent(results, forKey: .results)
        try container.encodeIfPresent(match, forKey: .match)
        try container.encodeIfPresent(matchingResults, forKey: .matchingResults)
        try container.encodeIfPresent(aggregations, forKey: .aggregations)
    }

}
