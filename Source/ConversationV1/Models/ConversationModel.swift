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
    
    /// A collection of Conversation models
    internal struct ConversationModelCollection: Mappable {
        
        /// The Conversation models
        var dialogs: [ConversationModel]?
        
        /// Used internally to initialize a `ConversationModelCollection` from JSON.
        init?(_ map: Map) {}
        
        /// Used internally to serialize and deserialize JSON.
        mutating func mapping(map: Map) {
            dialogs <- map["conversations"]
        }
    }
    
    /// A WorkspaceID uniquely identifies a Conversation application
    public typealias WorkspaceID = String
    
    /// A Conversation model
    public struct ConversationModel: Mappable {
        
        /// The Conversation workspace application identifier
        public var workspaceID: WorkspaceID?
        
        /// The name of the Conversation application
        public var name: String?
        
        /// Used internally to initialize a `ConversationModel` from JSON.
        public init?(_ map: Map) {}
        
        /// Used internally to serialize and deserialize JSON.
        public mutating func mapping(map: Map) {
            workspaceID <- map["workspace_id"]
            name        <- map["name"]
        }
    }
    
    /// A Workspace model identifier
    internal struct WorkspaceIDModel: Mappable {
        
        /// The workspace identifier
        var id: WorkspaceID?
        
        /// Used internally to initialize a `WorkspaceIDModel` from JSON.
        init?(_ map: Map) {}
        
        /// Used internally to serialize and deserialize JSON.
        mutating func mapping(map: Map) {
            id <- map["workspace_id"]
        }
    }
}