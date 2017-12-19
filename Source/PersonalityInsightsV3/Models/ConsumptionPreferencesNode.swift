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

/** Provides every individual preference for a category. */
public struct ConsumptionPreferencesNode: JSONDecodable {

    /// The globally unique id of the consumption preference.
    public let consumptionPreferenceId: String

    /// The user-displayable name of the consumption preference.
    public let name: String

    /// The score indicating the author's likelihood of preferring
    /// the item. For example, if the score is 0.0, preference is
    /// unlikely; if the score is 0.5, preference is neutral; if the score
    /// is 1.0, the author would likely prefer the item.
    public let score: Double

    /// Used internally to initialize a `ConsumptionPreferencesNode` model from JSON.
    public init(json: JSONWrapper) throws {
        consumptionPreferenceId = try json.getString(at: "consumption_preference_id")
        name = try json.getString(at: "name")
        score = try json.getDouble(at: "score")
    }
}
