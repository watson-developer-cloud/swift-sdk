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
 An `APIKeyAuthenticationStrategy` captures all information necessary to authenticate
 with a Watson Developer Cloud service using an API key. This pattern is required for
 all Alchemy services. The `APIKeyAuthenticationStrategy` is used internally to obtain
 the API key and maintain associated state information.
 */
public class APIKeyAuthenticationStrategy: AuthenticationStrategy {
    
    // The token that shall be used to authenticate with Watson.
    public var token: String?
    
    // Is the token currently being refreshed?
    public var isRefreshing = false
    
    // The number of times the network manager has tried refreshing the token.
    public var retries = 0
    
    // The API key used to authenticate with a Watson Alchemy service.
    private var apiKey: String!
    
    /**
     Authenticate with a Watson Developer Cloud service using an API key.
    
     - parameter apiKey: The API kay that shall be used to authenticate with the service.
     */
    public init(apiKey: String) {
        self.apiKey = apiKey
        self.token = apiKey
    }
    
    /**
     Ensure that the API key provided on initialization is still used as the token.
     
     - parameter completionHandler: The function executed after updating the token.
     */
    public func refreshToken(completionHandler: NSError? -> Void) {
        self.token = self.apiKey
        completionHandler(nil)
    }
    
}