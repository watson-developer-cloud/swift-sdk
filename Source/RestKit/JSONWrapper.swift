/**
 * Copyright IBM Corporation 2016
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

// MARK: JSON Paths

internal protocol JSONPathType {
    func value(in dictionary: [String: Any]) throws -> JSONWrapper
    func value(in array: [Any]) throws -> JSONWrapper
}

extension String: JSONPathType {
    internal func value(in dictionary: [String: Any]) throws -> JSONWrapper {
        guard let json = dictionary[self] else {
            throw JSONWrapper.Error.keyNotFound(key: self)
        }
        return JSONWrapper(json: json)
    }

    internal func value(in array: [Any]) throws -> JSONWrapper {
        throw JSONWrapper.Error.unexpectedSubscript(type: String.self)
    }
}

extension Int: JSONPathType {
    internal func value(in dictionary: [String: Any]) throws -> JSONWrapper {
        throw JSONWrapper.Error.unexpectedSubscript(type: Int.self)
    }

    internal func value(in array: [Any]) throws -> JSONWrapper {
        let json = array[self]
        return JSONWrapper(json: json)
    }
}

// MARK: - JSON

/// Used internally to serialize and deserialize JSON.
/// Will soon be removed in favor of Swift 4's `Codable` protocol.
public struct JSONWrapper {
    fileprivate let json: Any

    internal init(json: Any) {
        self.json = json
    }

    internal init(string: String) throws {
        guard let data = string.data(using: .utf8) else {
            throw Error.encodingError
        }
        json = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
    }

    internal init(data: Data) throws {
        json = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
    }

    internal init(dictionary: [String: Any]) {
        json = dictionary
    }

    internal init(array: [Any]) {
        json = array
    }

    internal func serialize() throws -> Data {
        return try JSONSerialization.data(withJSONObject: json, options: [])
    }

    internal func serializeString() throws -> String {
        let data = try serialize()
        guard let string = String(data: data, encoding: .utf8) else {
            throw Error.stringSerializationError
        }
        return string
    }

    private func value(at path: JSONPathType) throws -> JSONWrapper {
        if let dictionary = json as? [String: Any] {
            return try path.value(in: dictionary)
        }
        if let array = json as? [Any] {
            return try path.value(in: array)
        }
        throw Error.unexpectedSubscript(type: type(of: path))
    }

    private func value(at path: [JSONPathType]) throws -> JSONWrapper {
        var value = self
        for fragment in path {
            value = try value.value(at: fragment)
        }
        return value
    }

    internal func decode<Decoded: JSONDecodable>(at path: JSONPathType..., type: Decoded.Type = Decoded.self) throws -> Decoded {
        return try Decoded(json: value(at: path))
    }

    internal func getDouble(at path: JSONPathType...) throws -> Double {
        return try Double(json: value(at: path))
    }

    internal func getInt(at path: JSONPathType...) throws -> Int {
        return try Int(json: value(at: path))
    }

    internal func getString(at path: JSONPathType...) throws -> String {
        return try String(json: value(at: path))
    }

    internal func getBool(at path: JSONPathType...) throws -> Bool {
        return try Bool(json: value(at: path))
    }

    internal func getArray(at path: JSONPathType...) throws -> [JSONWrapper] {
        let json = try value(at: path)
        guard let array = json.json as? [Any] else {
            throw Error.valueNotConvertible(value: json, to: [JSONWrapper].self)
        }
        return array.map { JSONWrapper(json: $0) }
    }

    internal func decodedArray<Decoded: JSONDecodable>(at path: JSONPathType..., type: Decoded.Type = Decoded.self) throws -> [Decoded] {
        let json = try value(at: path)
        guard let array = json.json as? [Any] else {
            throw Error.valueNotConvertible(value: json, to: [Decoded].self)
        }
        return try array.map { try Decoded(json: JSONWrapper(json: $0)) }
    }

    internal func decodedDictionary<Decoded: JSONDecodable>(at path: JSONPathType..., type: Decoded.Type = Decoded.self) throws -> [String: Decoded] {
        let json = try value(at: path)
        guard let dictionary = json.json as? [String: Any] else {
            throw Error.valueNotConvertible(value: json, to: [String: Decoded].self)
        }
        var decoded = [String: Decoded](minimumCapacity: dictionary.count)
        for (key, value) in dictionary {
            decoded[key] = try Decoded(json: JSONWrapper(json: value))
        }
        return decoded
    }

    internal func getJSON(at path: JSONPathType...) throws -> Any {
        return try value(at: path).json
    }

    internal func getDictionary(at path: JSONPathType...) throws -> [String: JSONWrapper] {
        let json = try value(at: path)
        guard let dictionary = json.json as? [String: Any] else {
            throw Error.valueNotConvertible(value: json, to: [String: JSONWrapper].self)
        }
        return dictionary.map { JSONWrapper(json: $0) }
    }

    internal func getDictionaryObject(at path: JSONPathType...) throws -> [String: Any] {
        let json = try value(at: path)
        guard let dictionary = json.json as? [String: Any] else {
            throw Error.valueNotConvertible(value: json, to: [String: JSONWrapper].self)
        }
        return dictionary
    }
}

// MARK: - JSON Errors

extension JSONWrapper {
    internal enum Error: Swift.Error {
        case indexOutOfBounds(index: Int)
        case keyNotFound(key: String)
        case unexpectedSubscript(type: JSONPathType.Type)
        case valueNotConvertible(value: JSONWrapper, to: Any.Type)
        case encodingError
        case stringSerializationError
    }
}

// MARK: - JSON Protocols

internal protocol JSONDecodable {
    init(json: JSONWrapper) throws
}

internal protocol JSONEncodable {
    func toJSON() -> JSONWrapper
    func toJSONObject() -> Any
}

extension JSONEncodable {
    internal func toJSON() -> JSONWrapper {
        return JSONWrapper(json: self.toJSONObject())
    }
}

extension Double: JSONDecodable {
    internal init(json: JSONWrapper) throws {
        let any = json.json
        if let double = any as? Double {
            self = double
        } else if let int = any as? Int {
            self = Double(int)
        } else if let string = any as? String, let double = Double(string) {
            self = double
        } else {
            throw JSONWrapper.Error.valueNotConvertible(value: json, to: Double.self)
        }
    }
}

extension Int: JSONDecodable {
    internal init(json: JSONWrapper) throws {
        let any = json.json
        if let int = any as? Int {
            self = int
        } else if let double = any as? Double, double <= Double(Int.max) {
            self = Int(double)
        } else if let string = any as? String, let int = Int(string) {
            self = int
        } else {
            throw JSONWrapper.Error.valueNotConvertible(value: json, to: Int.self)
        }
    }
}

extension Bool: JSONDecodable {
    internal init(json: JSONWrapper) throws {
        let any = json.json
        if let bool = any as? Bool {
            self = bool
        } else {
            throw JSONWrapper.Error.valueNotConvertible(value: json, to: Bool.self)
        }
    }
}

extension String: JSONDecodable {
    internal init(json: JSONWrapper) throws {
        let any = json.json
        if let string = any as? String {
            self = string
        } else if let int = any as? Int {
            self = String(int)
        } else if let bool = any as? Bool {
            self = String(bool)
        } else if let double = any as? Double {
            self = String(double)
        } else {
            throw JSONWrapper.Error.valueNotConvertible(value: json, to: String.self)
        }
    }
}
