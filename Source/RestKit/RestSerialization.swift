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
import Alamofire
import Freddy

public extension Request {

    /**
     Creates a response serializer that returns an object of the given type initialized from
     JSON response data.
     
     - parameter dataToError: A function that interprets an error model to produce an NSError.
     - parameter path: 0 or more `String` or `Int` that subscript the `JSON`.
 
     - returns: An object response serializer.
     */
    private static func ObjectSerializer<T: JSONDecodable>(
        dataToError: ((NSData -> NSError?)?) = nil,
        path: [JSONPathType]? = nil)
        -> ResponseSerializer<T, NSError>
    {
        return ResponseSerializer { request, response, data, error in

            // fail if an error was already produced
            guard error == nil else {
                return .Failure(error!)
            }

            // fail if the data is nil
            guard let data = data else {
                let failureReason = "Data could not be serialized. Input data was nil."
                let error = serializationError(failureReason)
                return .Failure(error)
            }

            // fail if the data can be converted to an NSError
            if let dataToError = dataToError {
                if let dataError = dataToError(data) {
                    return .Failure(dataError)
                }
            }

            // serialize a `T` from the json data
            do {
                let json = try JSON(data: data)
                var object: T
                if let path = path {
                    switch path.count {
                    case 0: object = try json.decode()
                    case 1: object = try json.decode(path[0])
                    case 2: object = try json.decode(path[0], path[1])
                    case 3: object = try json.decode(path[0], path[1], path[2])
                    case 4: object = try json.decode(path[0], path[1], path[2], path[3])
                    case 5: object = try json.decode(path[0], path[1], path[2], path[3], path[4])
                    default: throw JSON.Error.KeyNotFound(key: "ExhaustedVariadicParameterEncoding")
                    }
                } else {
                    object = try json.decode()
                }
                return .Success(object)
            } catch JSON.Error.IndexOutOfBounds(let index) {
                let failureReason = "Data could not be serialized. Failed to parse JSON response." +
                                    " The index (\(index)) is out of bounds for a JSON array."
                let error = serializationError(failureReason)
                return .Failure(error)
            } catch JSON.Error.KeyNotFound(let key) {
                let failureReason = "Data could not be serialized. Failed to parse JSON response." +
                                    " The key (\(key)) was not found in the JSON dictionary."
                let error = serializationError(failureReason)
                return .Failure(error)
            } catch JSON.Error.UnexpectedSubscript(let type) {
                let failureReason = "Data could not be serialized. Failed to parse JSON response." +
                                    " The JSON is not subscriptable with type \(type)."
                let error = serializationError(failureReason)
                return .Failure(error)
            } catch JSON.Error.ValueNotConvertible(let value, let type) {
                let failureReason = "Data could not be serialized. Failed to parse JSON response." +
                                    " Unexpected JSON value (\(value)) was found that is not " +
                                    "convertible to the type \(type)."
                let error = serializationError(failureReason)
                return .Failure(error)
            } catch {
                let failureReason = "Data could not be serialized. Failed to parse JSON response." +
                                    " No error information was provided during serialization."
                let error = serializationError(failureReason)
                return .Failure(error)
            }
        }
    }

