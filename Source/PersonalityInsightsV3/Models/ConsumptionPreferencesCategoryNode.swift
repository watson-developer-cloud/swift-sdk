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

/** Detailed results for each category of consumption preferences. */
public struct ConsumptionPreferencesCategoryNode: JSONDecodable {
    
    /// The globally unique id of a consumption preferences category.
    public let consumptionPreferenceCategoryId: String
    
    /// The user-displayable name of the category.
    public let name: String
    
    /// Array of consumption preferences node objects that contains results
    /// for individual preferences of the category inferred from the input text.
    public let consumptionPreferences: [ConsumptionPreferencesNode]
    
    /// Used internally to initialize a `ConsumptionPreferencesCategoryNode` model from JSON.
    public init(json: JSON) throws {
        consumptionPreferenceCategoryId = try json.getString(at: "consumption_preference_category_id")
        name = try json.getString(at: "name")
        consumptionPreferences = try json.decodedArray(at: "consumption_preferences")
    }
}
