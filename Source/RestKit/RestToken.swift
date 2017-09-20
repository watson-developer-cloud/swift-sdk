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

/**
 A `RestToken` object retrieves, stores, and refreshes an authentication token. The token is
 retrieved at a particular URL using basic authentication credentials (i.e. username and password).
 */
public class RestToken {
    
    public var token: String?
    public var isRefreshing = false
    public var retries = 0
    
    private var tokenURL: String
    private var credentials: Credentials
    private let domain = "com.ibm.watson.developer-cloud.RestKit"
    
    /**
     Create a `RestToken`.
     
     - parameter tokenURL:   The URL that shall be used to obtain a token.
     - parameter username:   The username credential used to obtain a token.
     - parameter password:   The password credential used to obtain a token.
     */
    public init(tokenURL: String, username: String, password: String) {
        self.tokenURL = tokenURL
        self.credentials = Credentials.basicAuthentication(username: username, password: password)
    }
    
    /**
     Refresh the authentication token.

     - parameter failure: A function executed if an error occurs.
     - parameter success: A function executed after a new token is retrieved.
     */
    public func refreshToken(
        failure: ((Error) -> Void)? = nil,
        success: (() -> Void)? = nil)
    {
        let request = RestRequest(
            method: "GET",
            url: tokenURL,
            credentials: credentials,
            headerParameters: [:])
        
        request.responseString(responseToError: responseToError) { response in
            switch response.result {
            case .success(let token):
                self.token = token
                success?()
            case .failure(let error):
                failure?(error)
            }
        }
    }
    
    /**
     Returns an NSError if the response/data represents an error. Otherwise, returns nil.
     
     - parameter response: an http response from the token url
     - parameter data: raw body data from the token url response
     */
    private func responseToError(response: HTTPURLResponse?, data: Data?) -> NSError? {
        
        // fail if no response from token url
        guard let response = response else {
            let description = "Token authentication failed. No response from token url."
            let userInfo = [NSLocalizedDescriptionKey: description]
            return NSError(domain: domain, code: 400, userInfo: userInfo)
        }
        
        // succeed if status code indicates success
        if (200..<300).contains(response.statusCode) {
            return nil
        }
        
        // default error description
        let code = response.statusCode
        var userInfo = [NSLocalizedDescriptionKey: "Token authentication failed."]
        
        // update error description, if available
        if let data = data {
            do {
                let json = try JSON(data: data)
                let description = try json.getString(at: "description")
                userInfo[NSLocalizedDescriptionKey] = description
            } catch { /* no need to catch -- falls back to default description */ }
        }
        
        return NSError(domain: domain, code: code, userInfo: userInfo)
    }

}
