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

/** Filter. */
public struct Filter: Codable, Equatable {

    /**
     The type of aggregation command used. For example: term, filter, max, min, etc.
     */
    public var type: String?

    public var results: [AggregationResult]?

    /**
     Number of matching results.
     */
    public var matchingResults: Int?

    /**
     Aggregations returned by the Discovery service.
     */
    public var aggregations: [QueryAggregation]?

    /**
     The match the aggregated results queried for.
     */
    public var match: String?

    // Map each property name to the key that shall be used for encoding/decoding.
    private enum CodingKeys: String, CodingKey {
        case type = "type"
        case results = "results"
        case matchingResults = "matching_results"
        case aggregations = "aggregations"
        case match = "match"
    }

}
