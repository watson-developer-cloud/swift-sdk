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
import ObjectMapper

extension Dialog {
    
    // A Dialog profile
    public struct Profile: Mappable {
        
        // The client identifier
        public var clientID: Int?
        
        // The parameters of the profile
        public var parameters: [Parameter]?
        
        public init(clientID: Int? = nil, parameters: [String: String]? = nil) {
            self.clientID = clientID
            if let parameters = parameters {
                var params = [Parameter]()
                for p in parameters {
                    let parameter = Parameter(name: p.0, value: p.1)
                    params.append(parameter)
                }
                self.parameters = params
            }
        }
        
        public init?(_: Map) {}
        
        mutating public func mapping(map: Map) {
            clientID   <- map["client_id"]
            parameters <- map["name_values"]
        }
    }
    
    // A Dialog parameter
    public struct Parameter: Mappable {
        
        // The name of the parameter
        public var name: String?
        
        // The value of the parameter
        public var value: String?
        
        public init(name: String? = nil, value: String? = nil) {
            self.name = name
            self.value = value
        }
        
        public init?(_: Map) {}
        
        mutating public func mapping(map: Map) {
            value <- map["value"]
            name  <- map["name"]
        }
    }
}