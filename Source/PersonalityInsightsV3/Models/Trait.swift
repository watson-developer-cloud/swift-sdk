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

/** Trait. */
public struct Trait {

    /// The category of the characteristic: * `personality` for Big Five personality characteristics * `needs` for Needs * `values` for Values.
    public enum Category: String {
        case personality = "personality"
        case needs = "needs"
        case values = "values"
    }

    /// The unique identifier of the characteristic to which the results pertain. IDs have the form `big5_{characteristic}` for Big Five personality characteristics, `need_{characteristic}` for Needs, or `value_{characteristic}` for Values.
    public var traitID: String

    /// The user-visible name of the characteristic.
    public var name: String

    /// The category of the characteristic: * `personality` for Big Five personality characteristics * `needs` for Needs * `values` for Values.
    public var category: String

    /// The normalized percentile score for the characteristic. The range is 0 to 1. For example, if the percentage for Openness is 0.60, the author scored in the 60th percentile; the author is more open than 59 percent of the population and less open than 39 percent of the population.
    public var percentile: Double

    /// The raw score for the characteristic. The range is 0 to 1. A higher score generally indicates a greater likelihood that the author has that characteristic, but raw scores must be considered in aggregate: The range of values in practice might be much smaller than 0 to 1, so an individual score must be considered in the context of the overall scores and their range. The raw score is computed based on the input and the service model; it is not normalized or compared with a sample population. The raw score enables comparison of the results against a different sampling population and with a custom normalization approach.
    public var rawScore: Double?

    /// **`2017-10-13`**: Indicates whether the characteristic is meaningful for the input language. The field is always `true` for all characteristics of English, Spanish, and Japanese input. The field is `false` for the subset of characteristics of Arabic and Korean input for which the service's models are unable to generate meaningful results. **`2016-10-19`**: Not returned.
    public var significant: Bool?

    /// For `personality` (Big Five) dimensions, more detailed results for the facets of each dimension as inferred from the input text.
    public var children: [Trait]?

    /**
     Initialize a `Trait` with member variables.

     - parameter traitID: The unique identifier of the characteristic to which the results pertain. IDs have the form `big5_{characteristic}` for Big Five personality characteristics, `need_{characteristic}` for Needs, or `value_{characteristic}` for Values.
     - parameter name: The user-visible name of the characteristic.
     - parameter category: The category of the characteristic: * `personality` for Big Five personality characteristics * `needs` for Needs * `values` for Values.
     - parameter percentile: The normalized percentile score for the characteristic. The range is 0 to 1. For example, if the percentage for Openness is 0.60, the author scored in the 60th percentile; the author is more open than 59 percent of the population and less open than 39 percent of the population.
     - parameter rawScore: The raw score for the characteristic. The range is 0 to 1. A higher score generally indicates a greater likelihood that the author has that characteristic, but raw scores must be considered in aggregate: The range of values in practice might be much smaller than 0 to 1, so an individual score must be considered in the context of the overall scores and their range. The raw score is computed based on the input and the service model; it is not normalized or compared with a sample population. The raw score enables comparison of the results against a different sampling population and with a custom normalization approach.
     - parameter significant: **`2017-10-13`**: Indicates whether the characteristic is meaningful for the input language. The field is always `true` for all characteristics of English, Spanish, and Japanese input. The field is `false` for the subset of characteristics of Arabic and Korean input for which the service's models are unable to generate meaningful results. **`2016-10-19`**: Not returned.
     - parameter children: For `personality` (Big Five) dimensions, more detailed results for the facets of each dimension as inferred from the input text.

     - returns: An initialized `Trait`.
    */
    public init(traitID: String, name: String, category: String, percentile: Double, rawScore: Double? = nil, significant: Bool? = nil, children: [Trait]? = nil) {
        self.traitID = traitID
        self.name = name
        self.category = category
        self.percentile = percentile
        self.rawScore = rawScore
        self.significant = significant
        self.children = children
    }
}

extension Trait: Codable {

    private enum CodingKeys: String, CodingKey {
        case traitID = "trait_id"
        case name = "name"
        case category = "category"
        case percentile = "percentile"
        case rawScore = "raw_score"
        case significant = "significant"
        case children = "children"
        static let allValues = [traitID, name, category, percentile, rawScore, significant, children]
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        traitID = try container.decode(String.self, forKey: .traitID)
        name = try container.decode(String.self, forKey: .name)
        category = try container.decode(String.self, forKey: .category)
        percentile = try container.decode(Double.self, forKey: .percentile)
        rawScore = try container.decodeIfPresent(Double.self, forKey: .rawScore)
        significant = try container.decodeIfPresent(Bool.self, forKey: .significant)
        children = try container.decodeIfPresent([Trait].self, forKey: .children)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(traitID, forKey: .traitID)
        try container.encode(name, forKey: .name)
        try container.encode(category, forKey: .category)
        try container.encode(percentile, forKey: .percentile)
        try container.encodeIfPresent(rawScore, forKey: .rawScore)
        try container.encodeIfPresent(significant, forKey: .significant)
        try container.encodeIfPresent(children, forKey: .children)
    }

}
