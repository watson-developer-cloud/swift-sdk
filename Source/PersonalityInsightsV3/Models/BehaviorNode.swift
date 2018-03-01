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

/** Detailed results of content distribution over every weekday and hour of
    each day. */
public struct BehaviorNode: JSONDecodable {

    /// The globally unique id of the characteristic that pertains to behavior
    /// day and hour.
    public let traitID: String

    /// The user-displayable name of the characteristic.
    public let name: String

    /// The category of the characteristic which will always be behavior.
    public let category: String

    /// The percentage of content items that occurred during that day of the
    /// week or hour of the day. For example, the behavioral characteristic
    /// behavior_0000 with a percentage of 0.456 indicates about 46% of content
    /// items were created between midnight and 1:00 AM.
    public let percentage: Double

    /// Used internally to initialize a `BehaviorNode` model from JSON.
    public init(json: JSONWrapper) throws {
        traitID = try json.getString(at: "trait_id")
        name = try json.getString(at: "name")
        category = try json.getString(at: "category")
        percentage = try json.getDouble(at: "percentage")
    }
}
