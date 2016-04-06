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
    
    /// A Dialog conversation
    public struct Conversation: Mappable {

        /// The nodes that were executed by the conversation
        public var hitNodes: [HitNode]?
        
        /// The conversation identifier
        public var conversationID: Int?
        
        /// The client identifier
        public var clientID: Int?
        
        /// The messages exchanged during the conversation
        public var messages: [Message]?
        
        /// The profile variables associated with the conversation
        public var profile: [String: String]?

        /// Used internally to initialize a `Conversation` from JSON.
        public init?(_ map: Map) {}

        /// Used internally to serialize and deserialize JSON.
        mutating public func mapping(map: Map) {
            hitNodes       <- map["hit_nodes"]
            conversationID <- map["conversation_id"]
            clientID       <- map["client_id"]
            messages       <- map["messages"]
            profile        <- map["profile"]
        }
    }
    
    /// A Dialog hit node
    public struct HitNode: Mappable {
        
        /// The details of the node
        public var details: String?
        
        /// The label of the node
        public var label: String?
        
        /// The type of the node
        public var type: String?
        
        /// The node identifier
        public var nodeID: Int?

        /// Used internally to initialize a `HitNode` from JSON.
        public init?(_ map: Map) {}

        /// Used internally to serialize and deserialize JSON.
        mutating public func mapping(map: Map) {
            details <- map["details"]
            label   <- map["label"]
            type    <- map["type"]
            nodeID  <- map["node_id"]
        }
    }
    
    /// A Dialog message
    public struct Message: Mappable {
        
        /// The text of the message
        public var text: String?
        
        /// The date and time of the message
        public var dateTime: NSDate?
        
        /// The client that prompted the message to be sent
        public var fromClient: String?

        /// Used internally to initialize a `Message` from JSON.
        public init?(_ map: Map) {}

        /// Used internally to serialize and deserialize JSON.
        mutating public func mapping(map: Map) {
            text       <-  map["text"]
            dateTime   <- (map["date_time"], ISO8601DateTransform())
            fromClient <-  map["from_client"]
        }
    }
}