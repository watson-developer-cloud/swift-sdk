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

public class RestRequest: URLRequestConvertible {

    public static let userAgent: String = {
        let sdk = "watson-apis-ios-sdk"
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
    
    private let method: Alamofire.HTTPMethod
    private let url: String
    private let headerParameters: [String: String]
    private let acceptType: String?
    private let contentType: String?
    private let queryParameters: [URLQueryItem]?
    private let messageBody: Data?
    
    public func asURLRequest() -> URLRequest {
        
        // construct url with query parameters
        let urlComponents = NSURLComponents(string: self.url)!
        if let queryParameters = queryParameters, !queryParameters.isEmpty {
            urlComponents.queryItems = queryParameters
        }
        
        // construct basic mutable request
        var request = URLRequest(url: urlComponents.url!)
        request.httpMethod = method.rawValue
        request.httpBody = messageBody
        
        // set the request's accept type
        if let acceptType = acceptType {
            request.setValue(acceptType, forHTTPHeaderField: "Accept")
        }
        
        // set the request's content type
        if let contentType = contentType {
            request.setValue(contentType, forHTTPHeaderField: "Content-Type")
        }
        
        // set the request's user agent
        request.setValue(RestRequest.userAgent, forHTTPHeaderField: "User-Agent")
        
        // set the request's header parameters
        for (key, value) in headerParameters {
            request.setValue(value, forHTTPHeaderField: key)
        }

        return request
    }

    public init(
        method: Alamofire.HTTPMethod,
        url: String,
        headerParameters: [String: String],
        acceptType: String? = nil,
        contentType: String? = nil,
        queryParameters: [URLQueryItem]? = nil,
        messageBody: Data? = nil)
    {
        self.method = method
        self.url = url
        self.headerParameters = headerParameters
        self.acceptType = acceptType
        self.contentType = contentType
        self.queryParameters = queryParameters
        self.messageBody = messageBody
    }
}
