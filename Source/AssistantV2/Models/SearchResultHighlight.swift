/**
 * (C) Copyright IBM Corp. 2019.
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
 An object containing segments of text from search results with query-matching text highlighted using HTML <em> tags.
 */
public struct SearchResultHighlight: Codable, Equatable {

    /**
     An array of strings containing segments taken from body text in the search results, with query-matching substrings
     highlighted.
     */
    public var body: [String]?

    /**
     An array of strings containing segments taken from title text in the search results, with query-matching substrings
     highlighted.
     */
    public var title: [String]?

    /**
     An array of strings containing segments taken from URLs in the search results, with query-matching substrings
     highlighted.
     */
    public var url: [String]?

    /// Additional properties associated with this model.
    public var additionalProperties: [String: [String]]

    // Map each property name to the key that shall be used for encoding/decoding.
    private enum CodingKeys: String, CodingKey {
        case body = "body"
        case title = "title"
        case url = "url"
        static let allValues = [body, title, url]
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        body = try container.decodeIfPresent([String].self, forKey: .body)
        title = try container.decodeIfPresent([String].self, forKey: .title)
        url = try container.decodeIfPresent([String].self, forKey: .url)
        let dynamicContainer = try decoder.container(keyedBy: DynamicKeys.self)
        additionalProperties = try dynamicContainer.decode([String: [String]].self, excluding: CodingKeys.allValues)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(body, forKey: .body)
        try container.encodeIfPresent(title, forKey: .title)
        try container.encodeIfPresent(url, forKey: .url)
        var dynamicContainer = encoder.container(keyedBy: DynamicKeys.self)
        try dynamicContainer.encodeIfPresent(additionalProperties)
    }
}

public extension KeyedDecodingContainer where Key == DynamicKeys {

    /// Decode additional properties.
    func decode(_ type: [String: [String]].Type, excluding keys: [CodingKey]) throws -> [String: [String]] {
        var retval: [String: [String]] = [:]
        try self.allKeys.forEach { key in
            if !keys.contains{ $0.stringValue == key.stringValue} {
                let value = try self.decode([String].self, forKey: key)
                retval[key.stringValue] = value
            }
        }
        return retval
    }
}

public extension KeyedEncodingContainer where Key == DynamicKeys {

    /// Encode additional properties.
    mutating func encode(_ additionalProperties: [String: [String]]) throws {
        try additionalProperties.forEach { key, value in
            guard let codingKey = DynamicKeys(stringValue: key) else {
                let description = "Cannot construct CodingKey for \(key)"
                let context = EncodingError.Context(codingPath: codingPath, debugDescription: description)
                throw EncodingError.invalidValue(key, context)
            }
            try self.encode(value, forKey: codingKey)
        }
    }

    /// Encode additional properties if they are not nil.
    mutating func encodeIfPresent(_ additionalProperties: [String: [String]]?) throws {
        guard let additionalProperties = additionalProperties else { return }
        try encode(additionalProperties)
    }
}
