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

/** Behavior. */
public struct Behavior {

    /// The unique identifier of the characteristic to which the results pertain. IDs have the form `behavior_{value}`.
    public var traitID: String

    /// The user-visible name of the characteristic.
    public var name: String

    /// The category of the characteristic: `behavior` for temporal data.
    public var category: String

    /// For JSON content that is timestamped, the percentage of timestamped input data that occurred during that day of the week or hour of the day. The range is 0 to 1.
    public var percentage: Double

    /**
     Initialize a `Behavior` with member variables.

     - parameter traitID: The unique identifier of the characteristic to which the results pertain. IDs have the form `behavior_{value}`.
     - parameter name: The user-visible name of the characteristic.
     - parameter category: The category of the characteristic: `behavior` for temporal data.
     - parameter percentage: For JSON content that is timestamped, the percentage of timestamped input data that occurred during that day of the week or hour of the day. The range is 0 to 1.

     - returns: An initialized `Behavior`.
    */
    public init(traitID: String, name: String, category: String, percentage: Double) {
        self.traitID = traitID
        self.name = name
        self.category = category
        self.percentage = percentage
    }
}

extension Behavior: Codable {

    private enum CodingKeys: String, CodingKey {
        case traitID = "trait_id"
        case name = "name"
        case category = "category"
        case percentage = "percentage"
        static let allValues = [traitID, name, category, percentage]
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        traitID = try container.decode(String.self, forKey: .traitID)
        name = try container.decode(String.self, forKey: .name)
        category = try container.decode(String.self, forKey: .category)
        percentage = try container.decode(Double.self, forKey: .percentage)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(traitID, forKey: .traitID)
        try container.encode(name, forKey: .name)
        try container.encode(category, forKey: .category)
        try container.encode(percentage, forKey: .percentage)
    }

}
