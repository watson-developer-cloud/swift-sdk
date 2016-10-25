//
//  JSON.swift
//  WatsonDeveloperCloud
//
//  Created by Glenn Fisher on 10/24/16.
//  Copyright © 2016 Glenn R. Fisher. All rights reserved.
//

import Foundation

//public struct JSONCustom {
//    
//}
//
//public protocol JSONPathType {
//    func value(in dictionary: [String: Any]) throws -> Any
//    func value(in array: [Any]) throws -> Any
//}
//
//extension JSONPathType {
//    public func value(in dictionary: [String: Any]) throws -> Any {
//        throw JSONError.serializationError
//    }
//    
//    public func value(in array: [Any]) throws -> Any {
//        throw JSONError.serializationError
//    }
//}
//
//extension String: JSONPathType {
//    public func value(in dictionary: [String: Any]) throws -> Any {
//        guard let next = dictionary[self] else {
//            throw JSONError.serializationError
//        }
//        return next
//    }
//}
//
//extension Int: JSONPathType {
//    public func value(in array: [Any]) throws -> Any {
//        guard case array.indices = self else {
//            throw JSONError.serializationError
//        }
//        return array[self]
//    }
//}
//
//extension JSONCustom {
//    func value(for pathFragment: JSONPathType) throws -> JSON {
//        switch self {
//            
//        }
//    }
//}


//public enum JSONPath {
//    case index(Int)
//    case key(String)
//}
//
//public protocol JSONPathType {
//    var jsonPath: JSONPath { get }
//}
//
//extension Int: JSONPathType {
//    public var jsonPath: JSONPath {
//        return .index(self)
//    }
//}
//
//extension String: JSONPathType {
//    public var jsonPath: JSONPath {
//        return .key(self)
//    }
//}
////
////
////
////
////
//extension Dictionary where Key: ExpressibleByStringLiteral {
//    
//    public func getString(at key: String) throws -> String {
//        self[key]
//        
//        guard let string = self[key] as? String else {
//            throw JSONError.serializationError
//        }
//        return string
//    }
//}

//public enum JSONError: Error {
//    case serializationError
//}
