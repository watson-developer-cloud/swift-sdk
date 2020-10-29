/**
 * (C) Copyright IBM Corp. 2019, 2020.
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
 A timeslice interval segment.
 */
public struct QueryTimesliceAggregationResult: Codable, Equatable {

    /**
     String date value of the upper bound for the timeslice interval in ISO-8601 format.
     */
    public var keyAsString: String

    /**
     Numeric date value of the upper bound for the timeslice interval in UNIX milliseconds since epoch.
     */
    public var key: Int

    /**
     Number of documents with the specified key as the upper bound.
     */
    public var matchingResults: Int

    /**
     An array of sub aggregations.
     */
    public var aggregations: [QueryAggregation]?

    // Map each property name to the key that shall be used for encoding/decoding.
    private enum CodingKeys: String, CodingKey {
        case keyAsString = "key_as_string"
        case key = "key"
        case matchingResults = "matching_results"
        case aggregations = "aggregations"
    }

}
