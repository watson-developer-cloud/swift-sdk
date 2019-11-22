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
 Top value result for the term aggregation.
 */
public struct QueryTermAggregationResult: Codable, Equatable {

    /**
     Value of the field with a non-zero frequency in the document set.
     */
    public var key: String

    /**
     Number of documents containing the 'key'.
     */
    public var matchingResults: Int

    /**
     An array of sub aggregations.
     */
    public var aggregations: [QueryAggregation]?

    // Map each property name to the key that shall be used for encoding/decoding.
    private enum CodingKeys: String, CodingKey {
        case key = "key"
        case matchingResults = "matching_results"
        case aggregations = "aggregations"
    }

}
