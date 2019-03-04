/**
 * Copyright IBM Corporation 2019
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

/**
 Information specific to particular skills used by the Assistant.
 **Note:** Currently, only a single property named `main skill` is supported. This object contains variables that apply
 to the dialog skill used by the assistant.
 */
public struct MessageContextSkills: Codable, Equatable {

    /// Additional properties associated with this model.
    public var additionalProperties: [String: JSON]

    /**
     Initialize a `MessageContextSkills`.

     - returns: An initialized `MessageContextSkills`.
    */
    public init(
        additionalProperties: [String: JSON] = [:]
    )
    {
        self.additionalProperties = additionalProperties
    }

    public init(from decoder: Decoder) throws {
        let dynamicContainer = try decoder.container(keyedBy: DynamicKeys.self)
        additionalProperties = try dynamicContainer.decode([String: JSON].self, excluding: [CodingKey]())
    }

    public func encode(to encoder: Encoder) throws {
        var dynamicContainer = encoder.container(keyedBy: DynamicKeys.self)
        try dynamicContainer.encodeIfPresent(additionalProperties)
    }

}
