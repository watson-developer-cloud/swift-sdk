/**
 * (C) Copyright IBM Corp. 2018, 2020.
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
 A term from the request that was identified as an entity.
 */
public struct RuntimeEntity: Codable, Equatable {

    /**
     An entity detected in the input.
     */
    public var entity: String

    /**
     An array of zero-based character offsets that indicate where the detected entity values begin and end in the input
     text.
     */
    public var location: [Int]

    /**
     The entity value that was recognized in the user input.
     */
    public var value: String

    /**
     A decimal percentage that represents Watson's confidence in the recognized entity.
     */
    public var confidence: Double?

    /**
     Any metadata for the entity.
     */
    public var metadata: [String: JSON]?

    /**
     The recognized capture groups for the entity, as defined by the entity pattern.
     */
    public var groups: [CaptureGroup]?

    /**
     An object containing detailed information about the entity recognized in the user input. This property is included
     only if the new system entities are enabled for the workspace.
     For more information about how the new system entities are interpreted, see the
     [documentation](https://cloud.ibm.com/docs/assistant?topic=assistant-beta-system-entities).
     */
    public var interpretation: RuntimeEntityInterpretation?

    /**
     An array of possible alternative values that the user might have intended instead of the value returned in the
     **value** property. This property is returned only for `@sys-time` and `@sys-date` entities when the user's input
     is ambiguous.
     This property is included only if the new system entities are enabled for the workspace.
     */
    public var alternatives: [RuntimeEntityAlternative]?

    /**
     An object describing the role played by a system entity that is specifies the beginning or end of a range
     recognized in the user input. This property is included only if the new system entities are enabled for the
     workspace.
     */
    public var role: RuntimeEntityRole?

    // Map each property name to the key that shall be used for encoding/decoding.
    private enum CodingKeys: String, CodingKey {
        case entity = "entity"
        case location = "location"
        case value = "value"
        case confidence = "confidence"
        case metadata = "metadata"
        case groups = "groups"
        case interpretation = "interpretation"
        case alternatives = "alternatives"
        case role = "role"
    }

    /**
      Initialize a `RuntimeEntity` with member variables.

      - parameter entity: An entity detected in the input.
      - parameter location: An array of zero-based character offsets that indicate where the detected entity values
        begin and end in the input text.
      - parameter value: The entity value that was recognized in the user input.
      - parameter confidence: A decimal percentage that represents Watson's confidence in the recognized entity.
      - parameter metadata: Any metadata for the entity.
      - parameter groups: The recognized capture groups for the entity, as defined by the entity pattern.
      - parameter interpretation: An object containing detailed information about the entity recognized in the user
        input. This property is included only if the new system entities are enabled for the workspace.
        For more information about how the new system entities are interpreted, see the
        [documentation](https://cloud.ibm.com/docs/assistant?topic=assistant-beta-system-entities).
      - parameter alternatives: An array of possible alternative values that the user might have intended instead of
        the value returned in the **value** property. This property is returned only for `@sys-time` and `@sys-date`
        entities when the user's input is ambiguous.
        This property is included only if the new system entities are enabled for the workspace.
      - parameter role: An object describing the role played by a system entity that is specifies the beginning or end
        of a range recognized in the user input. This property is included only if the new system entities are enabled
        for the workspace.

      - returns: An initialized `RuntimeEntity`.
     */
    public init(
        entity: String,
        location: [Int],
        value: String,
        confidence: Double? = nil,
        metadata: [String: JSON]? = nil,
        groups: [CaptureGroup]? = nil,
        interpretation: RuntimeEntityInterpretation? = nil,
        alternatives: [RuntimeEntityAlternative]? = nil,
        role: RuntimeEntityRole? = nil
    )
    {
        self.entity = entity
        self.location = location
        self.value = value
        self.confidence = confidence
        self.metadata = metadata
        self.groups = groups
        self.interpretation = interpretation
        self.alternatives = alternatives
        self.role = role
    }

}
