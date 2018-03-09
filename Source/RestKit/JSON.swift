/**
 * Copyright IBM Corporation 2016-2017
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

/// A JSON value (one of string, number, object, array, true, false, or null).
public enum JSON: Equatable, Codable {

    /// A null value.
    case null

    /// A boolean value.
    case boolean(Bool)

    /// A string value.
    case string(String)

    /// A number value, represented as an integer.
    case int(Int)

    /// A number value, represented as a double.
    case double(Double)

    /// An array value.
    case array([JSON])

    /// An object value.
    case object([String: JSON])

    /// Decode a JSON value.
    public init(from decoder: Decoder) throws {
        if let container = try? decoder.container(keyedBy: DynamicKeys.self) {
            try self.init(from: container)
        } else if var container = try? decoder.unkeyedContainer() {
            try self.init(from: &container)
        } else if let container = try? decoder.singleValueContainer() {
            try self.init(from: container)
        } else {
            let description = "Failed to construct a container view into this decoder."
            let context = DecodingError.Context(codingPath: decoder.codingPath, debugDescription: description)
            throw DecodingError.dataCorrupted(context)
        }
    }

    /// Decode a JSON object value from the keyed container.
    private init(from container: KeyedDecodingContainer<DynamicKeys>) throws {
        try self.init(from: container, excluding: [])
    }

    /// Decode a JSON object value from the keyed container, excluding the given keys.
    internal init(from container: KeyedDecodingContainer<DynamicKeys>, excluding keys: [CodingKey]) throws {
        var object = [String: JSON]()
        let excludedKeys = keys.map { $0.stringValue }
        let includedKeys = container.allKeys.filter { !excludedKeys.contains($0.stringValue) }
        for codingKey in includedKeys {
            let key = codingKey.stringValue
            let value = try container.decode(JSON.self, forKey: codingKey)
            object[key] = value
        }
        self = .object(object)
    }

    /// Decode a JSON array value from the unkeyed container.
    private init(from container: inout UnkeyedDecodingContainer) throws {
        var array = [JSON]()
        while !container.isAtEnd {
            array.append(try container.decode(JSON.self))
        }
        self = .array(array)
    }

    /// Decode a JSON value from the single value container.
    private init(from container: SingleValueDecodingContainer) throws {
        // swiftlint:disable statement_position
        if container.decodeNil() { self = .null }
        else if let boolean = try? container.decode(Bool.self) { self = .boolean(boolean) }
        else if let string = try? container.decode(String.self) { self = .string(string) }
        else if let int = try? container.decode(Int.self) { self = .int(int) }
        else if let double = try? container.decode(Double.self) { self = .double(double) }
        // swiftlint:enable statement_position
        else {
            let description = "Failed to decode a JSON value from the given single value container."
            let context = DecodingError.Context(codingPath: container.codingPath, debugDescription: description)
            throw DecodingError.dataCorrupted(context)
        }
    }

    /// Initialize a JSON value from an encodable type.
    public init<T: Encodable>(from value: T) throws {
        let encoder = JSONEncoder()
        let decoder = JSONDecoder()
        let data = try encoder.encode(value)
        self = try decoder.decode(JSON.self, from: data)
    }

    /// Convert this JSON value to a decodable type.
    public func toValue<T: Decodable>(_ type: T.Type) throws -> T {
        let encoder = JSONEncoder()
        let decoder = JSONDecoder()
        let data = try encoder.encode(self)
        return try decoder.decode(T.self, from: data)
    }

    /// Encode a JSON value.
    public func encode(to encoder: Encoder) throws {
        switch self {
        case .null:
            var container = encoder.singleValueContainer()
            try container.encodeNil()
        case .boolean(let boolean):
            var container = encoder.singleValueContainer()
            try container.encode(boolean)
        case .string(let string):
            var container = encoder.singleValueContainer()
            try container.encode(string)
        case .int(let int):
            var container = encoder.singleValueContainer()
            try container.encode(int)
        case .double(let double):
            var container = encoder.singleValueContainer()
            try container.encode(double)
        case .array(let array):
            var container = encoder.unkeyedContainer()
            try array.forEach { try container.encode($0) }
        case .object(let object):
            var container = encoder.container(keyedBy: DynamicKeys.self)
            try object.forEach { key, value in
                guard let codingKey = DynamicKeys(stringValue: key) else {
                    let description = "Cannot construct CodingKey for \(key)"
                    let context = EncodingError.Context(codingPath: encoder.codingPath, debugDescription: description)
                    throw EncodingError.invalidValue(key, context)
                }
                try container.encode(value, forKey: codingKey)
            }
        }
    }

    /// Compare two JSON values for equality.
    public static func == (lhs: JSON, rhs: JSON) -> Bool {
        switch (lhs, rhs) {
        case (.null, null): return true
        case (.boolean(let x), .boolean(let y)): return x == y
        case (.string(let x), .string(let y)): return x == y
        case (.int(let x), .int(let y)): return x == y
        case (.double(let x), .double(let y)): return x == y
        case (.array(let x), .array(let y)): return x == y
        case (.object(let x), .object(let y)): return x == y
        default: return false
        }
    }
}
