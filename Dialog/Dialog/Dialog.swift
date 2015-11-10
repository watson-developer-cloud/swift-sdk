//
//  Dialog.swift
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
public class Dialog: Service {
    
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
     *  - parameter dialogId: The dialog 
     *  - parameter input: If supplied, the dialog you would like to tell Watson.
     *  - parameter conversationId: If supplied,
     *  - parameter clientId: If supplied,
     *
     *  - returns: A `Conversation`.
     */
    public func converse(let dialogId: String, let input: String?, let conversationId: Int?, let clientId: Int?) -> Conversation {
        
        
    }
    
}