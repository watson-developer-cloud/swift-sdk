/**
 * Copyright IBM Corporation 2019
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

/**
 Aggregation result data for the requested metric.
 */
public struct MetricAggregationResult: Codable, Equatable {

    /**
     Date in string form representing the start of this interval.
     */
    public var keyAsString: Date?

    /**
     Unix epoch time equivalent of the **key_as_string**, that represents the start of this interval.
     */
    public var key: Int?

    /**
     Number of matching results.
     */
    public var matchingResults: Int?

    /**
     The number of queries with associated events divided by the total number of queries for the interval. Only returned
     with **event_rate** metrics.
     */
    public var eventRate: Double?

    // Map each property name to the key that shall be used for encoding/decoding.
    private enum CodingKeys: String, CodingKey {
        case keyAsString = "key_as_string"
        case key = "key"
        case matchingResults = "matching_results"
        case eventRate = "event_rate"
    }

}
