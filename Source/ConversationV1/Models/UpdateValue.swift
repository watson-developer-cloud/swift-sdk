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

/** UpdateValue. */
public struct UpdateValue {

    /// Specifies the type of value (`synonyms` or `patterns`). The default value is `synonyms`.
    public enum ValueType: String {
        case synonyms = "synonyms"
        case patterns = "patterns"
    }

    /// The text of the entity value.
    public var value: String?

    /// Any metadata related to the entity value.
    public var metadata: [String: JSON]?

    /// Specifies the type of value (`synonyms` or `patterns`). The default value is `synonyms`.
    public var valueType: String?

    /// An array of synonyms for the entity value.
    public var synonyms: [String]?

    /// An array of patterns for the entity value. A pattern is specified as a regular expression.
    public var patterns: [String]?

    /**
     Initialize a `UpdateValue` with member variables.

     - parameter value: The text of the entity value.
     - parameter metadata: Any metadata related to the entity value.
     - parameter valueType: Specifies the type of value (`synonyms` or `patterns`). The default value is `synonyms`.
     - parameter synonyms: An array of synonyms for the entity value.
     - parameter patterns: An array of patterns for the entity value. A pattern is specified as a regular expression.

     - returns: An initialized `UpdateValue`.
    */
    public init(value: String? = nil, metadata: [String: JSON]? = nil, valueType: String? = nil, synonyms: [String]? = nil, patterns: [String]? = nil) {
        self.value = value
        self.metadata = metadata
        self.valueType = valueType
        self.synonyms = synonyms
        self.patterns = patterns
    }
}

extension UpdateValue: Codable {

    private enum CodingKeys: String, CodingKey {
        case value = "value"
        case metadata = "metadata"
        case valueType = "type"
        case synonyms = "synonyms"
        case patterns = "patterns"
        static let allValues = [value, metadata, valueType, synonyms, patterns]
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        value = try container.decodeIfPresent(String.self, forKey: .value)
        metadata = try container.decodeIfPresent([String: JSON].self, forKey: .metadata)
        valueType = try container.decodeIfPresent(String.self, forKey: .valueType)
        synonyms = try container.decodeIfPresent([String].self, forKey: .synonyms)
        patterns = try container.decodeIfPresent([String].self, forKey: .patterns)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(value, forKey: .value)
        try container.encodeIfPresent(metadata, forKey: .metadata)
        try container.encodeIfPresent(valueType, forKey: .valueType)
        try container.encodeIfPresent(synonyms, forKey: .synonyms)
        try container.encodeIfPresent(patterns, forKey: .patterns)
    }

}
