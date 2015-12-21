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
import ObjectMapper

// TODO: make sure the refreshed token is persistent (i.e. inout authStrategy)

/**
 A `WatsonGateway` is used to perform HTTP networking requests to Watson Developer
 Cloud services. The gateway automatically handles token authentication, refreshes
 expired tokens, and parses error responses.
 */
internal class WatsonGateway {
    
    // The shared WatsonGateway singleton.
    internal static let sharedInstance = WatsonGateway()
    
    // The type of cached requests.
    private typealias CachedRequest = Void -> Void
    
    // The collection of cached requests.
    private var cachedRequests = [CachedRequest]()
    
    // The maximum number of authentication retries before returning failure.
    private let maxRetries = 1
    
    // The shared NSURLSession singleton session.
    private let session = NSURLSession.sharedSession()
    
    // Private init to override default init and force clients to use the singleton.
    private init() {}
    
    /**
     Perform an HTTP networking request to the Watson Developer Cloud. The gateway
     internally handles token authentication, refreshing expired tokens, and parsing
     error responses.
     
     - parameter request:           A `WatsonRequest` object that captures all arguments
                                        required to construct the HTTP request.
     - parameter statusCode:        A range of acceptable status codes indicating success.
     - parameter serviceError:      An empty error for the given service that will be
                                        populated if an error is returned.
     - parameter completionHandler: The function that will be executed with the
                                        response from Watson.
     */
    internal func request<Error where Error: Mappable, Error: WatsonError>(
        request: WatsonRequest,
        statusCode acceptableStatusCode: Range<Int> = 200..<300,
        serviceError: Error,
        completionHandler: (NSData?, NSError?) -> Void) {
            
        let cachedRequest = { [weak self] in
            guard let strongSelf = self else {
                let code = -1
                let description = "Internal error. Unable to execute network operation."
                let error = NSError.createWatsonError(code, description: description)
                completionHandler(nil, error)
                return
            }
            strongSelf.request(
                request,
                statusCode: acceptableStatusCode,
                serviceError: serviceError,
                completionHandler: completionHandler)
        }
        
        var authStrategy = request.authStrategy
            
        guard !authStrategy.isRefreshing else {
            cachedRequests.append(cachedRequest)
            return
        }
            
        guard authStrategy.token != nil else {
            cachedRequests.append(cachedRequest)
            authStrategy.isRefreshing = true
            authStrategy.retries++
            authStrategy.refreshToken { [weak self] error in
                authStrategy.isRefreshing = false
                
                guard let strongSelf = self else {
                    let code = -1
                    let description = "Internal error. Unable to execute network operation."
                    let error = NSError.createWatsonError(code, description: description)
                    completionHandler(nil, error)
                    return
                }
                
                guard error == nil else {
                    completionHandler(nil, error)
                    return
                }
                
                let cachedRequestsCopy = strongSelf.cachedRequests
                strongSelf.cachedRequests.removeAll()
                cachedRequestsCopy.forEach { $0() }
            }
            return
        }
            
        let task = session.dataTaskWithRequest(request.URLRequest) {
            [weak self] data, response, error in
            
            guard let strongSelf = self else {
                let code = -1
                let description = "Internal error. Unable to execute network operation."
                let error = NSError.createWatsonError(code, description: description)
                completionHandler(nil, error)
                return
            }
            
            guard let response = response as? NSHTTPURLResponse else {
                completionHandler(nil, error)
                return
            }
            
            switch response.statusCode {
            case acceptableStatusCode:
                authStrategy.retries = 0
                completionHandler(data, nil)
                return
            
            case 401:
                strongSelf.cachedRequests.append(cachedRequest)
                
                guard !authStrategy.isRefreshing else {
                    return
                }
                
                guard authStrategy.retries < strongSelf.maxRetries else {
                    let code = response.statusCode
                    let description = "Response code was unacceptable: \(response.statusCode)"
                    let error = NSError.createWatsonError(code, description: description)
                    completionHandler(nil, error)
                    return
                }
                
                authStrategy.isRefreshing = true
                authStrategy.retries++
                authStrategy.refreshToken { error in
                    authStrategy.isRefreshing = false
                    guard error == nil else {
                        completionHandler(nil, error)
                        return
                    }
                    
                    let cachedRequestsCopy = strongSelf.cachedRequests
                    strongSelf.cachedRequests.removeAll()
                    cachedRequestsCopy.forEach { $0() }
                }
                return
            
            default:
                authStrategy.retries = 0
                if let data = data {
                    let errorString = String(data: data, encoding: NSUTF8StringEncoding)
                    let error = Mapper<Error>().map(errorString)
                    completionHandler(nil, error?.nsError)
                } else {
                    let code = response.statusCode
                    let description = "Response code was unacceptable: \(response.statusCode)"
                    let error = NSError.createWatsonError(code, description: description)
                    completionHandler(nil, error)
                }
                return
            }
        }
        task.resume()
    }
}