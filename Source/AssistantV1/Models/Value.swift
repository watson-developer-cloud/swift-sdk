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

/** Value. */
public struct Value: Codable, Equatable {

    /**
     Specifies the type of value.
     */
    public enum ValueType: String {
        case synonyms = "synonyms"
        case patterns = "patterns"
    }

    /**
     The text of the entity value.
     */
    public var valueText: String

    /**
     Any metadata related to the entity value.
     */
    public var metadata: [String: JSON]?

    /**
     The timestamp for creation of the entity value.
     */
    public var created: Date?

    /**
     The timestamp for the last update to the entity value.
     */
    public var updated: Date?

    /**
     An array containing any synonyms for the entity value.
     */
    public var synonyms: [String]?

    /**
     An array containing any patterns for the entity value.
     */
    public var patterns: [String]?

    /**
     Specifies the type of value.
     */
    public var valueType: String

    // Map each property name to the key that shall be used for encoding/decoding.
    private enum CodingKeys: String, CodingKey {
        case valueText = "value"
        case metadata = "metadata"
        case created = "created"
        case updated = "updated"
        case synonyms = "synonyms"
        case patterns = "patterns"
        case valueType = "type"
    }

}
