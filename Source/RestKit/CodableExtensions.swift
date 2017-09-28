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

//===----------------------------------------------------------------------===//
// Extensions: JSONEncoder, JSONDecoder
//===----------------------------------------------------------------------===//

public extension JSONEncoder {
    
    /// Encode an optional object.
    public func encode(_ value: Encodable?) throws -> Data {
        guard let value = value else { return Data() }
        return try encode(value)
    }
    
    /// Encode a generic json object.
    public func encode(_ value: [String: Any]) throws -> Data {
        let wrapper = JSONObject(object: value)
        return try encode(wrapper)
    }
    
    /// Encode a generic json array.
    public func encode(_ value: [Any]) throws -> Data {
        let wrapper = JSONArray(array: value)
        return try encode(wrapper)
    }

}

public extension JSONDecoder {
    
    /// Decode a generic json object.
    public func decode(_ type: [String: Any].Type, from data: Data) throws -> [String: Any] {
        let wrapper = try decode(JSONObject.self, from: data)
        return wrapper.object
    }
    
    /// Decode a generic json array.
    public func decode(_ type: [Any].Type, from data: Data) throws -> [Any] {
        let wrapper = try decode(JSONArray.self, from: data)
        return wrapper.array
    }
    
}

//===----------------------------------------------------------------------===//
// Extensions: KeyedEncodingContainer, KeyedDecodingContainer
//===----------------------------------------------------------------------===//

public extension KeyedEncodingContainer {
    
    /// Encode a generic json object for the given key.
    public mutating func encode(_ value: [String: Any], forKey key: Key) throws {
        let wrapper = JSONObject(object: value)
        try encode(wrapper, forKey: key)
    }
    
    /// Encode a generic json object for the given key if it is not nil.
    public mutating func encodeIfPresent(_ value: [String: Any]?, forKey key: Key) throws {
        guard let value = value else { return }
        guard value.count > 0 else { return }
        try encode(value, forKey: key)
    }
    
}

public extension KeyedDecodingContainer {
    
    /// Decode a generic json object for the given key.
    public func decode(_ type: [String: Any].Type, forKey key: Key) throws -> [String: Any] {
        let wrapper = try decode(JSONObject.self, forKey: key)
        return wrapper.object
    }
    
    /// Decode a generic json object for the given key, if present and not empty.
    public func decodeIfPresent(_ type: [String: Any].Type, forKey key: Key) throws -> [String: Any]? {
        guard contains(key) else { return nil }
        guard let object = try? decode([String: Any].self, forKey: key) else { return nil }
        guard object.count > 0 else { return nil }
        return object
    }
    
}

//===----------------------------------------------------------------------===//
// Extensions: KeyedEncodingContainer<DynamicKey>, KeyedDecodingContainer<DynamicKey>
//===----------------------------------------------------------------------===//

public extension KeyedEncodingContainer where Key == DynamicKeys {
    
    /// Encode additional properties.
    public mutating func encode(_ additionalProperties: [String: Any]) throws {
        let wrapper = JSONObject(object: additionalProperties)
        try wrapper.encode(to: &self)
    }
    
    /// Encode additional properties if they are not nil or empty.
    public mutating func encodeIfPresent(_ additionalProperties: [String: Any]?) throws {
        guard let additionalProperties = additionalProperties else { return }
        guard additionalProperties.count > 0 else { return }
        try encode(additionalProperties)
    }
    
}

public extension KeyedDecodingContainer where Key == DynamicKeys {
    
    /// Decode additional properties.
    public func decode(_ type: [String: Any].Type, excluding keys: [CodingKey]) throws -> [String: Any] {
        let wrapper = try JSONObject(from: self)
        var object = wrapper.object
        let excludedKeys = keys.map() { $0.stringValue }
        for key in excludedKeys {
            object.removeValue(forKey: key)
        }
        return object
    }
    
