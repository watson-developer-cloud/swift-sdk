/**
 * (C) Copyright IBM Corp. 2019.
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
 Numeric interval segments to categorize documents by using field values from a single numeric field to describe the
 category.
 */
public struct QueryHistogramAggregation: Codable, Equatable {

    /**
     The type of aggregation command used. Options include: term, histogram, timeslice, nested, filter, min, max, sum,
     average, unique_count, and top_hits.
     */
    public var type: String

    /**
     The numeric field name used to create the histogram.
     */
    public var field: String

    /**
     The size of the sections the results are split into.
     */
    public var interval: Int

    /**
     Array of numeric intervals.
     */
    public var results: [QueryHistogramAggregationResult]?

    // Map each property name to the key that shall be used for encoding/decoding.
    private enum CodingKeys: String, CodingKey {
        case type = "type"
        case field = "field"
        case interval = "interval"
        case results = "results"
    }

}
