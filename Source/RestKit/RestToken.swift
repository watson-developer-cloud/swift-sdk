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
internal class RestToken {

    internal var token: String?
    internal var isRefreshing = false
    internal var retries = 0

    private var tokenURL: String
    private var credentials: AuthenticationMethod
    private let domain = "com.ibm.watson.developer-cloud.RestKit"

    /**
     Create a `RestToken`.

     - parameter tokenURL: The URL that shall be used to obtain a token.
     - parameter credentials: The credentials that shall be used to obtain a token.
     */
    internal init(tokenURL: String, credentials: AuthenticationMethod) {
        self.tokenURL = tokenURL
        self.credentials = credentials
    }

    /**
     Refresh the authentication token.

     - parameter completionHandler: The completion handler to call when the request is complete.
     */
    internal func refreshToken(completionHandler: @escaping (Error?) -> Void) {
        let request = RestRequest(method: "GET", url: tokenURL, credentials: credentials)
        request.responseString { token, response, error in
            guard error == nil else { completionHandler(error); return }
            guard let token = token else { completionHandler(RestError.noData); return }
            self.token = token
            completionHandler(nil)
        }
    }
}
