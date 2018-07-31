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

/** Timeslice. */
public struct Timeslice: Decodable {

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
     The field where the aggregation is located in the document.
     */
    public var field: String?

    /**
     Interval of the aggregation. Valid date interval values are second/seconds minute/minutes, hour/hours, day/days,
     week/weeks, month/months, and year/years.
     */
    public var interval: String?

    /**
     Used to indicate that anomaly detection should be performed. Anomaly detection is used to locate unusual datapoints
     within a time series.
     */
    public var anomaly: Bool?

    // Map each property name to the key that shall be used for encoding/decoding.
    private enum CodingKeys: String, CodingKey {
        case type = "type"
        case results = "results"
        case matchingResults = "matching_results"
        case aggregations = "aggregations"
        case field = "field"
        case interval = "interval"
        case anomaly = "anomaly"
    }

}
