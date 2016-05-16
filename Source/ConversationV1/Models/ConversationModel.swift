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
import Freddy

extension Conversation {
    
    /// A Conversation model
    public struct ConversationModel: JSONDecodable {
        
        /// The Conversation workspace application identifier
        public var workspaceID: WorkspaceID?
        
        /// The name of the Conversation application
        public var name: String?
        
        public init(json: JSON) throws {
            workspaceID = try json.string("workspace_id")
            name        = try json.string("name")
        }
    }
}