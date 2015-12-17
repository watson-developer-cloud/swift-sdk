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
    
    public struct Conversation: Mappable {

        var hitNodes: [HitNode]?
        var conversationID: Int?
        var clientID: Int?
        var messages: [Message]?
        var profile: [String: String]?
        
        public init?(_ map: Map) {}
        
        mutating public func mapping(map: Map) {
            hitNodes       <- map["hit_nodes"]
            conversationID <- map["conversation_id"]
            clientID       <- map["client_id"]
            messages       <- map["messages"]
            profile        <- map["profile"]
        }
    }
    
    public struct HitNode: Mappable {
        
        var details: String?
        var label: String?
        var type: String?
        var nodeID: Int?
        
        public init?(_ map: Map) {}
        
        mutating public func mapping(map: Map) {
            details <- map["details"]
            label   <- map["label"]
            type    <- map["type"]
            nodeID  <- map["node_id"]
        }
    }
    
    public struct Message: Mappable {
        
        var text: String?
        var dateTime: NSDate?
        var fromClient: String?
        
        public init?(_ map: Map) {}
        
        mutating public func mapping(map: Map) {
            text       <-  map["text"]
            dateTime   <- (map["date_time"], ISO8601DateTransform())
            fromClient <-  map["from_client"]
        }
    }
}