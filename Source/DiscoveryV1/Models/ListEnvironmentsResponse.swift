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

/** ListEnvironmentsResponse. */
public struct ListEnvironmentsResponse {

    /// An array of [environments] that are available for the service instance.
    public var environments: [Environment]?

    /**
     Initialize a `ListEnvironmentsResponse` with member variables.

     - parameter environments: An array of [environments] that are available for the service instance.

     - returns: An initialized `ListEnvironmentsResponse`.
    */
    public init(environments: [Environment]? = nil) {
        self.environments = environments
    }
}

extension ListEnvironmentsResponse: Codable {

    private enum CodingKeys: String, CodingKey {
        case environments = "environments"
        static let allValues = [environments]
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        environments = try container.decodeIfPresent([Environment].self, forKey: .environments)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(environments, forKey: .environments)
    }

}
