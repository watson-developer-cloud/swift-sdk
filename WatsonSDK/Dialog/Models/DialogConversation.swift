//
//  DialogConversation.swift
//  WatsonSDK
//
//  Created by Glenn Fisher on 11/22/15.
//  Copyright © 2015 IBM Mobile Innovation Lab. All rights reserved.
//

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