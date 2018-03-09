/**
 * Copyright IBM Corporation 2016
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

/** An aggregation produced by the Discovery service to analyze the input provided. */
public struct Aggregation: JSONDecodable {

    /// Type of aggregation command used. e.g. term, filter, max, min, etc.
    public let type: String?

    /// The field where the aggregation is located in the document.
    public let field: String?

    /// Results of the aggregation.
    public let results: [AggregationResult]?

    /// The match the aggregated results queried for.
    public let match: String?

    /// Number of matching results.
    public let matchingResults: Int?

    /// Aggregations returned by the Discovery service.
    public let aggregations: [Aggregation]?

    /// Interval specified by using aggregation type 'timeslice'.
    public let interval: String?

    /// Value of the aggregation. (For 'max' and 'min' type).
    public let value: Double?

    /// The raw JSON object used to construct this model.
    public let json: [String: Any]

    /// Used internally to initialize an `Aggregation` model from JSON.
    public init(json: JSONWrapper) throws {
        type = try? json.getString(at: "type")
        field = try? json.getString(at: "field")
        results = try? json.decodedArray(at: "results", type: AggregationResult.self)
        match = try? json.getString(at: "match")
        matchingResults = try? json.getInt(at: "matching_results")
        aggregations = try? json.decodedArray(at: "aggregations", type: Aggregation.self)
        interval = try? json.getString(at: "interval")
        value = try? json.getDouble(at: "value")
        self.json = try json.getDictionaryObject()
    }

    /// Used internally to serialize an 'Aggregation' model to JSON.
    public func toJSONObject() -> Any {
        return json
    }
}

/** Results of the aggregation. */
public struct AggregationResult: JSONDecodable {

    /// Key that matched the aggregation type.
    public let key: String?

    /// Number of matching results.
    public let matchingResults: Int?

    /// Aggregations returned in the case of chained aggregations.
    public let aggregations: [Aggregation]?

    /// The raw JSON object used to construct this model.
    public let json: [String: Any]

    /// Used internally to initialze an 'AggregationResult' model from JSON.
    public init(json: JSONWrapper) throws {
        key = try? json.getString(at: "key")
        matchingResults = try? json.getInt(at: "matching_results")
        aggregations = try? json.decodedArray(at: "aggregations", type: Aggregation.self)
        self.json = try json.getDictionaryObject()
    }

    /// Used internally to serialize an 'AggregationResult' model to JSON.
    public func toJSONObject() -> Any {
        return json
    }
}
