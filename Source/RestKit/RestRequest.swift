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

public struct RestRequest {

    public static let userAgent: String = {
        let sdk = "watson-apis-swift-sdk"
        let sdkVersion = "0.8.0"
        
        let operatingSystem: String = {
            #if os(iOS)
                return "iOS"
            #elseif os(watchOS)
                return "watchOS"
            #elseif os(tvOS)
                return "tvOS"
            #elseif os(macOS)
                return "macOS"
            #elseif os(Linux)
                return "Linux"
            #else
                return "Unknown"
            #endif
        }()
        
        let operatingSystemVersion: String = {
            let os = ProcessInfo.processInfo.operatingSystemVersion
            return "\(os.majorVersion).\(os.minorVersion).\(os.patchVersion)"
        }()
        
        return "\(sdk)/\(sdkVersion) \(operatingSystem)/\(operatingSystemVersion)"
    }()

    private let request: URLRequest
    private let session = URLSession.shared
    
    public init(
        method: String,
        url: String,
        credentials: Credentials,
        headerParameters: [String: String],
        acceptType: String? = nil,
        contentType: String? = nil,
        queryItems: [URLQueryItem]? = nil,
        messageBody: Data? = nil)
    {
        // construct url with query parameters
        var urlComponents = URLComponents(string: url)!
        if let queryItems = queryItems, !queryItems.isEmpty {
            urlComponents.queryItems = queryItems
        }
        
        // construct basic mutable request
        var request = URLRequest(url: urlComponents.url!)
        request.httpMethod = method
        request.httpBody = messageBody
        
        // set the request's user agent
        request.setValue(RestRequest.userAgent, forHTTPHeaderField: "User-Agent")
        
        // set the request's authentication credentials
        switch credentials {
        case .apiKey: break
        case .basicAuthentication(let username, let password):
            let authData = (username + ":" + password).data(using: .utf8)!
            let authString = authData.base64EncodedString()
            request.setValue("Basic \(authString)", forHTTPHeaderField: "Authorization")
        }
        
        // set the request's header parameters
        for (key, value) in headerParameters {
            request.setValue(value, forHTTPHeaderField: key)
        }
        
        // set the request's accept type
        if let acceptType = acceptType {
            request.setValue(acceptType, forHTTPHeaderField: "Accept")
        }
        
        // set the request's content type
        if let contentType = contentType {
            request.setValue(contentType, forHTTPHeaderField: "Content-Type")
        }
        
        self.request = request
    }
    
    public func response(completionHandler: @escaping (Data?, HTTPURLResponse?, Error?) -> Void) {
        let task = session.dataTask(with: request) { (data, response, error) in
            completionHandler(data, response as? HTTPURLResponse, error)
        }
        task.resume()
    }
    
    public func responseData(completionHandler: @escaping (RestResponse<Data>) -> Void) {
        response() { data, response, error in
            guard let data = data else {
                let result = Result<Data>.failure(RestError.noData)
                let dataResponse = RestResponse(request: self.request, response: response, data: nil, result: result)
                completionHandler(dataResponse)
                return
            }
            let result = Result.success(data)
            let dataResponse = RestResponse(request: self.request, response: response, data: data, result: result)
        }
    }
    
    public func responseObject<T: JSONDecodable>(at keys: [String] = [], completionHandler: @escaping (RestResponse<T>) -> Void) {
        response() { data, response, error in
            
            // ensure data is not nil
            guard let data = data else {
                let result = Result<T>.failure(RestError.noData)
                let restResponse = RestResponse(request: self.request, response: response, data: nil, result: result)
                completionHandler(restResponse)
                return
            }
            
            // parse data as json
            guard let json = try? JSONSerialization.jsonObject(with: data, options: []) else {
                let result = Result<T>.failure(RestError.serializationError)
                let restResponse = RestResponse(request: self.request, response: response, data: data, result: result)
                completionHandler(restResponse)
                return
            }
            
            // parse json as an object
            guard let jsonRootObject = json as? [String: Any] else {
                let result = Result<T>.failure(RestError.serializationError)
                let restResponse = RestResponse(request: self.request, response: response, data: data, result: result)
                completionHandler(restResponse)
                return
            }
            
            // traverse key path
            guard let jsonObject = try? jsonRootObject.getJSONObject(at: keys) else {
                let result = Result<T>.failure(RestError.serializationError)
                let restResponse = RestResponse(request: self.request, response: response, data: data, result: result)
                completionHandler(restResponse)
                return
            }
            
            // initialize object from JSON
            let result: Result<T>
            do {
                let object = try T(json: jsonObject)
                result = .success(object)
            } catch {
                result = .failure(RestError.serializationError)
            }
            
            // execute callback
            let dataResponse = RestResponse(request: self.request, response: response, data: data, result: result)
            completionHandler(dataResponse)
        }
    }
    
