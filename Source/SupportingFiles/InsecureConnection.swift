/**
 * (C) Copyright IBM Corp. 2018, 2019.
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

#if !os(Linux)
import Foundation

class InsecureConnection {
    /// Allow network requests to a server without verification of the server certificate.
    /// **IMPORTANT**: This should ONLY be used if truly intended, as it is unsafe otherwise.
    static func session() -> URLSession {
        return URLSession(configuration: .default, delegate: AllowInsecureConnectionDelegate(), delegateQueue: nil)
    }
}

/**
 URLSession delegate that is used to bypass SSL certificate verification.

 **IMPORTANT**: This can potentially cause dangerous security breaches, so use only if you are certain that you have taken necessary precautions.
 */
class AllowInsecureConnectionDelegate: NSObject, URLSessionDelegate {
    func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        let credential = URLCredential(trust: challenge.protectionSpace.serverTrust!)
        completionHandler(URLSession.AuthChallengeDisposition.useCredential, credential)
    }
}
#endif
