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

// MARK: - RestRequest

internal struct RestRequest {

    internal static let userAgent: String = {
        let sdk = "watson-apis-swift-sdk"
        let sdkVersion = "0.24.1"
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

    internal var method: String
    internal var url: String
    internal var credentials: AuthenticationMethod
    internal var headerParameters: [String: String]
    internal var queryItems: [URLQueryItem]
    internal var messageBody: Data? = nil
    private let session = URLSession(configuration: URLSessionConfiguration.default)

    internal init(
        method: String,
        url: String,
        credentials: AuthenticationMethod,
        headerParameters: [String: String]? = nil,
        acceptType: String? = nil,
        contentType: String? = nil,
        queryItems: [URLQueryItem]? = nil,
        messageBody: Data? = nil)
    {
        var headerParameters = headerParameters ?? [:]
        if let acceptType = acceptType { headerParameters["Accept"] = acceptType }
        if let contentType = contentType { headerParameters["Content-Type"] = contentType }
        self.method = method
        self.url = url
        self.credentials = credentials
        self.headerParameters = headerParameters
        self.queryItems = queryItems ?? []
        self.messageBody = messageBody
    }

    private var urlRequest: URLRequest {
        // we must explicitly encode "+" as "%2B" since URLComponents does not
        var components = URLComponents(string: url)!
        if !queryItems.isEmpty { components.queryItems = queryItems }
        components.percentEncodedQuery = components.percentEncodedQuery?.replacingOccurrences(of: "+", with: "%2B")
        var request = URLRequest(url: components.url!)
        request.httpMethod = method
        request.httpBody = messageBody
        request.setValue(RestRequest.userAgent, forHTTPHeaderField: "User-Agent")
        headerParameters.forEach { (key, value) in request.setValue(value, forHTTPHeaderField: key) }
        return request
    }
}

// MARK: - Response Functions

extension RestRequest {

    /**
     Execute this request and process the response body as raw data.

     - parseServiceError: A function that can parse service-specific errors from the raw data response.
     - completionHandler: The completion handler to call when the request is complete.
     */
    internal func responseData(
        parseServiceError: ((HTTPURLResponse?, Data?) -> Error?)? = nil,
        completionHandler: @escaping (Data?, HTTPURLResponse?, Error?) -> Void)
    {
        // add authentication credentials to the request
        credentials.authenticate(request: self) { request, error in

            // ensure there is no credentials error
            guard let request = request, error == nil else {
                completionHandler(nil, nil, error)
                return
            }

            // create a task to execute the request
            let task = self.session.dataTask(with: request.urlRequest) { (data, response, error) in

                // ensure there is no underlying error
                guard error == nil else {
                    completionHandler(data, response as? HTTPURLResponse, error)
                    return
                }

                // ensure there is a valid http response
                guard let response = response as? HTTPURLResponse else {
                    let error = RestError.noResponse
                    completionHandler(data, nil, error)
                    return
                }

                // ensure the status code is successful
                guard (200..<300).contains(response.statusCode) else {
                    if let serviceError = parseServiceError?(response, data) {
                        completionHandler(data, response, serviceError)
                    } else {
                        let genericMessage = HTTPURLResponse.localizedString(forStatusCode: response.statusCode)
                        let genericError = RestError.failure(response.statusCode, genericMessage)
                        completionHandler(data, response, genericError)
                    }
                    return
                }

                // execute completion handler with successful response
                completionHandler(data, response, nil)
            }

            // start the task
            task.resume()
        }
    }

    /**
     Execute this request and process the response body as a JSON object.

     - parseServiceError: A function that can parse service-specific errors from the raw data response.
     - path: The path at which to decode the JSON object.
     - completionHandler: The completion handler to call when the request is complete.
     */
    internal func responseObject<T: JSONDecodable>(
        parseServiceError: ((HTTPURLResponse?, Data?) -> Error?)? = nil,
        path: [JSONPathType]? = nil,
        completionHandler: @escaping (T?, HTTPURLResponse?, Error?) -> Void)
    {
        // execute the request
        responseData(parseServiceError: parseServiceError) { data, response, error in

            // ensure there is no underlying error
            guard error == nil else {
                completionHandler(nil, response, error)
                return
            }

            // ensure there is data to parse
            guard let data = data else {
                completionHandler(nil, response, RestError.noData)
                return
            }

            // parse response body as a JSONobject
            do {
                let json = try JSONWrapper(data: data)
                let object: T
                if let path = path {
                    switch path.count {
                    case 0: object = try json.decode()
                    case 1: object = try json.decode(at: path[0])
                    case 2: object = try json.decode(at: path[0], path[1])
                    case 3: object = try json.decode(at: path[0], path[1], path[2])
                    case 4: object = try json.decode(at: path[0], path[1], path[2], path[3])
                    case 5: object = try json.decode(at: path[0], path[1], path[2], path[3], path[4])
                    default: throw JSONWrapper.Error.keyNotFound(key: "ExhaustedVariadicParameterEncoding")
                    }
                } else {
                    object = try json.decode()
                }
                completionHandler(object, response, nil)
            } catch {
                completionHandler(nil, response, error)
            }
        }
    }

