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
import RestKit

/**
 The IBM Watson Discovery service uses data analysis combined with cognitive intuition to take your
 unstructured data and enrich it so you can query it for the information you need.
 */
public class Discovery {

    /// The base URL to use when contacting the service.
    public var serviceURL = "https://gateway.watsonplatform.net/discovery-experimental/api/v1"
    
    /// The default HTTP headers for all requests to the service.
    public var defaultHeaders = [String: String]()
    
    private let credentials: Credentials
    private let domain = "com.ibm.watson.developer-cloud.DiscoveryV1"
    private let version: String
    
    /**
     Create a `Discovery` object.
     
     - parameter username: The username used to authenticate with the service.
     - parameter password: The password used to authenticate with the service.
     - parameter version: The release date of the version of the API to use. Specify the date
            in "YYYY-MM-DD" format.
     */
    public init(username: String, password: String, version: String) {
        self.credentials = Credentials.basicAuthentication(username: username, password: password)
        self.version = version
    }
    
    // MARK: - Environments
    
    /**
     Create an environment for this service instance.
     
     For the experimental release, the size of the environment is fixed at 2GB
     available disk space, and 1GB RAM.
     
     - parameter name: The name of the new environment.
     - parameter description: The description of the new environment.
     - parameter failure: A function executed if an error occurs.
     - parameter success: A function executed with details of the newly created environment.
     */
    public func createEnvironment(
        withName name: String,
        withDescription description: String,
        failure: ((Error) -> Void)? = nil,
        success: @escaping ([Environment]) -> Void)
    {
        // construct body
    }

}
