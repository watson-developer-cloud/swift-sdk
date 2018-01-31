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

internal struct RestRequest {

    internal static let userAgent: String = {
        let sdk = "watson-apis-swift-sdk"
        let sdkVersion = "0.21.0"

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
    private let session = URLSession(configuration: URLSessionConfiguration.default)

    internal init(
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

        // Must encode "+" to %2B (URLComponents does not do this)
        urlComponents.percentEncodedQuery = urlComponents.percentEncodedQuery?.replacingOccurrences(of: "+", with: "%2B")

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

    internal func response(
        parseServiceError: ((HTTPURLResponse?, Data?) -> Error?)? = nil,
        completionHandler: @escaping (Data?, HTTPURLResponse?, Error?) -> Void)
    {
        let task = session.dataTask(with: request) { (data, response, error) in

            guard error == nil else {
                completionHandler(data, response as? HTTPURLResponse, error)
                return
            }

            guard let response = response as? HTTPURLResponse else {
                let error = RestError.noResponse
                completionHandler(data, nil, error)
                return
            }

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

            // Success path
            completionHandler(data, response, nil)
        }
        task.resume()
    }

    internal func responseData(completionHandler: @escaping (RestResponse<Data>) -> Void) {
        response { data, response, error in
            guard error == nil else {
                // swiftlint:disable:next force_unwrapping
                let result = RestResult<Data>.failure(error!)
                let dataResponse = RestResponse(request: self.request, response: response, data: data, result: result)
                completionHandler(dataResponse)
                return
            }
            guard let data = data else {
                let result = RestResult<Data>.failure(RestError.noData)
                let dataResponse = RestResponse(request: self.request, response: response, data: nil, result: result)
                completionHandler(dataResponse)
                return
            }
            let result = RestResult.success(data)
            let dataResponse = RestResponse(request: self.request, response: response, data: data, result: result)
            completionHandler(dataResponse)
        }
    }

    internal func responseObject<T: JSONDecodable>(
        responseToError: ((HTTPURLResponse?, Data?) -> Error?)? = nil,
        path: [JSONPathType]? = nil,
        completionHandler: @escaping (RestResponse<T>) -> Void)
    {
        response(parseServiceError: responseToError) { data, response, error in

            guard error == nil else {
                // swiftlint:disable:next force_unwrapping
                let result = RestResult<T>.failure(error!)
                let dataResponse = RestResponse(request: self.request, response: response, data: data, result: result)
                completionHandler(dataResponse)
                return
            }

            // ensure data is not nil
            guard let data = data else {
                let result = RestResult<T>.failure(RestError.noData)
                let dataResponse = RestResponse(request: self.request, response: response, data: nil, result: result)
                completionHandler(dataResponse)
                return
            }

            // parse json object
            let result: RestResult<T>
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
                result = .success(object)
            } catch {
                result = .failure(error)
            }

            // execute callback
            let dataResponse = RestResponse(request: self.request, response: response, data: data, result: result)
            completionHandler(dataResponse)
        }
    }

    internal func responseObject<T: Decodable>(
        responseToError: ((HTTPURLResponse?, Data?) -> Error?)? = nil,
        completionHandler: @escaping (RestResponse<T>) -> Void)
    {
        response(parseServiceError: responseToError) { data, response, error in

            guard error == nil else {
                // swiftlint:disable:next force_unwrapping
                let result = RestResult<T>.failure(error!)
                let dataResponse = RestResponse(request: self.request, response: response, data: data, result: result)
                completionHandler(dataResponse)
                return
            }

            // ensure data is not nil
            guard let data = data else {
                let result = RestResult<T>.failure(RestError.noData)
                let dataResponse = RestResponse(request: self.request, response: response, data: nil, result: result)
                completionHandler(dataResponse)
                return
            }

            // parse json object
            let result: RestResult<T>
            do {
                let object = try JSONDecoder().decode(T.self, from: data)
                result = .success(object)
            } catch {
                result = .failure(error)
            }

            // execute callback
            let dataResponse = RestResponse(request: self.request, response: response, data: data, result: result)
            completionHandler(dataResponse)
        }
    }

    internal func responseArray<T: JSONDecodable>(
        responseToError: ((HTTPURLResponse?, Data?) -> Error?)? = nil,
        path: [JSONPathType]? = nil,
        completionHandler: @escaping (RestResponse<[T]>) -> Void)
    {
        response(parseServiceError: responseToError) { data, response, error in

            guard error == nil else {
                // swiftlint:disable:next force_unwrapping
                let result = RestResult<[T]>.failure(error!)
                let dataResponse = RestResponse(request: self.request, response: response, data: data, result: result)
                completionHandler(dataResponse)
                return
            }

            // ensure data is not nil
            guard let data = data else {
                let result = RestResult<[T]>.failure(RestError.noData)
                let dataResponse = RestResponse(request: self.request, response: response, data: nil, result: result)
                completionHandler(dataResponse)
                return
            }

            // parse json object
            let result: RestResult<[T]>
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
                result = .success(objects)
            } catch {
                result = .failure(error)
            }

            // execute callback
            let dataResponse = RestResponse(request: self.request, response: response, data: data, result: result)
            completionHandler(dataResponse)
        }
    }

