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

/** ConsumptionPreferencesCategory. */
public struct ConsumptionPreferencesCategory {

    /// The unique identifier of the consumption preferences category to which the results pertain. IDs have the form `consumption_preferences_{category}`.
    public var consumptionPreferenceCategoryID: String

    /// The user-visible name of the consumption preferences category.
    public var name: String

    /// Detailed results inferred from the input text for the individual preferences of the category.
    public var consumptionPreferences: [ConsumptionPreferences]

    /**
     Initialize a `ConsumptionPreferencesCategory` with member variables.

     - parameter consumptionPreferenceCategoryID: The unique identifier of the consumption preferences category to which the results pertain. IDs have the form `consumption_preferences_{category}`.
     - parameter name: The user-visible name of the consumption preferences category.
     - parameter consumptionPreferences: Detailed results inferred from the input text for the individual preferences of the category.

     - returns: An initialized `ConsumptionPreferencesCategory`.
    */
    public init(consumptionPreferenceCategoryID: String, name: String, consumptionPreferences: [ConsumptionPreferences]) {
        self.consumptionPreferenceCategoryID = consumptionPreferenceCategoryID
        self.name = name
        self.consumptionPreferences = consumptionPreferences
    }
}

extension ConsumptionPreferencesCategory: Codable {

    private enum CodingKeys: String, CodingKey {
        case consumptionPreferenceCategoryID = "consumption_preference_category_id"
        case name = "name"
        case consumptionPreferences = "consumption_preferences"
        static let allValues = [consumptionPreferenceCategoryID, name, consumptionPreferences]
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        consumptionPreferenceCategoryID = try container.decode(String.self, forKey: .consumptionPreferenceCategoryID)
        name = try container.decode(String.self, forKey: .name)
        consumptionPreferences = try container.decode([ConsumptionPreferences].self, forKey: .consumptionPreferences)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(consumptionPreferenceCategoryID, forKey: .consumptionPreferenceCategoryID)
        try container.encode(name, forKey: .name)
        try container.encode(consumptionPreferences, forKey: .consumptionPreferences)
    }

}
