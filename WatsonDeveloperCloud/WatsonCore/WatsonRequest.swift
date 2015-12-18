/**
 * Copyright IBM Corporation 2015
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
 A WatsonRequest object represents a REST request supported by IBM Watson.
 It captures all arguments required to construct an HTTP request message
 and can represent itself as an NSMutableURLRequest for use with Alamofire.
 */
internal class WatsonRequest: URLRequestConvertible {
    
    /// The operation's HTTP method.
    let method: Method
    
    /// The service's URL.
    /// (e.g. "https://gateway.watsonplatform.net/personality-insights/api")
    let serviceURL: String
    
    /// The operation's endpoint. (e.g. "/v2/profile")
    let endpoint: String
    
    /// The authentication strategy for obtaining a token.
    let authStrategy: AuthenticationStrategy
    
    /// The acceptable MediaType of the response.
    let accept: MediaType?
    
    /// The MediaType of the message body.
    let contentType: MediaType?
    
    /// The query parameters to be encoded in the URL.
    let urlParams: [NSURLQueryItem]?
    
    /// A dictionary of parameters to be encoded in the header.
    let headerParams: [String: String]?
    
    /// The data to be included in the message body.
    let messageBody: NSData?
    
    /// A representation of the request as an NSMutableURLRequest.
    var URLRequest: NSMutableURLRequest {
        
        // construct URL
        let urlString = serviceURL + endpoint
        let urlComponents = NSURLComponents(string: urlString)!
        if let urlParams = urlParams {
            if !urlParams.isEmpty {
                urlComponents.queryItems = urlParams
            }
        }
        let url = urlComponents.URL!
        
        // construct mutable base request
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = method.rawValue
        request.HTTPBody = messageBody
        
        // set Watson authentication token
        request.setValue(authStrategy.token, forHTTPHeaderField: "X-Watson-Authorization-Token")
        
        // set accept type of request
        if let accept = accept {
            request.setValue(accept.rawValue, forHTTPHeaderField: "Accept")
        }
        
        // set content type of request
        if let contentType = contentType {
            request.setValue(contentType.rawValue, forHTTPHeaderField: "Content-Type")
        }
        
        // add user header parameters to request
        if let headerParams = headerParams {
            for (key, value) in headerParams {
                request.setValue(value, forHTTPHeaderField: key)
            }
        }
        
        // return request
        return request
    }
    
    /**
     Initialize a new WatsonRequest with the given arguments.
     
     - parameter method:       The operation's HTTP method.
     - parameter serviceURL:   The service's URL.
     - parameter endpoint:     The operation's endpoint. (e.g. "/v2/profile")
     - parameter authStrategy: The authentication strategy for obtaining a token.
     - parameter accept:       The acceptable MediaType for the response.
     - parameter contentType:  The MediaType of the message body.
     - parameter urlParams:    The query parameters to be encoded in the URL.
     - parameter headerParams: A dictionary of parameters to be encoded in the header.
     - parameter messageBody:  The data to be included in the message body.
     
     - returns: A WatsonRequest object for use with Alamofire.
     */
    init(
        method: Method,
        serviceURL: String,
        endpoint: String,
        authStrategy: AuthenticationStrategy,
        accept: MediaType? = nil,
        contentType: MediaType? = nil,
        urlParams: [NSURLQueryItem]? = nil,
        headerParams: [String: String]? = nil,
        messageBody: NSData? = nil) {
            
            self.method = method
            self.serviceURL = serviceURL
            self.endpoint = endpoint
            self.authStrategy = authStrategy
            self.accept = accept
            self.contentType = contentType
            self.urlParams = urlParams
            self.headerParams = headerParams
            self.messageBody = messageBody
    }
}