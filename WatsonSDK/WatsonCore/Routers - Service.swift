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

/// The superclass for all Watson services.
public class WatsonService {
    
    /// The client's username for the service.
    internal let user: String
    
    /// The client's password for the service.
    internal let password: String
    
    /**
     Initialize a new service with the given credentials.
     
     - parameter user:     The username for the service.
     - parameter password: The password for the service.
     
     - returns: An instantiation of the service.
     */
    init(user: String, password: String) {
        self.user = user
        self.password = password
    }
}

/// The superclass for all Alchemy services.
public class AlchemyService {
    
    /// The client's Alchemy API key credential for the service.
    internal let AlchemyAPIKey: String
    
    /**
     Initialize a new service with the given credentials.

     - parameter AlchemyAPIKey: The API key used to authenticate with the service.
    
     - returns: An instantiation of the service.
     */
    init(AlchemyAPIKey: String) {
        self.AlchemyAPIKey = AlchemyAPIKey
    }
}