    /// Decode additional properties, if present.
    public func decodeIfPresent(_ type: [String: Any].Type, excluding keys: [CodingKey]) throws -> [String: Any]? {
        let additionalProperties = try decode([String: Any].self, excluding: keys)
        guard additionalProperties.count > 0 else { return nil }
        return additionalProperties
    }
    
}

//===----------------------------------------------------------------------===//
// DynamicKeys
//===----------------------------------------------------------------------===//

/// A coding key to process dynamic objects,
/// whose keys are not known in advance.
public struct DynamicKeys: CodingKey {
    public let stringValue: String
    public let intValue: Int?
    public init?(stringValue: String) {
        self.stringValue = stringValue
        self.intValue = nil
    }
    public init?(intValue: Int) {
        self.stringValue = "Index \(intValue)"
        self.intValue = intValue
    }
}

//===----------------------------------------------------------------------===//
// JSON wrapper for objects
//===----------------------------------------------------------------------===//

/// A wrapper for a generic json object.
private struct JSONObject: Codable {
    
    /// The generic json object.
    let object: [String: Any]
    
    /// The path of coding keys taken to reach this object.
    let codingPath: [CodingKey]
    
    /// Wrap a generic json object.
    init(object: [String: Any], codingPath: [CodingKey] = []) {
        self.object = object
        self.codingPath = codingPath
    }
    
    /// Decode a generic json object.
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: DynamicKeys.self)
        try self.init(from: container)
    }
    
    /// Decode a generic json object.
    init(from container: KeyedDecodingContainer<DynamicKeys>) throws {
        var object = [String: Any]()
        for codingKey in container.allKeys {
            let key = codingKey.stringValue
            if let wrapper = try? container.decode(JSONValue.self, forKey: codingKey) { object[key] = wrapper.value }
            else if let wrapper = try? container.decode(JSONArray.self, forKey: codingKey) { object[key] = wrapper.array }
            else if let wrapper = try? container.decode(JSONObject.self, forKey: codingKey) { object[key] = wrapper.object }
            else {
                let codingPath = container.codingPath + [codingKey]
                let description = "Cannot initialize object value from invalid JSON with key \(key)"
                let context = DecodingError.Context(codingPath: codingPath, debugDescription: description)
                throw DecodingError.dataCorrupted(context)
            }
        }
        self.init(object: object, codingPath: container.codingPath)
    }
    
    /// Encode a generic json object.
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: DynamicKeys.self)
        try encode(to: &container)
    }
    
    /// Encode a generic json object.
    func encode(to container: inout KeyedEncodingContainer<DynamicKeys>) throws {
        for (key, value) in object {
            guard let codingKey = DynamicKeys(stringValue: key) else {
                let description = "Cannot construct CodingKey for \(key)"
                let context = EncodingError.Context(codingPath: container.codingPath, debugDescription: description)
                throw EncodingError.invalidValue(key, context)
            }
            let codingPath = container.codingPath + [codingKey]
            if let wrapper = try? JSONValue(value: value, codingPath: codingPath) {
                try container.encode(wrapper, forKey: codingKey)
            } else if let array = value as? [Any] {
                let wrapper = JSONArray(array: array, codingPath: codingPath)
                try container.encode(wrapper, forKey: codingKey)
            } else if let object = value as? [String: Any] {
                let wrapper = JSONObject(object: object, codingPath: codingPath)
                try container.encode(wrapper, forKey: codingKey)
            } else {
                let description = "Cannot encode invalid JSON value"
                let context = EncodingError.Context(codingPath: codingPath, debugDescription: description)
                throw EncodingError.invalidValue(value as Any, context)
            }
        }
    }
}

//===----------------------------------------------------------------------===//
// JSON wrapper for arrays
//===----------------------------------------------------------------------===//

/// A wrapper for a generic json array.
private struct JSONArray: Codable {
    
    /// The generic json array.
    let array: [Any]
    
    /// The path of coding keys taken to reach this array.
    let codingPath: [CodingKey]
    
    /// Wrap a generic json array.
    init(array: [Any], codingPath: [CodingKey] = []) {
        self.array = array
        self.codingPath = codingPath
    }
    
