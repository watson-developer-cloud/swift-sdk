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
public struct Trait: Decodable {

    /**
     The category of the characteristic: `personality` for Big Five personality characteristics, `needs` for Needs, and
     `values` for Values.
     */
    public enum Category: String {
        case personality = "personality"
        case needs = "needs"
        case values = "values"
    }

    /**
     The unique, non-localized identifier of the characteristic to which the results pertain. IDs have the form
     * `big5_{characteristic}` for Big Five personality dimensions
     * `facet_{characteristic}` for Big Five personality facets
     * `need_{characteristic}` for Needs
      *`value_{characteristic}` for Values.
     */
    public var traitID: String

    /**
     The user-visible, localized name of the characteristic.
     */
    public var name: String

    /**
     The category of the characteristic: `personality` for Big Five personality characteristics, `needs` for Needs, and
     `values` for Values.
     */
    public var category: String

    /**
     The normalized percentile score for the characteristic. The range is 0 to 1. For example, if the percentage for
     Openness is 0.60, the author scored in the 60th percentile; the author is more open than 59 percent of the
     population and less open than 39 percent of the population.
     */
    public var percentile: Double

    /**
     The raw score for the characteristic. The range is 0 to 1. A higher score generally indicates a greater likelihood
     that the author has that characteristic, but raw scores must be considered in aggregate: The range of values in
     practice might be much smaller than 0 to 1, so an individual score must be considered in the context of the overall
     scores and their range.
     The raw score is computed based on the input and the service model; it is not normalized or compared with a sample
     population. The raw score enables comparison of the results against a different sampling population and with a
     custom normalization approach.
     */
    public var rawScore: Double?

    /**
     **`2017-10-13`**: Indicates whether the characteristic is meaningful for the input language. The field is always
     `true` for all characteristics of English, Spanish, and Japanese input. The field is `false` for the subset of
     characteristics of Arabic and Korean input for which the service's models are unable to generate meaningful
     results. **`2016-10-19`**: Not returned.
     */
    public var significant: Bool?

    /**
     For `personality` (Big Five) dimensions, more detailed results for the facets of each dimension as inferred from
     the input text.
     */
    public var children: [Trait]?

    // Map each property name to the key that shall be used for encoding/decoding.
    private enum CodingKeys: String, CodingKey {
        case traitID = "trait_id"
        case name = "name"
        case category = "category"
        case percentile = "percentile"
        case rawScore = "raw_score"
        case significant = "significant"
        case children = "children"
    }

}
