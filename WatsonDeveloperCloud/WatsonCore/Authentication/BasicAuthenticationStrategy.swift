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

/**
 A `BasicAuthenticationStrategy` captures all information necessary to authenticate
 with a Watson Developer Cloud service using HTTP basic authentication to obtain tokens.
 The `BasicAuthenticationStrategy` is used internally to obtain tokens, refresh expired
 tokens, and maintain associated state information.
 */
public class BasicAuthenticationStrategy: NSObject, AuthenticationStrategy,
    NSURLSessionTaskDelegate {
    
    // The token that shall be used to authenticate with Watson.
    public var token: String?
    
    // Is the token currently being refreshed?
    public var isRefreshing = false
    
    // The number of times the network manager has tried refreshing the token.
    public var retries = 0
    
    // The URL of the endpoint used to obtain a token for the given service.
    private let tokenURL: String
    
    // The URL of the given service, passed as a parameter to the token URL endpoint.
    private let serviceURL: String
    
    // The username credential associated with the Watson Developer Cloud service.
    private let username: String
    
    // The password credential associated with the Watson Developer Cloud service.
    private let password: String
    
    /**
     Authenticate with a Watson Developer Cloud service using HTTP basic authentication.
     
     Basic authentication is used to obtain and refresh temporary authorization tokens
     for a Watson Developer Cloud service. The token is then used internally to
     authenticate with the service.
     
     - parameter tokenURL:   The URL of the endpoint used to obtain a token for the service.
     - parameter serviceURL: The URL of the service.
     - parameter username:   The username associated with the service.
     - parameter password:   The password associated with the service.
     */
    public init(tokenURL: String, serviceURL: String, username: String, password: String) {
        self.username = username
        self.password = password
        self.tokenURL = tokenURL
        self.serviceURL = serviceURL
    }
    
    /**
     Refresh the token using the Watson token generator with HTTP basic authentication.
     
     - parameter completionHandler: The function executed after receiving a response.
     */
    public func refreshToken(completionHandler: NSError? -> Void) {
        
        let urlComponents = NSURLComponents(string: tokenURL)
        urlComponents?.queryItems = [NSURLQueryItem(name: "url", value: serviceURL)]
        guard let url = urlComponents?.URL else {
            let code = -1
            let description = "Unable to construct URL."
            let error = NSError.createWatsonError(code, description: description)
            completionHandler(error)
            return
        }
        
        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        let session = NSURLSession(configuration: config, delegate: self, delegateQueue: nil)
        let task = session.dataTaskWithURL(url) { data, response, error in
            guard let response = response as? NSHTTPURLResponse else {
                completionHandler(error)
                return
            }
            
            switch response.statusCode {
            case 200:
                guard let data = data else {
                    let code = -1
                    let description = "Expected token data to be received from server."
                    let error = NSError.createWatsonError(code, description: description)
                    completionHandler(error)
                    return
                }
                self.token = String(data: data, encoding: NSUTF8StringEncoding)
                completionHandler(nil)
                return
            case 401:
                let code = response.statusCode
                let description = "Response code was unacceptable: \(response.statusCode)"
                let error = NSError.createWatsonError(code, description: description)
                completionHandler(error)
                return
            default:
                let code = response.statusCode
                let description = "Response code was unacceptable: \(response.statusCode)"
                let error = NSError.createWatsonError(code, description: description)
                completionHandler(error)
                return
            }
        }
        task.resume()
    }
    
    /**
     Respond to a request for HTTP basic authentication credentials.
    
     - parameter session: The session containing the task whose request requires authentication.
     - parameter task: The task whose request requires authentication.
     - parameter challenge: An object that contains the request for authentication.
     - parameter completionHandler: A handler that your delegate method must call.
     */
    public func URLSession(
        session: NSURLSession,
        task: NSURLSessionTask,
        didReceiveChallenge challenge: NSURLAuthenticationChallenge,
        completionHandler: (NSURLSessionAuthChallengeDisposition, NSURLCredential?) -> Void) {
            
        guard challenge.previousFailureCount == 0 else {
            completionHandler(.CancelAuthenticationChallenge, nil)
            return
        }
            
        let credential = NSURLCredential(user: username, password: password,
            persistence: .None)
        completionHandler(.UseCredential, credential)
    }
}