    internal func responseString(
        responseToError: ((HTTPURLResponse?, Data?) -> Error?)? = nil,
        completionHandler: @escaping (RestResponse<String>) -> Void)
    {
        response(parseServiceError: responseToError) { data, response, error in

            guard error == nil else {
                // swiftlint:disable:next force_unwrapping
                let result = RestResult<String>.failure(error!)
                let dataResponse = RestResponse(request: self.request, response: response, data: data, result: result)
                completionHandler(dataResponse)
                return
            }

            // ensure data is not nil
            guard let data = data else {
                let result = RestResult<String>.failure(RestError.noData)
                let dataResponse = RestResponse(request: self.request, response: response, data: nil, result: result)
                completionHandler(dataResponse)
                return
            }

            // parse data as a string
            guard let string = String(data: data, encoding: .utf8) else {
                let result = RestResult<String>.failure(RestError.serializationError)
                let dataResponse = RestResponse(request: self.request, response: response, data: nil, result: result)
                completionHandler(dataResponse)
                return
            }

            // execute callback
            let result = RestResult.success(string)
            let dataResponse = RestResponse(request: self.request, response: response, data: data, result: result)
            completionHandler(dataResponse)
        }
    }

    internal func responseVoid(
        responseToError: ((HTTPURLResponse?, Data?) -> Error?)? = nil,
        completionHandler: @escaping (RestResponse<Void>) -> Void)
    {
        response(parseServiceError: responseToError) { data, response, error in

            guard error == nil else {
                // swiftlint:disable:next force_unwrapping
                let result = RestResult<Void>.failure(error!)
                let dataResponse = RestResponse(request: self.request, response: response, data: data, result: result)
                completionHandler(dataResponse)
                return
            }

            // execute callback
            let result = RestResult<Void>.success(())
            let dataResponse = RestResponse(request: self.request, response: response, data: data, result: result)
            completionHandler(dataResponse)
        }
    }

    internal func download(to destination: URL, completionHandler: @escaping (HTTPURLResponse?, Error?) -> Void) {
        let task = session.downloadTask(with: request) { (source, response, error) in
            guard let source = source else {
                completionHandler(nil, RestError.invalidFile)
                return
            }
            let fileManager = FileManager.default
            do {
                try fileManager.moveItem(at: source, to: destination)
            } catch {
                completionHandler(nil, RestError.fileManagerError)
            }
            completionHandler(response as? HTTPURLResponse, error)
        }
        task.resume()
    }
}

internal struct RestResponse<T> {
    internal let request: URLRequest?
    internal let response: HTTPURLResponse?
    internal let data: Data?
    internal let result: RestResult<T>
}

internal enum RestResult<T> {
    case success(T)
    case failure(Error)
}

internal enum Credentials {
    case apiKey
    case basicAuthentication(username: String, password: String)
}
