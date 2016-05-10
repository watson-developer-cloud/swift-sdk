/************************************************************************/
/*                                                                      */
/* IBM Confidential                                                     */
/* OCO Source Materials                                                 */
/*                                                                      */
/* (C) Copyright IBM Corp. 2001, 2016                                   */
/*                                                                      */
/* The source code for this program is not published or otherwise       */
/* divested of its trade secrets, irrespective of what has been         */
/* deposited with the U.S. Copyright Office.                            */
/*                                                                      */
/************************************************************************/

import Foundation

//Struct for Messages
public struct MessageRequest : ConversationRequest {
    
    var input:   AnyObject!
    var context: [String: String]?
    
    init(message: String, tags: [String]? = nil, context: [String: String]? = nil) {
        self.input  = ["text" : message]
        self.context = context
    }
    
    /** Represents the Message as a dictionary */
    func toDictionary() -> [String : AnyObject] {
        var map        = [String: AnyObject]()
        map["input"]   = input
        map["context"] = context
        return map
    }
}