    /**
     Creates a response serializer that returns an array of objects of the given type
     initialized from JSON response data.

     - parameter dataToError: A function that interprets an error model to produce an NSError.
     - parameter path: 0 or more `String` or `Int` that subscript the `JSON`.

     - returns: An object response serializer.
     */
    private static func ArraySerializer<T: JSONDecodable>(
        dataToError: ((NSData -> NSError?)?) = nil,
        path: [JSONPathType]? = nil)
        -> ResponseSerializer<[T], NSError>
    {
        return ResponseSerializer { request, response, data, error in

            // fail if an error was already produced
            guard error == nil else {
                return .Failure(error!)
            }

            // fail if the data is nil
            guard let data = data else {
                let failureReason = "Data could not be serialized. Input data was nil."
                let error = serializationError(failureReason)
                return .Failure(error)
            }

            // fail if the data can be converted to an NSError
            if let dataToError = dataToError {
                if let dataError = dataToError(data) {
                    return .Failure(dataError)
                }
            }

            // serialize a `[T]` from the json data
            do {
                let json = try JSON(data: data)
                var array: [JSON]
                if let path = path {
                    switch path.count {
                    case 0: array = try json.array()
                    case 1: array = try json.array(path[0])
                    case 2: array = try json.array(path[0], path[1])
                    case 3: array = try json.array(path[0], path[1], path[2])
                    case 4: array = try json.array(path[0], path[1], path[2], path[3])
                    case 5: array = try json.array(path[0], path[1], path[2], path[3], path[4])
                    default: throw JSON.Error.KeyNotFound(key: "ExhaustedVariadicParameterEncoding")
                    }
                } else {
                    array = try json.array()
                }
                let objects: [T] = try array.map { json in try json.decode() }
                return .Success(objects)
            } catch JSON.Error.IndexOutOfBounds(let index) {
                let failureReason = "Data could not be serialized. Failed to parse JSON response." +
                                    " The index (\(index)) is out of bounds for a JSON array."
                let error = serializationError(failureReason)
                return .Failure(error)
            } catch JSON.Error.KeyNotFound(let key) {
                let failureReason = "Data could not be serialized. Failed to parse JSON response." +
                                    " The key (\(key)) was not found in the JSON dictionary."
                let error = serializationError(failureReason)
                return .Failure(error)
            } catch JSON.Error.UnexpectedSubscript(let type) {
                let failureReason = "Data could not be serialized. Failed to parse JSON response." +
                                    " The JSON is not subscriptable with type \(type)."
                let error = serializationError(failureReason)
                return .Failure(error)
            } catch JSON.Error.ValueNotConvertible(let value, let type) {
                let failureReason = "Data could not be serialized. Failed to parse JSON response." +
                                    " Unexpected JSON value (\(value)) was found that is not " +
                                    "convertible to the type \(type)."
                let error = serializationError(failureReason)
                return .Failure(error)
            } catch {
                let failureReason = "Data could not be serialized. Failed to parse JSON response." +
                                    " No error information was provided during serialization."
                let error = serializationError(failureReason)
                return .Failure(error)
            }
        }
    }

    /**
     Adds a handler to be called once the request has finished.
 
     - parameter queue: The queue to use.
     - parameter dataToError: A function that interprets an error model to produce an NSError.
     - parameter path: 0 or more `String` or `Int` that subscript the `JSON`.
     - parameter completionHandler: The code to be executed once the request has finished.
     */
    public func responseObject<T: JSONDecodable>(
        queue queue: dispatch_queue_t? = nil,
        dataToError: (NSData -> NSError?)? = nil,
        path: [JSONPathType]? = nil,
        completionHandler: Response<T, NSError> -> Void)
        -> Self
    {
        return response(
            queue: queue,
            responseSerializer: Request.ObjectSerializer(dataToError, path: path),
            completionHandler: completionHandler
        )
    }

    /**
     Adds a handler to be called once the request has finished.

     - parameter queue: The queue to use.
     - parameter dataToError: A function that interprets an error model to produce an NSError.
     - parameter path: 0 or more `String` or `Int` that subscript the `JSON`.
     - parameter completionHandler: The code to be executed once the request has finished.
     */
    public func responseArray<T: JSONDecodable>(
        queue queue: dispatch_queue_t? = nil,
        dataToError: (NSData -> NSError?)? = nil,
        path: [JSONPathType]? = nil,
        completionHandler: Response<[T], NSError> -> Void)
        -> Self
    {
        return response(
            queue: queue,
            responseSerializer: Request.ArraySerializer(dataToError, path: path),
            completionHandler: completionHandler
        )
    }
    
    /**
     Return an `NSError` that describes a serialization error.
 
     - parameter failureReason: A description of the error's cause.
     */
    private static func serializationError(failureReason: String) -> NSError {
        let code = Error.Code.DataSerializationFailed.rawValue
        let userInfo = [NSLocalizedFailureReasonErrorKey: failureReason]
        let error = NSError(domain: Error.Domain, code: code, userInfo: userInfo)
        return error
    }
}
