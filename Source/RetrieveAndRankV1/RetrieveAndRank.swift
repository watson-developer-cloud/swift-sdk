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
import Alamofire
import Freddy
import RestKit

/**
 
 */
public class RetrieveAndRank {
    private let username: String
    private let password: String
    private let serviceURL: String
    private let userAgent = buildUserAgent("watson-apis-ios-sdk/0.3.1 RetrieveAndRankV1")
    private let domain = "com.ibm.watson.developer-cloud.RetrieveAndRankV1"
    
    /**
     Create a `RetrieveAndRank` object.
     
     - parameter username: The username used to authenticate with the service.
     - parameter password: The password used to authenticate with the service.
     - parameter serviceURL: The base URL to use when contacting the service.
     */
    public init(
        username: String,
        password: String,
        serviceURL: String = "https://gateway.watsonplatform.net/retrieve-and-rank/api")
    {
        self.username = username
        self.password = password
        self.serviceURL = serviceURL
    }
    
    /**
     If the given data represents an error returned by the Retrieve and Rank service, then
     return an NSError with information about the error that occured. Otherwise, return nil.
     
     - parameter data: Raw data returned from the service that may represent an error.
     */
    private func dataToError(data: NSData) -> NSError? {
        do {
            let json = try JSON(data: data)
            let code = try json.int("code")
            let error = try json.string("error")
            let description = try json.string("description")
            let userInfo = [
                NSLocalizedFailureReasonErrorKey: error,
                NSLocalizedRecoverySuggestionErrorKey: description
                ]
            return NSError(domain: domain, code: code, userInfo: userInfo)
        } catch {
            return nil
        }
    }

}
