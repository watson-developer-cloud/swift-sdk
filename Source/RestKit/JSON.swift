//
//  JSON.swift
//  WatsonDeveloperCloud
//
//  Created by Glenn Fisher on 10/24/16.
//  Copyright © 2016 Glenn R. Fisher. All rights reserved.
//

import Foundation

// MARK: - JSON Errors

public enum JSONError: Error {
    case indexOutOfBounds(index: Int)
    case keyNotFound(key: String)
    case valueNotConvertible(value: Any, to: Any.Type)
    case nullValue(key: String)
}

// MARK: - JSON Object Protocols

public protocol JSONDecodable {
    init(json: [String: Any]) throws
}

public protocol JSONEncodable {
    func toJSON() -> [String: Any]
}

// MARK: - JSON Key Types

public protocol JSONKeyType {
    var stringValue: String { get }
}

extension String: JSONKeyType {
    public var stringValue: String {
        return self
    }
}

// MARK: - JSON Value Types

//public protocol JSONValueType {
//    init (json: Any) throws
//}
//
//extension String: JSONValueType {
//    public init(json: Any) throws {
//        guard let value = json as? String else {
//            throw JSONError.valueNotConvertible(value: json, to: String.self)
//        }
//        self = value
//    }
//}
//
//extension Int: JSONValueType {
//    public init(json: Any) throws {
//        guard let value = json as? Int else {
//            throw JSONError.valueNotConvertible(value: json, to: Int.self)
//        }
//        self = value
//    }
//}
//
//extension UInt: JSONValueType {
//    public init(json: Any) throws {
//        guard let value = json as? UInt else {
//            throw JSONError.valueNotConvertible(value: json, to: UInt.self)
//        }
//        self = value
//    }
//}
//
//extension Float: JSONValueType {
//    public init(json: Any) throws {
//        guard let value = json as? Float else {
//            throw JSONError.valueNotConvertible(value: json, to: Float.self)
//        }
//        self = value
//    }
//}
//
//extension Double: JSONValueType {
//    public init(json: Any) throws {
//        guard let value = json as? Double else {
//            throw JSONError.valueNotConvertible(value: json, to: Double.self)
//        }
//        self = value
//    }
//}
//
//extension Bool: JSONValueType {
//    public init(json: Any) throws {
//        guard let value = json as? Bool else {
//            throw JSONError.valueNotConvertible(value: json, to: Bool.self)
//        }
//        self = value
//    }
//}
//
//extension Array where Element: JSONValueType {
//    public init(json: Any) throws {
//        guard let any = json as? [Any] else {
//            throw JSONError.valueNotConvertible(value: json, to: [Element].self)
//        }
//        self = try any.map { try Element(json: $0) }
//    }
//}
//
//extension Dictionary: JSONValueType {
//    public init(json: Any) throws {
//        guard let value = json as? [Key: Value] else {
//            throw JSONError.valueNotConvertible(value: json, to: [Key: Value].self)
//        }
//        self = value
//    }
//}
//
//extension Dictionary where Value: JSONValueType {
//    public init(json: Any) throws {
//        guard let any = json as? [Key: Any] else {
//            throw JSONError.valueNotConvertible(value: json, to: [Key: Any].self)
//        }
//        var dictionary = [Key: Value](minimumCapacity: any.count)
//        for (key, value) in any {
//            dictionary[key] = try Value(json: value)
//        }
//        self = dictionary
//    }
//}
//
//// MARK: - Dictionary extensions to parse JSON values
//
//extension Dictionary where Key: JSONKeyType {
//    private func any(at keys: [Key]) throws -> Any {
//        var accumulator: Any = self
//        for key in keys {
//            if let json = accumulator as? [Key: Any] {
//                if let value = json[key] {
//                    accumulator = value
//                    continue
//                }
//            }
//            throw JSONError.keyNotFound(key: key.stringValue)
//        }
//        return accumulator
//    }
//    
//    public func json(at keys: [Key]) throws -> [String: Any] {
//        guard let json = try self.any(at: keys) as? [String: Any] else {
//            throw JSONError.valueNotConvertible(value: self, to: [String: Any].self)
//        }
//        return json
//    }
//    
//    public func jsonValue<T: JSONValueType>(at keys: Key...) throws -> T {
//        let json = try self.any(at: keys)
//        let value = try T(json: json)
//        return value
//    }
//    
//    public func jsonValue<T: JSONValueType>(at keys: Key...) throws -> [T] {
//        let json = try self.any(at: keys)
//        let array = try [T](json: json)
//        return array
//    }
//    
//    public func jsonValue<T: JSONDecodableCustom>(at keys: Key...) throws -> T {
//        let json = try self.any(at: keys)
//        guard let jsonObject = json as? [String: Any] else {
//            throw JSONError.valueNotConvertible(value: json, to: T.self)
//        }
//        let object = try T(json: jsonObject)
//        return object
//    }
//}

