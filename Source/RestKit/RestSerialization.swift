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

public extension DataRequest {

    @discardableResult
    public func responseObject<T: JSONDecodable>(
        queue: DispatchQueue? = nil,
        path: [JSONPathType]? = nil,
        completionHandler: @escaping (DataResponse<T>) -> Void)
        -> Self
    {
        return response(
            queue: queue,
            responseSerializer: DataRequest.objectResponseSerializer(path: path),
            completionHandler: completionHandler
        )
    }
    
    @discardableResult
    public func responseArray<T: JSONDecodable>(
        queue: DispatchQueue? = nil,
        path: [JSONPathType]? = nil,
        completionHandler: @escaping (DataResponse<[T]>) -> Void)
        -> Self
    {
        return response(
            queue: queue,
            responseSerializer: DataRequest.arrayResponseSerializer(path: path),
            completionHandler: completionHandler
        )
    }
    
    private static func objectResponseSerializer<T: JSONDecodable>(path: [JSONPathType]? = nil)
        -> DataResponseSerializer<T>
    {
        return DataResponseSerializer { request, response, data, error in
            
            // fail if an error was already produced
            guard error == nil else { return .failure(error!) }

            // fail if the data is nil
            guard let data = data else {
                return .failure(AFError.responseSerializationFailed(reason: .inputDataNil))
            }

            // serialize a `T` from the json data
            do {
                let json = try JSON(data: data)
                var object: T
                if let path = path {
                    switch path.count {
                    case 0: object = try json.decode()
                    case 1: object = try json.decode(at: path[0])
                    case 2: object = try json.decode(at: path[0], path[1])
                    case 3: object = try json.decode(at: path[0], path[1], path[2])
                    case 4: object = try json.decode(at: path[0], path[1], path[2], path[3])
                    case 5: object = try json.decode(at: path[0], path[1], path[2], path[3], path[4])
                    default: throw JSON.Error.keyNotFound(key: "ExhaustedVariadicParameterEncoding")
                    }
                } else {
                    object = try json.decode()
                }
                return .success(object)
            } catch {
                if let json = String(data: data, encoding: .utf8) {
                    print("JSON Serialization Failed. Could not parse the following data.")
                    print(json)
                }
                return .failure(AFError.responseSerializationFailed(reason: .jsonSerializationFailed(error: error)))
            }
        }
    }

    private static func arrayResponseSerializer<T: JSONDecodable>(path: [JSONPathType]? = nil)
        -> DataResponseSerializer<[T]>
    {
        return DataResponseSerializer { request, response, data, error in

            // fail if an error was already produced
            guard error == nil else { return .failure(error!) }

            // fail if the data is nil
            guard let data = data else {
                return .failure(AFError.responseSerializationFailed(reason: .inputDataNil))
            }
            
            // serialize a `[T]` from the json data
            do {
                let json = try JSON(data: data)
                var array: [JSON]
                if let path = path {
                    switch path.count {
                    case 0: array = try json.getArray()
                    case 1: array = try json.getArray(at: path[0])
                    case 2: array = try json.getArray(at: path[0], path[1])
                    case 3: array = try json.getArray(at: path[0], path[1], path[2])
                    case 4: array = try json.getArray(at: path[0], path[1], path[2], path[3])
                    case 5: array = try json.getArray(at: path[0], path[1], path[2], path[3], path[4])
                    default: throw JSON.Error.keyNotFound(key: "ExhaustedVariadicParameterEncoding")
                    }
                } else {
                    array = try json.getArray()
                }
                let objects: [T] = try array.map { json in try json.decode() }
                return .success(objects)
            } catch {
                if let json = String(data: data, encoding: .utf8) {
                    print("JSON Serialization Failed. Could not parse the following data.")
                    print(json)
                }
                return .failure(AFError.responseSerializationFailed(reason: .jsonSerializationFailed(error: error)))
            }
        }
    }
}
