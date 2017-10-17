/**
 * Copyright IBM Corporation 2017
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
public struct CreateValue {

    /// Specifies the type of value (`synonyms` or `patterns`). The default value is `synonyms`.
    public enum ValueType: String {
        case synonyms = "synonyms"
        case patterns = "patterns"
    }

    /// The text of the entity value.
    public var value: String

    /// Any metadata related to the entity value.
    public var metadata: [String: JSON]?

    /// An array of synonyms for the entity value.
    public var synonyms: [String]?

    /// An array of patterns for the entity value. A pattern is specified as a regular expression.
    public var patterns: [String]?

    /// Specifies the type of value (`synonyms` or `patterns`). The default value is `synonyms`.
    public var valueType: String?

    /**
     Initialize a `CreateValue` with member variables.

     - parameter value: The text of the entity value.
     - parameter metadata: Any metadata related to the entity value.
     - parameter synonyms: An array of synonyms for the entity value.
     - parameter patterns: An array of patterns for the entity value. A pattern is specified as a regular expression.
     - parameter valueType: Specifies the type of value (`synonyms` or `patterns`). The default value is `synonyms`.

     - returns: An initialized `CreateValue`.
    */
    public init(value: String, metadata: [String: JSON]? = nil, synonyms: [String]? = nil, patterns: [String]? = nil, valueType: String? = nil) {
        self.value = value
        self.metadata = metadata
        self.synonyms = synonyms
        self.patterns = patterns
        self.valueType = valueType
    }
}

extension CreateValue: Codable {

    private enum CodingKeys: String, CodingKey {
        case value = "value"
        case metadata = "metadata"
        case synonyms = "synonyms"
        case patterns = "patterns"
        case valueType = "type"
        static let allValues = [value, metadata, synonyms, patterns, valueType]
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        value = try container.decode(String.self, forKey: .value)
        metadata = try container.decodeIfPresent([String: JSON].self, forKey: .metadata)
        synonyms = try container.decodeIfPresent([String].self, forKey: .synonyms)
        patterns = try container.decodeIfPresent([String].self, forKey: .patterns)
        valueType = try container.decodeIfPresent(String.self, forKey: .valueType)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(value, forKey: .value)
        try container.encodeIfPresent(metadata, forKey: .metadata)
        try container.encodeIfPresent(synonyms, forKey: .synonyms)
        try container.encodeIfPresent(patterns, forKey: .patterns)
        try container.encodeIfPresent(valueType, forKey: .valueType)
    }

}
