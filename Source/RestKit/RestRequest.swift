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
        let sdkVersion = "0.29.0"

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
            // swiftlint:disable:next identifier_name
            let os = ProcessInfo.processInfo.operatingSystemVersion
            return "\(os.majorVersion).\(os.minorVersion).\(os.patchVersion)"
        }()
        return "\(sdk)/\(sdkVersion) \(operatingSystem)/\(operatingSystemVersion)"
    }()

    private let session: URLSession
    internal var authMethod: AuthenticationMethod
    internal var errorResponseDecoder: ((Data, HTTPURLResponse) -> Error)
    internal var method: String
    internal var url: String
    internal var headerParameters: [String: String]
    internal var queryItems: [URLQueryItem]
    internal var messageBody: Data?

    internal init(
        session: URLSession,
        authMethod: AuthenticationMethod,
        errorResponseDecoder: @escaping ((Data, HTTPURLResponse) -> Error),
        method: String,
        url: String,
        headerParameters: [String: String],
        queryItems: [URLQueryItem]? = nil,
        messageBody: Data? = nil)
    {
        self.session = session
        self.authMethod = authMethod
        self.errorResponseDecoder = errorResponseDecoder
        self.method = method
        self.url = url
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
     Execute this request. (This is the main response function and is called by many of the functions below.)

     - completionHandler: The completion handler to call when the request is complete.
     */
    internal func response(
        completionHandler: @escaping (Data?, HTTPURLResponse?, Error?) -> Void)
    {
        // add authentication credentials to the request
        authMethod.authenticate(request: self) { request, error in

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
                    if let data = data {
                        let serviceError = self.errorResponseDecoder(data, response)
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
     Execute this request and process the response body as raw data.

     - completionHandler: The completion handler to call when the request is complete.
     */
    internal func responseData(
        completionHandler: @escaping (RestResponse<Data>) -> Void)
    {
        // execute the request
        response { data, response, error in

            // ensure there is no underlying error
            guard error == nil else {
                // swiftlint:disable:next force_unwrapping
                let result = RestResult<Data>.failure(error!)
                let dataResponse = RestResponse(response: response, data: data, result: result)
                completionHandler(dataResponse)
                return
            }

            // ensure there is data to parse
            guard let data = data else {
                let result = RestResult<Data>.failure(RestError.noData)
                let dataResponse = RestResponse(response: response, data: nil, result: result)
                completionHandler(dataResponse)
                return
            }

            // execute completion handler
            let result = RestResult.success(data)
            let dataResponse = RestResponse(response: response, data: data, result: result)
            completionHandler(dataResponse)
        }
    }

    /**
     Execute this request and process the response body as a JSON object.

     - completionHandler: The completion handler to call when the request is complete.
     */
    internal func responseObject<T: Decodable>(
        completionHandler: @escaping (RestResponse<T>) -> Void)
    {
        // execute the request
        response { data, response, error in

            // ensure there is no underlying error
            guard error == nil else {
                // swiftlint:disable:next force_unwrapping
                let result = RestResult<T>.failure(error!)
                let dataResponse = RestResponse(response: response, data: data, result: result)
                completionHandler(dataResponse)
                return
            }

            // ensure there is data to parse
            guard let data = data else {
                let result = RestResult<T>.failure(RestError.noData)
                let dataResponse = RestResponse(response: response, data: nil, result: result)
                completionHandler(dataResponse)
                return
            }

            // parse json object
            let result: RestResult<T>
            do {
                let object = try JSON.decoder.decode(T.self, from: data)
                result = .success(object)
            } catch {
                result = .failure(error)
            }

            // execute completion handler
            let dataResponse = RestResponse(response: response, data: data, result: result)
            completionHandler(dataResponse)
        }
    }

    /**
     Execute this request and process the response body as a string.

     - completionHandler: The completion handler to call when the request is complete.
     */
    internal func responseString(
        completionHandler: @escaping (RestResponse<String>) -> Void)
    {
        // execute the request
        response { data, response, error in

            // ensure there is no underlying error
            guard error == nil else {
                // swiftlint:disable:next force_unwrapping
                let result = RestResult<String>.failure(error!)
                let dataResponse = RestResponse(response: response, data: data, result: result)
                completionHandler(dataResponse)
                return
            }

            // ensure there is data to parse
            guard let data = data else {
                let result = RestResult<String>.failure(RestError.noData)
                let dataResponse = RestResponse(response: response, data: nil, result: result)
                completionHandler(dataResponse)
                return
            }

            // parse data as a string
            guard let string = String(data: data, encoding: .utf8) else {
                let result = RestResult<String>.failure(RestError.serializationError)
                let dataResponse = RestResponse(response: response, data: nil, result: result)
                completionHandler(dataResponse)
                return
            }

            // execute completion handler
            let result = RestResult.success(string)
            let dataResponse = RestResponse(response: response, data: data, result: result)
            completionHandler(dataResponse)
        }
    }

    /**
     Execute this request and ignore any response body.

     - completionHandler: The completion handler to call when the request is complete.
     */
    internal func responseVoid(
        completionHandler: @escaping (RestResponse<Void>) -> Void)
    {
        // execute the request
        response { data, response, error in

            // ensure there is no underlying error
            guard error == nil else {
                // swiftlint:disable:next force_unwrapping
                let result = RestResult<Void>.failure(error!)
                let dataResponse = RestResponse(response: response, data: data, result: result)
                completionHandler(dataResponse)
                return
            }

            // execute completion handler
            let result = RestResult<Void>.success(())
            let dataResponse = RestResponse(response: response, data: data, result: result)
            completionHandler(dataResponse)
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
        authMethod.authenticate(request: self) { request, error in

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

internal struct RestResponse<T> {
    internal let response: HTTPURLResponse?
    internal let data: Data?
    internal let result: RestResult<T>
}

internal enum RestResult<T> {
    case success(T)
    case failure(Error)
}
