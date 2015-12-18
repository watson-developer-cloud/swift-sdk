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
    
    // A Dialog conversation response
    public struct ConversationResponse: Mappable {
        
        // The response from the Dialog application
        public var response: [String]?
        
        // The input string that prompted the Dialog application to respond
        public var input: String?
        
        // The conversation identifier
        public var conversationID: Int?
        
        // The confidence associated with the conversation response
        public var confidence: Double?
        
        // The client identifier
        public var clientID: Int?
        
        public init?(_ map: Map) {}
        
        mutating public func mapping(map: Map) {
            response       <- map["response"]
            input          <- map["input"]
            conversationID <- map["conversation_id"]
            confidence     <- map["confidence"]
            clientID       <- map["client_id"]
        }
    }
}