extension Dictionary where Key: JSONKeyType {
    private func value(at keys: [Key]) throws -> Any {
        var value: Any = self
        for key in keys {
            if let object = value as? [Key: Any] {
                if let property = object[key] {
                    value = property
                    continue
                }
            }
            throw JSONError.keyNotFound(key: key.stringValue)
        }
        return value
    }
    
    private func object(at keys: [Key]) throws -> [String: Any] {
        guard let object = try value(at: keys) as? [String: Any] else {
            throw JSONError.valueNotConvertible(value: self, to: [String: Any].self)
        }
        return object
    }
    
    private func objects(at keys: [Key]) throws -> [[String: Any]] {
        guard let objects = try value(at: keys) as? [[String: Any]] else {
            throw JSONError.valueNotConvertible(value: self, to: [Any].self)
        }
        return objects
    }
    
    public func object<T: JSONDecodable>(at keys: Key...) throws -> T {
        let json = try self.object(at: keys)
        let object = try T(json: json)
        return object
    }
    
    public func objects<T: JSONDecodable>(at keys: Key...) throws -> [T] {
        let json = try self.objects(at: keys)
        let objects = try json.map { try T(json: $0) }
        return objects
    }
    
    public func getJSONObject(at keys: [Key]) throws -> [String: Any] {
        let value = try self.value(at: keys)
        guard let jsonObject = value as? [String: Any] else {
            throw JSONError.valueNotConvertible(value: value, to: Double.self)
        }
        return jsonObject
    }
    
    public func getDouble(at keys: Key...) throws -> Double {
        let value = try self.value(at: keys)
        guard let double = value as? Double else {
            throw JSONError.valueNotConvertible(value: value, to: Double.self)
        }
        return double
    }
    
    public func getInt(at keys: Key...) throws -> Int {
        let value = try self.value(at: keys)
        guard let int = value as? Int else {
            throw JSONError.valueNotConvertible(value: value, to: Int.self)
        }
        return int
    }
    
    public func getIntArray(at keys: Key...) throws -> [Int] {
        let value = try self.value(at: keys)
        guard let ints = value as? [Int] else {
            throw JSONError.valueNotConvertible(value: value, to: [Int].self)
        }
        return ints
    }
    
    public func getString(at keys: Key...) throws -> String {
        let value = try self.value(at: keys)
        guard let string = value as? String else {
            throw JSONError.valueNotConvertible(value: value, to: String.self)
        }
        return string
    }
    
    public func getStringArray(at keys: Key...) throws -> [String] {
        let value = try self.value(at: keys)
        guard let strings = value as? [String] else {
            throw JSONError.valueNotConvertible(value: value, to: [String].self)
        }
        return strings
    }
    
    public func getBool(at keys: Key...) throws -> Bool {
        let value = try self.value(at: keys)
        guard let bool = value as? Bool else {
            throw JSONError.valueNotConvertible(value: value, to: Bool.self)
        }
        return bool
    }
    
    
}
