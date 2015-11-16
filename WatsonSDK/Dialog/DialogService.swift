//
//  Dialog.swift
//  Dialog
//
//  Created by Jonathan Ballands on 11/9/15.
//  Copyright © 2015 Watson Developer Cloud. All rights reserved.
//

import Foundation
import ObjectMapper

/**
 *  Constants for the `DialogService`.
 */
private struct DialogServiceConstants {
    
    static let clientId = "client_id"
    
    static let conversationId = "conversation_id"
    
    static let dialogId = "dialog_id"
    
    static let input = "input"
    
    static let dateFrom = "date_from"
    
    static let dateTo = "date_to"

    static let limit = "limit"
    
    static let offset = "offset"
    
    static let nameValues = "name_values"
}

/**
 *  The IBM Watson Dialog service provides a comprehensive, robust,
 *  platform for managing conversations between virtual agents and
 *  users. These conversations are commonly referred to as `Dialog`s.
 */
public class DialogService: Service {
    
    /*
     *  MARK: Properties
     */
    
    private let serviceURL = "/dialog/api"
    
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
    public func converse(let dialogId: String, let input: String? = nil, let conversationId: Int? = nil, let clientId: Int? = nil, callback: (Conversation?) -> Void) {
        
        // Don't allow empty a dialogId
        guard (dialogId.characters.count > 0) else {
            print("dialogId can not be empty")
            callback(nil)
            return
        }
        
        // Report when a new conversationId and/or clientId is being created
        if (conversationId == nil) {
            print("Creating a new conversationId for dialog: \(dialogId)")
        }
        if (clientId == nil) {
            print("Creating a new clientId for dialog: \(dialogId)")
        }
        
        // Prepare for the API call
        let endpoint = self.getEndpoint("/v1/dialogs/\(dialogId)/conversation")
        var params = Dictionary<String, AnyObject>()
        
        if let convoId = conversationId {
            params.updateValue(convoId, forKey: DialogServiceConstants.conversationId)
        }
        if let cliId = clientId {
            params.updateValue(cliId, forKey: DialogServiceConstants.clientId)
        }
        if let inp = input {
            params.updateValue(inp, forKey: DialogServiceConstants.input)
        }
        
        // Perform the API call
        NetworkUtils.performBasicAuthRequest(endpoint, method: .POST, parameters: params, apiKey: self._apiKey, completionHandler: { response in
            
            if let data = response.data as? Dictionary<String, AnyObject> {
                if let conversation =  Mapper<Conversation>().map(data) {
                    callback(conversation)
                } else {
                    callback(nil)
                }
            } else {
                callback(nil)
            }
        })
    }
    
    /**
     *  Create a conversation with Watson.
     *
     *  - parameter dialogId: The ID of the dialog XML in the Dialog service.
     *
     *  - returns: A `Conversation` object.
     */
    public func createConversation(let dialogId: String, callback: (Conversation?) -> Void) {
        return self.converse(dialogId, callback: callback)
    }
    
    /**
     *  Create a dialog for Watson.
     *
     *  - parameter name: Param 1
     *  - parameter dialogFile: Param 2
     *
     *  - returns: A `Dialog` object.
     */
    /*public func createDialog(let name: String, let dialogFile: NSURL) -> Dialog {
        
    }*/
    
    /**
     *  Delete a dialog from Watson.
     *
     *  - parameter dialogId: The ID of the dialog XML in the Dialog service.
     */
    /*public func deleteDialog(let dialogId: String) {
        
    }*/
    
}