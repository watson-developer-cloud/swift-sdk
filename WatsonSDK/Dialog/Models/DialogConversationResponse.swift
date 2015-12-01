//
//  DialogConversationResponse.swift
//  WatsonSDK
//
//  Created by Glenn Fisher on 11/23/15.
//  Copyright © 2015 IBM Mobile Innovation Lab. All rights reserved.
//

import Foundation
import ObjectMapper

extension Dialog {
    
    public struct ConversationResponse: Mappable {
        
        var response: [String]?
        var input: String?
        var conversationID: Int?
        var confidence: Double?
        var clientID: Int?
        
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