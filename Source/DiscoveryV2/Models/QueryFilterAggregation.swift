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
 A modifier that will narrow down the document set of the sub aggregations it precedes.
 */
public struct QueryFilterAggregation: Codable, Equatable {

    /**
     The type of aggregation command used. Options include: term, histogram, timeslice, nested, filter, min, max, sum,
     average, unique_count, and top_hits.
     */
    public var type: String

    /**
     The filter written in Discovery Query Language syntax applied to the documents before sub aggregations are run.
     */
    public var match: String

    /**
     Number of documents matching the filter.
     */
    public var matchingResults: Int

    /**
     An array of sub aggregations.
     */
    public var aggregations: [QueryAggregation]?

    // Map each property name to the key that shall be used for encoding/decoding.
    private enum CodingKeys: String, CodingKey {
        case type = "type"
        case match = "match"
        case matchingResults = "matching_results"
        case aggregations = "aggregations"
    }

}
