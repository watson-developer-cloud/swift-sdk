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

/** An aggregation produced by the Discovery service to analyze the input provided. */
public enum QueryAggregation: Codable, Equatable {

    // reference: https://cloud.ibm.com/docs/services/discovery/query-reference.html#aggregations

    case term(Term)
    case filter(Filter)
    case nested(Nested)
    case histogram(Histogram)
    case timeslice(Timeslice)
    case topHits(TopHits)
    case uniqueCount(Calculation)
    case max(Calculation)
    case min(Calculation)
    case average(Calculation)
    case sum(Calculation)
    case generic(GenericQueryAggregation)

    private enum CodingKeys: String, CodingKey {
        case type = "type"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        guard let type = try container.decodeIfPresent(String.self, forKey: .type) else {
            // the specification does not identify `type` as a required field,
            // so we need a generic catch-all in case it is not present
            self = .generic(try GenericQueryAggregation(from: decoder))
            return
        }
        switch type {
        case "term": self = .term(try Term(from: decoder))
        case "filter": self = .filter(try Filter(from: decoder))
        case "nested": self = .nested(try Nested(from: decoder))
        case "histogram": self = .histogram(try Histogram(from: decoder))
        case "timeslice": self = .timeslice(try Timeslice(from: decoder))
        case "top_hits": self = .topHits(try TopHits(from: decoder))
        case "unique_count": self = .uniqueCount(try Calculation(from: decoder))
        case "max": self = .max(try Calculation(from: decoder))
        case "min": self = .min(try Calculation(from: decoder))
        case "average": self = .average(try Calculation(from: decoder))
        case "sum": self = .sum(try Calculation(from: decoder))
        default: self = .generic(try GenericQueryAggregation(from: decoder))
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        switch self {
        case .term(let term):
            try container.encode("term", forKey: .type)
            try term.encode(to: encoder)
        case .filter(let filter):
            try container.encode("filter", forKey: .type)
            try filter.encode(to: encoder)
        case .nested(let nested):
            try container.encode("nested", forKey: .type)
            try nested.encode(to: encoder)
        case .histogram(let histogram):
            try container.encode("histogram", forKey: .type)
            try histogram.encode(to: encoder)
        case .timeslice(let timeslice):
            try container.encode("timeslice", forKey: .type)
            try timeslice.encode(to: encoder)
        case .topHits(let topHits):
            try container.encode("top_hits", forKey: .type)
            try topHits.encode(to: encoder)
        case .uniqueCount(let uniqueCount):
            try container.encode("unique_count", forKey: .type)
            try uniqueCount.encode(to: encoder)
        case .max(let max):
            try container.encode("max", forKey: .type)
            try max.encode(to: encoder)
        case .min(let min):
            try container.encode("min", forKey: .type)
            try min.encode(to: encoder)
        case .average(let average):
            try container.encode("average", forKey: .type)
            try average.encode(to: encoder)
        case .sum(let sum):
            try container.encode("sum", forKey: .type)
            try sum.encode(to: encoder)
        case .generic(let generic):
            try generic.encode(to: encoder)
        }
    }

}
