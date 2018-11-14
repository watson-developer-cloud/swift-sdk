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
import RestKit

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
     The term in the input text that was recognized as an entity value.
     */
    public var value: String

    /**
     A decimal percentage that represents Watson's confidence in the entity.
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

    // Map each property name to the key that shall be used for encoding/decoding.
    private enum CodingKeys: String, CodingKey {
        case entity = "entity"
        case location = "location"
        case value = "value"
        case confidence = "confidence"
        case metadata = "metadata"
        case groups = "groups"
    }

    /**
     Initialize a `RuntimeEntity` with member variables.

     - parameter entity: An entity detected in the input.
     - parameter location: An array of zero-based character offsets that indicate where the detected entity values
       begin and end in the input text.
     - parameter value: The term in the input text that was recognized as an entity value.
     - parameter confidence: A decimal percentage that represents Watson's confidence in the entity.
     - parameter metadata: Any metadata for the entity.
     - parameter groups: The recognized capture groups for the entity, as defined by the entity pattern.

     - returns: An initialized `RuntimeEntity`.
    */
    public init(
        entity: String,
        location: [Int],
        value: String,
        confidence: Double? = nil,
        metadata: [String: JSON]? = nil,
        groups: [CaptureGroup]? = nil
    )
    {
        self.entity = entity
        self.location = location
        self.value = value
        self.confidence = confidence
        self.metadata = metadata
        self.groups = groups
    }

}
