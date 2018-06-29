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

/** CreateValue. */
public struct CreateValue: Encodable {

    /**
     Specifies the type of value.
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
    public var value: String

    /**
     Any metadata related to the entity value.
     */
    public var metadata: [String: JSON]?

    /**
     An array containing any synonyms for the entity value. You can provide either synonyms or patterns (as indicated by
     **type**), but not both. A synonym must conform to the following restrictions:
     - It cannot contain carriage return, newline, or tab characters.
     - It cannot consist of only whitespace characters.
     - It must be no longer than 64 characters.
     */
    public var synonyms: [String]?

    /**
     An array of patterns for the entity value. You can provide either synonyms or patterns (as indicated by **type**),
     but not both. A pattern is a regular expression no longer than 512 characters. For more information about how to
     specify a pattern, see the
     [documentation](https://console.bluemix.net/docs/services/conversation/entities.html#creating-entities).
     */
    public var patterns: [String]?

    /**
     Specifies the type of value.
     */
    public var valueType: String?

    // Map each property name to the key that shall be used for encoding/decoding.
    private enum CodingKeys: String, CodingKey {
        case value = "value"
        case metadata = "metadata"
        case synonyms = "synonyms"
        case patterns = "patterns"
        case valueType = "type"
    }

    /**
     Initialize a `CreateValue` with member variables.

     - parameter value: The text of the entity value. This string must conform to the following restrictions:
       - It cannot contain carriage return, newline, or tab characters.
       - It cannot consist of only whitespace characters.
       - It must be no longer than 64 characters.
     - parameter metadata: Any metadata related to the entity value.
     - parameter synonyms: An array containing any synonyms for the entity value. You can provide either synonyms or
       patterns (as indicated by **type**), but not both. A synonym must conform to the following restrictions:
       - It cannot contain carriage return, newline, or tab characters.
       - It cannot consist of only whitespace characters.
       - It must be no longer than 64 characters.
     - parameter patterns: An array of patterns for the entity value. You can provide either synonyms or patterns (as
       indicated by **type**), but not both. A pattern is a regular expression no longer than 512 characters. For more
       information about how to specify a pattern, see the
       [documentation](https://console.bluemix.net/docs/services/conversation/entities.html#creating-entities).
     - parameter valueType: Specifies the type of value.

     - returns: An initialized `CreateValue`.
    */
    public init(
        value: String,
        metadata: [String: JSON]? = nil,
        synonyms: [String]? = nil,
        patterns: [String]? = nil,
        valueType: String? = nil
    )
    {
        self.value = value
        self.metadata = metadata
        self.synonyms = synonyms
        self.patterns = patterns
        self.valueType = valueType
    }

}
