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

extension Conversation {
    
    internal struct Constants {
        
        static let serviceURL = "https://gateway.watsonplatform.net/conversation/api"
        static let tokenURL = "https://gateway.watsonplatform.net/conversation/api/v1/token"
        static let errorDoman = "com.watsonplatform.conversation"
        
        // MARK: Content Operations
        static func message(workspaceID: WorkspaceID) -> String {
            return "/v1/workspaces/\(workspaceID)/message"
        }
    }
}