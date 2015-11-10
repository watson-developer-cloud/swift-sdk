//
//  Conversation.swift
//  Dialog
//
//  Created by Jonathan Ballands on 11/9/15.
//  Copyright © 2015 Watson Developer Cloud. All rights reserved.
//

import Foundation
import ObjectMapper

public class Conversation: Mappable {
    
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
    
    public required init?(_ map: Map) {
        // Nothing to do...
    }
    
    /*
     *  MARK: Mappable
     */
    
    public func mapping(map: Map) {
        
    }
    
}