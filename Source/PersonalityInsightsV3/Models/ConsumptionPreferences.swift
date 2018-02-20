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

/** ConsumptionPreferences. */
public struct ConsumptionPreferences {

    /// The unique identifier of the consumption preference to which the results pertain. IDs have the form `consumption_preferences_{preference}`.
    public var consumptionPreferenceID: String

    /// The user-visible name of the consumption preference.
    public var name: String

    /// The score for the consumption preference: * `0.0`: Unlikely * `0.5`: Neutral * `1.0`: Likely   The scores for some preferences are binary and do not allow a neutral value. The score is an indication of preference based on the results inferred from the input text, not a normalized percentile.
    public var score: Double

    /**
     Initialize a `ConsumptionPreferences` with member variables.

     - parameter consumptionPreferenceID: The unique identifier of the consumption preference to which the results pertain. IDs have the form `consumption_preferences_{preference}`.
     - parameter name: The user-visible name of the consumption preference.
     - parameter score: The score for the consumption preference: * `0.0`: Unlikely * `0.5`: Neutral * `1.0`: Likely   The scores for some preferences are binary and do not allow a neutral value. The score is an indication of preference based on the results inferred from the input text, not a normalized percentile.

     - returns: An initialized `ConsumptionPreferences`.
    */
    public init(consumptionPreferenceID: String, name: String, score: Double) {
        self.consumptionPreferenceID = consumptionPreferenceID
        self.name = name
        self.score = score
    }
}

extension ConsumptionPreferences: Codable {

    private enum CodingKeys: String, CodingKey {
        case consumptionPreferenceID = "consumption_preference_id"
        case name = "name"
        case score = "score"
        static let allValues = [consumptionPreferenceID, name, score]
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        consumptionPreferenceID = try container.decode(String.self, forKey: .consumptionPreferenceID)
        name = try container.decode(String.self, forKey: .name)
        score = try container.decode(Double.self, forKey: .score)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(consumptionPreferenceID, forKey: .consumptionPreferenceID)
        try container.encode(name, forKey: .name)
        try container.encode(score, forKey: .score)
    }

}
