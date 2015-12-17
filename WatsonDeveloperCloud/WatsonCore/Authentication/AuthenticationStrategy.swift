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
 An `AuthenticationStrategy` captures all information necessary to authenticate with a
 Watson Developer Cloud service. The `AuthenticationStrategy` is used internally to
 obtain tokens, refresh expired tokens, and maintain associated state information.
 */
public protocol AuthenticationStrategy {
    
    // The token that shall be used to authenticate with Watson.
    var token: String? { get set }
    
    // Is the token currently being refreshed?
    var isRefreshing: Bool { get set }
    
    // The number of times the network manager has tried refreshing the token.
    var retries: Int { get set }
    
    // Refresh the `AuthenticationStrategy`'s token.
    mutating func refreshToken(completionHandler: NSError? -> Void)
    
}