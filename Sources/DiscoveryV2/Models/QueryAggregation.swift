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
 An abstract aggregation type produced by Discovery to analyze the input provided.
 */
public enum QueryAggregation: Codable, Equatable {

    case queryAggregation(GenericQueryAggregation)
    case term(QueryTermAggregation)
    case histogram(QueryHistogramAggregation)
    case timeslice(QueryTimesliceAggregation)
    case nested(QueryNestedAggregation)
    case filter(QueryFilterAggregation)
    case min(QueryCalculationAggregation)
    case max(QueryCalculationAggregation)
    case sum(QueryCalculationAggregation)
    case average(QueryCalculationAggregation)
    case uniqueCount(QueryCalculationAggregation)
    case topHits(QueryTopHitsAggregation)
    case groupBy(QueryGroupByAggregation)

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let genericInstance = try? container.decode(GenericQueryAggregation.self) {
            switch genericInstance.type {
            case "term":
                if let val = try? container.decode(QueryTermAggregation.self) {
                    self = .term(val)
                    return
                }
            case "histogram":
                if let val = try? container.decode(QueryHistogramAggregation.self) {
                    self = .histogram(val)
                    return
                }
            case "timeslice":
                if let val = try? container.decode(QueryTimesliceAggregation.self) {
                    self = .timeslice(val)
                    return
                }
            case "nested":
                if let val = try? container.decode(QueryNestedAggregation.self) {
                    self = .nested(val)
                    return
                }
            case "filter":
                if let val = try? container.decode(QueryFilterAggregation.self) {
                    self = .filter(val)
                    return
                }
            case "min":
                if let val = try? container.decode(QueryCalculationAggregation.self) {
                    self = .min(val)
                    return
                }
            case "max":
                if let val = try? container.decode(QueryCalculationAggregation.self) {
                    self = .max(val)
                    return
                }
            case "sum":
                if let val = try? container.decode(QueryCalculationAggregation.self) {
                    self = .sum(val)
                    return
                }
            case "average":
                if let val = try? container.decode(QueryCalculationAggregation.self) {
                    self = .average(val)
                    return
                }
            case "unique_count":
                if let val = try? container.decode(QueryCalculationAggregation.self) {
                    self = .uniqueCount(val)
                    return
                }
            case "top_hits":
                if let val = try? container.decode(QueryTopHitsAggregation.self) {
                    self = .topHits(val)
                    return
                }
            case "group_by":
                if let val = try? container.decode(QueryGroupByAggregation.self) {
                    self = .groupBy(val)
                    return
                }
            default:
                if let val = try? container.decode(GenericQueryAggregation.self) {
                    self = .queryAggregation(val)
                    return
                }
            }
        }

        throw DecodingError.typeMismatch(QueryAggregation.self,
                                         DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Decoding failed for all associated types"))
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .queryAggregation(let queryAggregation):
            try container.encode(queryAggregation)
        case .term(let term):
            try container.encode(term)
        case .histogram(let histogram):
            try container.encode(histogram)
        case .timeslice(let timeslice):
            try container.encode(timeslice)
        case .nested(let nested):
            try container.encode(nested)
        case .filter(let filter):
            try container.encode(filter)
        case .min(let min):
            try container.encode(min)
        case .max(let max):
            try container.encode(max)
        case .sum(let sum):
            try container.encode(sum)
        case .average(let average):
            try container.encode(average)
        case .uniqueCount(let unique_count):
            try container.encode(unique_count)
        case .topHits(let top_hits):
            try container.encode(top_hits)
        case .groupBy(let group_by):
            try container.encode(group_by)
        }
    }
}

public struct GenericQueryAggregation: Codable, Equatable {

    /**
     The type of aggregation command used. Options include: term, histogram, timeslice, nested, filter, min, max, sum,
     average, unique_count, and top_hits.
     */
    public var type: String

    // Map each property name to the key that shall be used for encoding/decoding.
    private enum CodingKeys: String, CodingKey {
        case type = "type"
    }

}
