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

/** UpdateValue. */
internal struct UpdateValue: Codable, Equatable {

    /**
     Specifies the type of entity value.
     */
    public enum ValueType: String {
        case synonyms = "synonyms"
        case patterns = "patterns"
    }

    /**
     The text of the entity value. This string must conform to the following restrictions:
     - It cannot contain carriage return, newline, or tab characters.
     - It cannot consist of only whitespace characters.
     - It must be no longer than 64 characters.
     */
    public var value: String?

    /**
     Any metadata related to the entity value.
     */
    public var metadata: [String: JSON]?

    /**
     Specifies the type of entity value.
     */
    public var valueType: String?

    /**
     An array of synonyms for the entity value. A value can specify either synonyms or patterns (depending on the value
     type), but not both. A synonym must conform to the following resrictions:
     - It cannot contain carriage return, newline, or tab characters.
     - It cannot consist of only whitespace characters.
     - It must be no longer than 64 characters.
     */
    public var synonyms: [String]?

    /**
     An array of patterns for the entity value. A value can specify either synonyms or patterns (depending on the value
     type), but not both. A pattern is a regular expression no longer than 512 characters. For more information about
     how to specify a pattern, see the
     [documentation](https://cloud.ibm.com/docs/services/assistant/entities.html#entities-create-dictionary-based).
     */
    public var patterns: [String]?

    /**
     The timestamp for creation of the object.
     */
    public var created: Date?

    /**
     The timestamp for the most recent update to the object.
     */
    public var updated: Date?

    // Map each property name to the key that shall be used for encoding/decoding.
    private enum CodingKeys: String, CodingKey {
        case value = "value"
        case metadata = "metadata"
        case valueType = "type"
        case synonyms = "synonyms"
        case patterns = "patterns"
        case created = "created"
        case updated = "updated"
    }

    /**
     Initialize a `UpdateValue` with member variables.

     - parameter value: The text of the entity value. This string must conform to the following restrictions:
       - It cannot contain carriage return, newline, or tab characters.
       - It cannot consist of only whitespace characters.
       - It must be no longer than 64 characters.
     - parameter metadata: Any metadata related to the entity value.
     - parameter valueType: Specifies the type of entity value.
     - parameter synonyms: An array of synonyms for the entity value. A value can specify either synonyms or patterns
       (depending on the value type), but not both. A synonym must conform to the following resrictions:
       - It cannot contain carriage return, newline, or tab characters.
       - It cannot consist of only whitespace characters.
       - It must be no longer than 64 characters.
     - parameter patterns: An array of patterns for the entity value. A value can specify either synonyms or patterns
       (depending on the value type), but not both. A pattern is a regular expression no longer than 512 characters. For
       more information about how to specify a pattern, see the
       [documentation](https://cloud.ibm.com/docs/services/assistant/entities.html#entities-create-dictionary-based).
     - parameter created: The timestamp for creation of the object.
     - parameter updated: The timestamp for the most recent update to the object.

     - returns: An initialized `UpdateValue`.
    */
    public init(
        value: String? = nil,
        metadata: [String: JSON]? = nil,
        valueType: String? = nil,
        synonyms: [String]? = nil,
        patterns: [String]? = nil,
        created: Date? = nil,
        updated: Date? = nil
    )
    {
        self.value = value
        self.metadata = metadata
        self.valueType = valueType
        self.synonyms = synonyms
        self.patterns = patterns
        self.created = created
        self.updated = updated
    }

}
