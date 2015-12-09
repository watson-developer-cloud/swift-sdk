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
Watson service types

- Streaming: Watson services using streaming, i.e. Text to Speech and Speech to Text
- Standard: Other Watson services written by IBM team
- Alchemy: Alchemy Watson services
*/
public enum ServiceType: String {
    case Streaming = "stream.watsonplatform.net"
    case Standard = "gateway.watsonplatform.net"
    case Alchemy = "gateway-a.watsonplatform.net"
}

/// Superclass for all Watson services
public class Service : NSObject {
    /// All services must use https protocol for security
    private let _protocol = "https"
    /// Host for the service (e.g. stream.watsonplatform.net)
    private let _host: String
    /// Service prefix that goes after host and before a specific operation (e.g. /personalityinsights/api)
    private let _serviceURL: String
    /// API Key for the service
    var _apiKey: String!
    
    /**
     Construct an endpoint URL for a Watson operation
     
     - parameter path: A path to a specific operation URL
     
     - returns: Full service URL that contains host, service, and operation
     */
    public func getEndpoint(path:String) -> String {
        let endpoint = _protocol + "://" + _host + _serviceURL + path
        Log.sharedLogger.info("\(endpoint)")
        return endpoint
    }
    
    /**
     Initialize a service
     
     - parameter type:       Service type (Alchemy, Standard, or Streaming). Defaults to Standard.
     - parameter serviceURL: Service prefix
     */
    public init(type:ServiceType = ServiceType.Standard, serviceURL:String)
    {
        _host = type.rawValue
        _serviceURL = serviceURL
    }
    
    /**
     Convenience initializer for Alchemy services using an API key
     
     - parameter type:       Service type (Alchemy, Standard, or Streaming). Defaults to Standard.
     - parameter serviceURL: Service prefix
     - parameter apiKey:     API Key for authentication
     */
    public convenience init(type:ServiceType = ServiceType.Standard, serviceURL:String, apiKey:String)
    {
        self.init(type:type, serviceURL:serviceURL)
        _apiKey = apiKey
    }
    
    /**
     Convenience initializer for Watson services using a username and password
     
     - parameter type:       Service type (Alchemy, Standard, or Streaming). Defaults to Standard.
     - parameter serviceURL: Service prefix
     - parameter username:     Username for authentication
     - parameter password:     Password for authentication
     */
    public convenience init(type:ServiceType = ServiceType.Standard, serviceURL:String, username:String, password:String)
    {
        self.init(type:type, serviceURL:serviceURL)
        setUsernameAndPassword(username, password:password)
    }
    
    /**
    Sets the username and password on the service for invocation. Combines both together into an API Key.
    
    - parameter username: username
    - parameter password: password
    */
    public func setUsernameAndPassword(username:String, password:String)
    {
        let authorizationString = username + ":" + password
        _apiKey = "Basic " + (authorizationString.dataUsingEncoding(NSASCIIStringEncoding)?.base64EncodedStringWithOptions(NSDataBase64EncodingOptions.Encoding76CharacterLineLength))!
    }
}