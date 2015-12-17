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
    
    // A Dialog conversation
    public struct Conversation: Mappable {

        // The nodes that were executed by the conversation
        var hitNodes: [HitNode]?
        
        // The conversation identifier
        var conversationID: Int?
        
        // The client identifier
        var clientID: Int?
        
        // The messages exchanged during the conversation
        var messages: [Message]?
        
        // The profile variables associated with the conversation
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
    
    // A Dialog hit node
    public struct HitNode: Mappable {
        
        // The details of the node
        var details: String?
        
        // The label of the node
        var label: String?
        
        // The type of the node
        var type: String?
        
        // The node identifier
        var nodeID: Int?
        
        public init?(_ map: Map) {}
        
        mutating public func mapping(map: Map) {
            details <- map["details"]
            label   <- map["label"]
            type    <- map["type"]
            nodeID  <- map["node_id"]
        }
    }
    
    // A Dialog message
    public struct Message: Mappable {
        
        // The text of the message
        var text: String?
        
        // The date and time of the message
        var dateTime: NSDate?
        
        // The client that prompted the message to be sent
        var fromClient: String?
        
        public init?(_ map: Map) {}
        
        mutating public func mapping(map: Map) {
            text       <-  map["text"]
            dateTime   <- (map["date_time"], ISO8601DateTransform())
            fromClient <-  map["from_client"]
        }
    }
}