    /// Decode a generic json array.
    init(from decoder: Decoder) throws {
        var container = try decoder.unkeyedContainer()
        var array = [Any]()
        while (!container.isAtEnd) {
            if let wrapper = try? container.decode(JSONValue.self) { array.append(wrapper.value) }
            else if let wrapper = try? container.decode(JSONArray.self) { array.append(wrapper.array) }
            else if let wrapper = try? container.decode(JSONObject.self) { array.append(wrapper.object) }
            else {
                var codingPath = container.codingPath
                if let codingKey = DynamicKeys(intValue: container.currentIndex) { codingPath.append(codingKey) }
                let description = "Cannot initialize array element from invalid JSON"
                let context = DecodingError.Context(codingPath: codingPath, debugDescription: description)
                throw DecodingError.dataCorrupted(context)
            }
        }
        self.init(array: array, codingPath: container.codingPath)
    }

    /// Encode a generic json array.
    func encode(to encoder: Encoder) throws {
        var container = encoder.unkeyedContainer()
        for value in array {
            guard let codingKey = DynamicKeys(intValue: container.count) else {
                let description = "Cannot construct CodingKey for \(container.count)"
                let context = EncodingError.Context(codingPath: container.codingPath, debugDescription: description)
                throw EncodingError.invalidValue(container.count, context)
            }
            let codingPath = container.codingPath + [codingKey]
            if let wrapper = try? JSONValue(value: value, codingPath: codingPath) {
                try container.encode(wrapper)
            } else if let array = value as? [Any] {
                let wrapper = JSONArray(array: array, codingPath: codingPath)
                try container.encode(wrapper)
            } else if let object = value as? [String: Any] {
                let wrapper = JSONObject(object: object, codingPath: codingPath)
                try container.encode(wrapper)
            } else {
                let description = "Cannot encode invalid JSON value"
                let context = EncodingError.Context(codingPath: codingPath, debugDescription: description)
                throw EncodingError.invalidValue(value as Any, context)
            }
        }
    }
}

//===----------------------------------------------------------------------===//
// JSON wrapper for values
//===----------------------------------------------------------------------===//

// A wrapper for a generic json value.
private enum JSONValue: Codable {
    
    case null
    case bool(Bool)
    case int(Int)
    case double(Double)
    case string(String)
    
    /// The generic json value.
    var value: Any {
        switch self {
        case .null: return NSNull()
        case .bool(let value): return value
        case .int(let value): return value
        case .double(let value): return value
        case .string(let value): return value
        }
    }
    
    /// Wrap a generic json value.
    init(value: Any, codingPath: [CodingKey] = []) throws {
        if value is NSNull { self = .null }
        else if let value = value as? Bool { self = .bool(value) }
        else if let value = value as? Int { self = .int(value) }
        else if let value = value as? Double { self = .double(value) }
        else if let value = value as? String { self = .string(value) }
        else {
            let description = "Cannot initialize value from invalid JSON (note: use NSNull() to encode a null value)"
            let context = DecodingError.Context(codingPath: codingPath, debugDescription: description)
            throw DecodingError.dataCorrupted(context)
        }
    }
    
    /// Decode a generic json value.
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if container.decodeNil() { self = .null }
        else if let value = try? container.decode(Bool.self) { self = .bool(value) }
        else if let value = try? container.decode(Int.self) { self = .int(value) }
        else if let value = try? container.decode(Double.self) { self = .double(value) }
        else if let value = try? container.decode(String.self) { self = .string(value) }
        else {
            let codingPath = container.codingPath
            let description = "Cannot initialize value from invalid JSON"
            let context = DecodingError.Context(codingPath: codingPath, debugDescription: description)
            throw DecodingError.dataCorrupted(context)
        }
    }

    /// Encode a generic json value.
    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .null: try container.encodeNil()
        case .bool(let value): try container.encode(value)
        case .int(let value): try container.encode(value)
        case .double(let value): try container.encode(value)
        case .string(let value): try container.encode(value)
        }
    }
}
