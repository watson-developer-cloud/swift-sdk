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
 *  AuthenticationStrategy is a protocol that all authentication types must implement. Services use
 *  the getToken method internally to obtain a temporary token to use Watson services.
 */
public protocol AuthenticationStrategy {
    
    /**
     <#Description#>
     
     - parameter completionHandler: a callback for when a token has been obtained.
     - parameter error:             an error in token retrieval
     */
    func getToken(completionHandler: (token: String?, error: NSError?)->Void)
    
    /// A Watson token is a generated hexadecimal String
    var token: String? { get }
    
}