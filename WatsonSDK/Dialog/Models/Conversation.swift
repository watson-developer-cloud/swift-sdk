//
//  Conversation.swift
//  Dialog
//
//  Created by Jonathan Ballands on 11/9/15.
//  Copyright © 2015 Watson Developer Cloud. All rights reserved.
//

import Foundation
import ObjectMapper

public struct Conversation: Mappable {
    
    /*
     *  MARK: Properties
     */
    
    var clientId: Int?
    var conversationId: Int?
    var input: String?
    var confidence: Double?
    var response: [String]?
    
    /*
     *  MARK: Lifecycle
     */
    
    public init?(_ map: Map) {
        // Nothing to do...
    }
    
    /*
     *  MARK: Mappable
     */
    
    public mutating func mapping(map: Map) {
        clientId            <- map["client_id"]
        conversationId      <- map["conversation_id"]
        input               <- map["input"]
        confidence          <- map["confidence"]
        response            <- map["response"]
    }
    
}