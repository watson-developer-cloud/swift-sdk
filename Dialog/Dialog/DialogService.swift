//
//  DialogService.swift
//  Dialog
//
//  Created by Jonathan Ballands on 11/9/15.
//  Copyright © 2015 Watson Developer Cloud. All rights reserved.
//

import Foundation
import WatsonCore

/**
 *
 */
public class DialogService: Service {
    
    /*
     *  MARK: Properties
     */
    
    private let serviceURL = "dialog/api"
    
    /*
     *  MARK: Lifecycle
     */
    
    init() {
        super.init(serviceURL: self.serviceURL)
    }
    
    /*
     *  MARK: API
     */
    
    /**
     *  Start a new conversation with Watson or continue an existing one.
     *
     *  - parameter dialogId: The ID of the dialog XML in the Dialog service.
     *  - parameter input: If supplied, the dialog you would like to tell Watson.
     *  - parameter conversationId: If supplied, the ID of the conversation you would like
     8  to continue.
     *  - parameter clientId: If supplied, the ID of the client that is having the conversation.
     *
     *  - returns: A `Conversation` object.
     */
    public func converse(let dialogId: String, let input: String? = nil, let conversationId: Int? = nil, let clientId: Int? = nil) -> Conversation {
        
        
    }
    
    /**
     *  Create a conversation with Watson.
     *
     *  - parameter dialogId: The ID of the dialog XML in the Dialog service.
     *
     *  - returns: A `Conversation` object.
     */
    public func createConversation(let dialogId: String) -> Conversation {
        return self.converse(dialogId)
    }
    
    /**
     *  Create a dialog for Watson.
     *
     *  - parameter name: Param 1
     *  - parameter dialogFile: Param 2
     *
     *  - returns: A `Dialog` object.
     */
    public func createDialog(let name: String, let dialogFile: NSURL) -> Dialog {
        
    }
    
    /**
     *  Delete a dialog from Watson.
     *
     *  - parameter dialogId: Param 1
     */
    public func deleteDialog(let dialogId: String) {
        
    }
    
}