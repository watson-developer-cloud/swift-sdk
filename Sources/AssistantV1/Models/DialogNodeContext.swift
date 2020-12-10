/**
 * (C) Copyright IBM Corp. 2020.
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
import IBMSwiftSDKCore

/**
 The context for the dialog node.
 */
public struct DialogNodeContext: Codable, Equatable {

    /**
     Context data intended for specific integrations.
     */
    public var integrations: [String: [String: JSON]]?

    /// Additional properties associated with this model.
    public var additionalProperties: [String: JSON]

    // Map each property name to the key that shall be used for encoding/decoding.
    private enum CodingKeys: String, CodingKey {
        case integrations = "integrations"
        static let allValues = [integrations]
    }

    /**
      Initialize a `DialogNodeContext` with member variables.

      - parameter integrations: Context data intended for specific integrations.

      - returns: An initialized `DialogNodeContext`.
     */
    public init(
        integrations: [String: [String: JSON]]? = nil,
        additionalProperties: [String: JSON] = [:]
    )
    {
        self.integrations = integrations
        self.additionalProperties = additionalProperties
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        integrations = try container.decodeIfPresent([String: [String: JSON]].self, forKey: .integrations)
        let dynamicContainer = try decoder.container(keyedBy: DynamicKeys.self)
        additionalProperties = try dynamicContainer.decode([String: JSON].self, excluding: CodingKeys.allValues)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(integrations, forKey: .integrations)
        var dynamicContainer = encoder.container(keyedBy: DynamicKeys.self)
        try dynamicContainer.encodeIfPresent(additionalProperties)
    }

}
