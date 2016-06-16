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

/**
 A `RestRequest` object represents a REST request to a remote server.
 
 The `RestRequest` object captures all common arguments required to construct
 an HTTP request message and can also represent itself as an `NSMutableURLRequest`
 for use with `NSURLSession` or `Alamofire`.
 */
public class RestRequest: URLRequestConvertible {

    private let method: Alamofire.Method
    private let url: String
    private let acceptType: String?
    private let contentType: String?
    private let userAgent: String?
    private let queryParameters: [NSURLQueryItem]?
    private let headerParameters: [String: String]?
    private let messageBody: NSData?

    /// A representation of the request as an `NSMutableURLRequest`.
    public var URLRequest: NSMutableURLRequest {
        
        // construct url with query parameters
        let urlComponents = NSURLComponents(string: self.url)!
        if let queryParameters = queryParameters where !queryParameters.isEmpty {
            urlComponents.queryItems = queryParameters
        }
        
        // construct basic mutable request
        let request = NSMutableURLRequest(URL: urlComponents.URL!)
        request.HTTPMethod = method.rawValue
        request.HTTPBody = messageBody
        
        // set the request's accept type
        if let acceptType = acceptType {
            request.setValue(acceptType, forHTTPHeaderField: "Accept")
        }
        
        // set the request's content type
        if let contentType = contentType {
            request.setValue(contentType, forHTTPHeaderField: "Content-Type")
        }
        
        // set the request's user agent
        if let userAgent = userAgent {
            request.setValue(userAgent, forHTTPHeaderField: "User-Agent")
        }
        
        // set the request's header parameters
        if let headerParameters = headerParameters {
            for (key, value) in headerParameters {
                request.setValue(value, forHTTPHeaderField: key)
            }
        }

        return request
    }

    /**
     Initialize a `RestRequest` that represents a REST request to a remote server.
 
     - parameter method: The HTTP method of the request.
     - parameter url: The url of the request.
     - parameter acceptType: The acceptable media type of the response's message body.
     - parameter contentType: The media type of the request's message body.
     - parameter userAgent: A custom user-agent string that should be used for the request.
     - parameter queryParameters: The parameters to encode in the url's query string.
     - parameter headerParameters: The parameters to encode in the request's HTTP header.
     - parameter messageBody: The data to be included in the message body.
 
     - returns: A `RestRequest` object that represent the REST request to a remote server.
     */
    public init(
        method: Alamofire.Method,
        url: String,
        acceptType: String? = nil,
        contentType: String? = nil,
        userAgent: String? = nil,
        queryParameters: [NSURLQueryItem]? = nil,
        headerParameters: [String: String]? = nil,
        messageBody: NSData? = nil)
    {
        self.method = method
        self.url = url
        self.acceptType = acceptType
        self.contentType = contentType
        self.userAgent = userAgent
        self.queryParameters = queryParameters
        self.headerParameters = headerParameters
        self.messageBody = messageBody
    }
}
