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

/**
 Constants used by the Watson Engagement Advisor service.
 */
internal struct ConversationHelperConstants {

    static let ttsServiceURL    = "https://stream.watsonplatform.net/text-to-speech/api"
    static let sttServiceURL    = "https://stream.watsonplatform.net/speech-to-text/api"
    static let dialogServiceURL = "https://gateway.watsonplatform.net/dialog/api/v1"
    static let streamTokenURL   = "https://stream.watsonplatform.net/authorization/api/v1/token"
    static let gatewayTokenURL  = "https://gateway.watsonplatform.net/authorization/api/v1/token"
    
    static func message(workspaceID: String) -> String {
        return "/v2/workspaces/\(workspaceID)/message"
    }
}

