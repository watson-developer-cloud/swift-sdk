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
    private var authMethod: AuthenticationMethod
    private let domain = "com.ibm.watson.developer-cloud.RestKit"
    private let session = URLSession(configuration: URLSessionConfiguration.default)

    /**
     Create a `RestToken`.

     - parameter tokenURL: The URL that shall be used to obtain a token.
     - parameter authMethod: The authenticationMethod that shall be used to obtain a token.
     */
    internal init(tokenURL: String, authMethod: AuthenticationMethod) {
        self.tokenURL = tokenURL
        self.authMethod = authMethod
    }

    /**
     Refresh the authentication token.

     - parameter failure: A function executed if an error occurs.
     - parameter success: A function executed after a new token is retrieved.
     */
    internal func refreshToken(
        failure: ((Error) -> Void)? = nil,
        success: (() -> Void)? = nil)
    {
        let request = RestRequest(
            session: session,
            authMethod: authMethod,
            errorResponseDecoder: errorResponseDecoder,
            method: "GET",
            url: tokenURL,
            headerParameters: [:])

        request.responseString { response in
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
    private func errorResponseDecoder(data: Data, response: HTTPURLResponse) -> NSError {

        // default error description
        let code = response.statusCode
        var userInfo = [NSLocalizedDescriptionKey: "Token authentication failed."]

        // update error description, if available
        do {
            let json = try JSON.decoder.decode([String: JSON].self, from: data)
            if case let .some(.string(description)) = json["description"] {
                userInfo[NSLocalizedDescriptionKey] = description
            }
        } catch { /* no need to catch -- falls back to default description */ }

        return NSError(domain: domain, code: code, userInfo: userInfo)
    }

}
