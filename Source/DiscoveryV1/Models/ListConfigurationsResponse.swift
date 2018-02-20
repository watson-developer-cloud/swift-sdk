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

/** ListConfigurationsResponse. */
public struct ListConfigurationsResponse {

    /// An array of Configurations that are available for the service instance.
    public var configurations: [Configuration]?

    /**
     Initialize a `ListConfigurationsResponse` with member variables.

     - parameter configurations: An array of Configurations that are available for the service instance.

     - returns: An initialized `ListConfigurationsResponse`.
    */
    public init(configurations: [Configuration]? = nil) {
        self.configurations = configurations
    }
}

extension ListConfigurationsResponse: Codable {

    private enum CodingKeys: String, CodingKey {
        case configurations = "configurations"
        static let allValues = [configurations]
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        configurations = try container.decodeIfPresent([Configuration].self, forKey: .configurations)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(configurations, forKey: .configurations)
    }

}
