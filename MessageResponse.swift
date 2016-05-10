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
import ObjectMapper

extension Conversation {
    
    /// A Dialog conversation response
    public struct MessageResponse: Mappable {
        
        /// The response from the Dialog application
        public var tags:    [String]?
        
        // Context, or state, from the Conversation system
        public var context: [String: String]?
        
        // Output, or response, from the system 
        public var output:  [String: AnyObject]?
        
        // List of intents
        public var intents: [AnyObject]?
        
        /// Used internally to initialize a `ConversationResponse` from JSON.
        public init?(_ map: Map) {}
        
        /// Used internally to serialize and deserialize JSON.
        mutating public func mapping(map: Map) {
            tags    <- map["tags"]
            context <- map["context"]
            output  <- map["output"]
        }
    }
}