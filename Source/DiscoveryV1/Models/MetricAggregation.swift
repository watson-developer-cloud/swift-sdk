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

/**
 An aggregation analyzing log information for queries and events.
 */
public struct MetricAggregation: Decodable {

    /**
     The measurement interval for this metric. Metric intervals are always 1 day (`1d`).
     */
    public var interval: String?

    /**
     The event type associated with this metric result. This field, when present, will always be `click`.
     */
    public var eventType: String?

    public var results: [MetricAggregationResult]?

    // Map each property name to the key that shall be used for encoding/decoding.
    private enum CodingKeys: String, CodingKey {
        case interval = "interval"
        case eventType = "event_type"
        case results = "results"
    }

}