    public func responseArray<T: JSONDecodable>(at key: String? = nil, completionHandler: @escaping (RestResponse<[T]>) -> Void) {
//        response() { data, response, error in
//            
//            // ensure data is not nil
//            guard let data = data else {
//                let result = Result<[T]>.failure(RestError.noData)
//                let dataResponse = RestResponse(request: self.request, response: response, data: nil, result: result)
//                completionHandler(dataResponse)
//                return
//            }
//            
//            // parse json object
//            let result: Result<[T]>
//            do {
//                let json = try JSON(at: key, data: data)
//                var array: [JSON]
//                if let path = path {
//                    switch path.count {
//                    case 0: array = try json.getArray()
//                    case 1: array = try json.getArray(at: path[0])
//                    case 2: array = try json.getArray(at: path[0], path[1])
//                    case 3: array = try json.getArray(at: path[0], path[1], path[2])
//                    case 4: array = try json.getArray(at: path[0], path[1], path[2], path[3])
//                    case 5: array = try json.getArray(at: path[0], path[1], path[2], path[3], path[4])
//                    default: throw JSON.Error.keyNotFound(key: "ExhaustedVariadicParameterEncoding")
//                    }
//                } else {
//                    array = try json.getArray()
//                }
//                let objects: [T] = try array.map { json in try json.decode() }
//                result = .success(objects)
//            } catch {
//                result = .failure(RestError.serializationError)
//            }
//            
//            // execute callback
//            let dataResponse = RestResponse(request: self.request, response: response, data: data, result: result)
//            completionHandler(dataResponse)
//        }
    }
    
    public func responseString(completionHandler: @escaping (RestResponse<String>) -> Void) {
        response() { data, response, error in
            
            // ensure data is not nil
            guard let data = data else {
                let result = Result<String>.failure(RestError.noData)
                let dataResponse = RestResponse(request: self.request, response: response, data: nil, result: result)
                completionHandler(dataResponse)
                return
            }
            
            // parse data as a string
            guard let string = String(data: data, encoding: .utf8) else {
                let result = Result<String>.failure(RestError.serializationError)
                let dataResponse = RestResponse(request: self.request, response: response, data: nil, result: result)
                completionHandler(dataResponse)
                return
            }
            
            // execute callback
            let result = Result.success(string)
            let dataResponse = RestResponse(request: self.request, response: response, data: data, result: result)
            completionHandler(dataResponse)
        }
    }
    
    public func download(to: URL, completionHandler: @escaping (HTTPURLResponse?, Error?) -> Void) {
        // TODO: implement this function
    }
}

public struct RestResponse<T> {
    public let request: URLRequest?
    public let response: HTTPURLResponse?
    public let data: Data?
    public let result: Result<T>
}

public enum Result<T> {
    case success(T)
    case failure(Error)
}

public enum Credentials {
    case apiKey
    case basicAuthentication(username: String, password: String)
}

public enum RestError: Error {
    case noData
    case serializationError
}

public class MultipartFormData {
    public init() {
        
    }
    
    public func append(_ data: Data, withName: String) {
        // TODO: implement this function
    }
    
    public func append(_ fileURL: URL, withName: String) {
        // TODO: implement this function
    }
    
    public func toData() -> Data {
        // TODO: implement this function
        return Data()
    }
}
