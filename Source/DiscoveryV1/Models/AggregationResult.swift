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
public struct AggregationResult: Codable, Equatable {

    /**
     Key that matched the aggregation type.
     */
    public var key: String?

    /**
     Number of matching results.
     */
    public var matchingResults: Int?

    /**
     Aggregations returned in the case of chained aggregations.
     */
    public var aggregations: [QueryAggregation]?

    // Map each property name to the key that shall be used for encoding/decoding.
    private enum CodingKeys: String, CodingKey {
        case key = "key"
        case matchingResults = "matching_results"
        case aggregations = "aggregations"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        if let keyAsString = try? container.decode(String.self, forKey: .key) { key = keyAsString }
        if let keyAsInt = try? container.decode(Int.self, forKey: .key) { key = "\(keyAsInt)" }
        matchingResults = try container.decodeIfPresent(Int.self, forKey: .matchingResults)
        aggregations = try container.decodeIfPresent([QueryAggregation].self, forKey: .aggregations)
    }

}
