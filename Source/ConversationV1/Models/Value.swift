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

/** Value. */
public struct Value {

    /// Specifies the type of value.
    public enum ValueType: String {
        case synonyms = "synonyms"
        case patterns = "patterns"
    }

    /// The text of the entity value.
    public var valueText: String

    /// Any metadata related to the entity value.
    public var metadata: [String: JSON]?

    /// The timestamp for creation of the entity value.
    public var created: String?

    /// The timestamp for the last update to the entity value.
    public var updated: String?

    /// An array containing any synonyms for the entity value.
    public var synonyms: [String]?

    /// An array containing any patterns for the entity value.
    public var patterns: [String]?

    /// Specifies the type of value.
    public var valueType: String

    /**
     Initialize a `Value` with member variables.

     - parameter valueText: The text of the entity value.
     - parameter valueType: Specifies the type of value.
     - parameter metadata: Any metadata related to the entity value.
     - parameter created: The timestamp for creation of the entity value.
     - parameter updated: The timestamp for the last update to the entity value.
     - parameter synonyms: An array containing any synonyms for the entity value.
     - parameter patterns: An array containing any patterns for the entity value.

     - returns: An initialized `Value`.
    */
    public init(valueText: String, valueType: String, metadata: [String: JSON]? = nil, created: String? = nil, updated: String? = nil, synonyms: [String]? = nil, patterns: [String]? = nil) {
        self.valueText = valueText
        self.valueType = valueType
        self.metadata = metadata
        self.created = created
        self.updated = updated
        self.synonyms = synonyms
        self.patterns = patterns
    }
}

extension Value: Codable {

    private enum CodingKeys: String, CodingKey {
        case valueText = "value"
        case metadata = "metadata"
        case created = "created"
        case updated = "updated"
        case synonyms = "synonyms"
        case patterns = "patterns"
        case valueType = "type"
        static let allValues = [valueText, metadata, created, updated, synonyms, patterns, valueType]
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        valueText = try container.decode(String.self, forKey: .valueText)
        metadata = try container.decodeIfPresent([String: JSON].self, forKey: .metadata)
        created = try container.decodeIfPresent(String.self, forKey: .created)
        updated = try container.decodeIfPresent(String.self, forKey: .updated)
        synonyms = try container.decodeIfPresent([String].self, forKey: .synonyms)
        patterns = try container.decodeIfPresent([String].self, forKey: .patterns)
        valueType = try container.decode(String.self, forKey: .valueType)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(valueText, forKey: .valueText)
        try container.encodeIfPresent(metadata, forKey: .metadata)
        try container.encodeIfPresent(created, forKey: .created)
        try container.encodeIfPresent(updated, forKey: .updated)
        try container.encodeIfPresent(synonyms, forKey: .synonyms)
        try container.encodeIfPresent(patterns, forKey: .patterns)
        try container.encode(valueType, forKey: .valueType)
    }

}
