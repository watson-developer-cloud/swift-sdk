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

extension PersonalityInsights {
    
    internal struct PersonalityInsightsError: WatsonError {
        var code: Int!
        var error: String!
        var help: String!
        
        var nsError: NSError {
            let domain = Constants.errorDomain
            let userInfo = [NSLocalizedDescriptionKey: self.error,
                            NSLocalizedRecoverySuggestionErrorKey: self.help]
            return NSError(domain: domain, code: code, userInfo: userInfo)
        }
        
        init() {}
        
        init?(_ map: Map) {}
        
        mutating func mapping(map: Map) {
            code  <- map["code"]
            error <- map["error"]
            help  <- map["help"]
        }
    }
}