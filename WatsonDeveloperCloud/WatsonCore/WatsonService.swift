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

// The `WatsonService` protocol enforces consistency among all Watson services.
internal protocol WatsonService {
    
    // The shared WatsonGateway singleton.
    var gateway: WatsonGateway { get }
    
    // The authentication strategy to obtain authorization tokens.
    var authStrategy: AuthenticationStrategy { get }
    
    init(authStrategy: AuthenticationStrategy)
    init(username: String, password: String)

}