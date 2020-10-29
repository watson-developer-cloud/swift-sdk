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
 Returns a scalar calculation across all documents for the field specified. Possible calculations include min, max, sum,
 average, and unique_count.
 */
public struct QueryCalculationAggregation: Codable, Equatable {

    /**
     The type of aggregation command used. Options include: term, histogram, timeslice, nested, filter, min, max, sum,
     average, unique_count, and top_hits.
     */
    public var type: String

    /**
     The field to perform the calculation on.
     */
    public var field: String

    /**
     The value of the calculation.
     */
    public var value: Double?

    // Map each property name to the key that shall be used for encoding/decoding.
    private enum CodingKeys: String, CodingKey {
        case type = "type"
        case field = "field"
        case value = "value"
    }

}