    /**
     Execute this request and process the response body as a decodable value.

     - parseServiceError: A function that can parse service-specific errors from the raw data response.
     - completionHandler: The completion handler to call when the request is complete.
     */
    internal func responseObject<T: Decodable>(
        parseServiceError: ((HTTPURLResponse?, Data?) -> Error?)? = nil,
        completionHandler: @escaping (T?, HTTPURLResponse?, Error?) -> Void)
    {
        // execute the request
        responseData(parseServiceError: parseServiceError) { data, response, error in

            // ensure there is no underlying error
            guard error == nil else {
                completionHandler(nil, response, error)
                return
            }

            // ensure there is data to parse
            guard let data = data else {
                completionHandler(nil, response, RestError.noData)
                return
            }

            // parse response body as a decodable value
            do {
                let value = try JSONDecoder().decode(T.self, from: data)
                completionHandler(value, response, nil)
            } catch {
                completionHandler(nil, response, error)
            }
        }
    }

    /**
     Execute this request and process the response body as a JSON array.

     - parseServiceError: A function that can parse service-specific errors from the raw data response.
     - path: The path at which to decode the JSON array.
     - completionHandler: The completion handler to call when the request is complete.
     */
    internal func responseArray<T: JSONDecodable>(
        parseServiceError: ((HTTPURLResponse?, Data?) -> Error?)? = nil,
        path: [JSONPathType]? = nil,
        completionHandler: @escaping ([T]?, HTTPURLResponse?, Error?) -> Void)
    {
        // execute the request
        responseData(parseServiceError: parseServiceError) { data, response, error in

            // ensure there is no underlying error
            guard error == nil else {
                completionHandler(nil, response, error)
                return
            }

            // ensure there is data to parse
            guard let data = data else {
                completionHandler(nil, response, RestError.noData)
                return
            }

            // parse json object
            do {
                let json = try JSONWrapper(data: data)
                var array: [JSONWrapper]
                if let path = path {
                    switch path.count {
                    case 0: array = try json.getArray()
                    case 1: array = try json.getArray(at: path[0])
                    case 2: array = try json.getArray(at: path[0], path[1])
                    case 3: array = try json.getArray(at: path[0], path[1], path[2])
                    case 4: array = try json.getArray(at: path[0], path[1], path[2], path[3])
                    case 5: array = try json.getArray(at: path[0], path[1], path[2], path[3], path[4])
                    default: throw JSONWrapper.Error.keyNotFound(key: "ExhaustedVariadicParameterEncoding")
                    }
                } else {
                    array = try json.getArray()
                }
                let objects: [T] = try array.map { json in try json.decode() }
                completionHandler(objects, response, nil)
            } catch {
                completionHandler(nil, response, error)
            }
        }
    }

    /**
     Execute this request and process the response body as a string.

     - parseServiceError: A function that can parse service-specific errors from the raw data response.
     - completionHandler: The completion handler to call when the request is complete.
     */
    internal func responseString(
        parseServiceError: ((HTTPURLResponse?, Data?) -> Error?)? = nil,
        completionHandler: @escaping (String?, HTTPURLResponse?, Error?) -> Void)
    {
        // execute the request
        responseData(parseServiceError: parseServiceError) { data, response, error in

            // ensure there is no underlying error
            guard error == nil else {
                completionHandler(nil, response, error)
                return
            }

            // ensure there is data to parse
            guard let data = data else {
                completionHandler(nil, response, RestError.noData)
                return
            }

            // parse data as a string
            guard let string = String(data: data, encoding: .utf8) else {
                completionHandler(nil, response, RestError.serializationError)
                return
            }

            // execute completion handler
            completionHandler(string, response, nil)
        }
    }

    /**
     Execute this request and ignore any response body.

     - parseServiceError: A function that can parse service-specific errors from the raw data response.
     - completionHandler: The completion handler to call when the request is complete.
     */
    internal func responseVoid(
        parseServiceError: ((HTTPURLResponse?, Data?) -> Error?)? = nil,
        completionHandler: @escaping (HTTPURLResponse?, Error?) -> Void)
    {
        // execute the request
        responseData(parseServiceError: parseServiceError) { data, response, error in

            // ensure there is no underlying error
            guard error == nil else {
                completionHandler(response, error)
                return
            }

            // execute completion handler
            completionHandler(response, nil)
        }
    }

    /**
     Execute this request and save the response body to disk.

     - to: The destination file where the response body should be saved.
     - completionHandler: The completion handler to call when the request is complete.
     */
    internal func download(
        to destination: URL,
        completionHandler: @escaping (HTTPURLResponse?, Error?) -> Void)
    {
        // add authentication credentials to the request
        credentials.authenticate(request: self) { request, error in

            // ensure there is no credentials error
            guard let request = request, error == nil else {
                completionHandler(nil, error)
                return
            }

            // create a task to execute the request
            let task = self.session.downloadTask(with: request.urlRequest) { (location, response, error) in

                // ensure there is no underlying error
                guard error == nil else {
                    completionHandler(response as? HTTPURLResponse, error)
                    return
                }

                // ensure there is a valid http response
                guard let response = response as? HTTPURLResponse else {
                    completionHandler(nil, RestError.noResponse)
                    return
                }

                // ensure the response body was saved to a temporary location
                guard let location = location else {
                    completionHandler(response, RestError.invalidFile)
                    return
                }

                // move the temporary file to the specified destination
                do {
                    try FileManager.default.moveItem(at: location, to: destination)
                    completionHandler(response, nil)
                } catch {
                    completionHandler(response, RestError.fileManagerError)
                }
            }

            // start the download task
            task.resume()
        }
    }
}
