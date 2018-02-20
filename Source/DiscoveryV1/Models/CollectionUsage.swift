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

/** Summary of the collection usage in the environment. */
public struct CollectionUsage {

    /// Number of active collections in the environment.
    public var available: Int?

    /// Total number of collections allowed in the environment.
    public var maximumAllowed: Int?

    /**
     Initialize a `CollectionUsage` with member variables.

     - parameter available: Number of active collections in the environment.
     - parameter maximumAllowed: Total number of collections allowed in the environment.

     - returns: An initialized `CollectionUsage`.
    */
    public init(available: Int? = nil, maximumAllowed: Int? = nil) {
        self.available = available
        self.maximumAllowed = maximumAllowed
    }
}

extension CollectionUsage: Codable {

    private enum CodingKeys: String, CodingKey {
        case available = "available"
        case maximumAllowed = "maximum_allowed"
        static let allValues = [available, maximumAllowed]
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        available = try container.decodeIfPresent(Int.self, forKey: .available)
        maximumAllowed = try container.decodeIfPresent(Int.self, forKey: .maximumAllowed)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(available, forKey: .available)
        try container.encodeIfPresent(maximumAllowed, forKey: .maximumAllowed)
    }

}
