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
import RestKit

/** Detailed results for a specific characteristic of the input text. */
public struct TraitTreeNode: JSONDecodable {

    /// The globally unique id of the characteristic.
    public let id: String

    /// The user-displayable name of the characteristic.
    public let name: String

    /// The category of the characteristic: personality,
    /// needs, values, or behavior (for temporal data).
    public let category: String?

    /// For personality, needs, and values characteristics, the normalized
    /// percentile score for the characteristic, from 0-1. For example, if
    /// the percentage for Openness is 0.25, the author scored in the 25th
    /// percentile; the author is more open than 24% of the population and
    /// less open than 74% of the population. For temporal behavior
    /// characteristics, the percentage of timestamped data that occurred
    /// during that day or hour.
    public let percentage: Double?

    /// Indicates the sampling error of the percentage based on the number
    /// of words in the input, from 0-1. The number defines a 95% confidence
    /// interval around the percentage. For example, if the sampling error
    /// is 4% and the percentage is 61%, it is 95% likely that the actual
    /// percentage value is between 57% and 65% if more words are given.
    public let samplingError: Double?

    /// For personality, needs, and values characteristics, the raw score
    /// for the characteristic. A positive or negative score indicates
    /// more or less of the characteristic; zero indicates neutrality
    /// or no evidence for a score. The raw score is computed based on
    /// the input and the service model; it is not normalized or compared
    /// with a sample population. The raw score enables comparison of the
    /// results against a different sampling population and with a custom
    /// normalization approach.
    public let rawScore: Double?

    /// Indicates the sampling error of the raw score based on the number
    /// of words in the input; the practical range is 0-1. The number
    /// defines a 95% confidence interval around the raw score. For
    /// example, if the raw sampling error is 5% and the raw score is
    /// 65%, it is 95% likely that the actual raw score is between
    /// 60% and 70% if more words are given.
    public let rawSamplingError: Double?

    /// Recursive array of characteristics inferred from the input text.
    public let children: [TraitTreeNode]?

    /// Used internally to initialize a `TraitTreeNode` model from JSON.
    public init(json: JSON) throws {
        id = try json.getString(at: "id")
        name = try json.getString(at: "name")
        category = try? json.getString(at: "category")
        percentage = try? json.getDouble(at: "percentage")
        samplingError = try? json.getDouble(at: "sampling_error")
        rawScore = try? json.getDouble(at: "raw_score")
        rawSamplingError = try? json.getDouble(at: "raw_sampling_error")
        children = try? json.decodedArray(at: "children")
    }
}
