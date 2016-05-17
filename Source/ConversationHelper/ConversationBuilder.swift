/************************************************************************/
 /*                                                                      */
 /* IBM Confidential                                                     */
 /* OCO Source Materials                                                 */
 /*                                                                      */
 /* (C) Copyright IBM Corp. 2015, 2016                                   */
 /*                                                                      */
 /* The source code for this program is not published or otherwise       */
 /* divested of its trade secrets, irrespective of what has been         */
 /* deposited with the U.S. Copyright Office.                            */
 /*                                                                      */
 /************************************************************************/
import Foundation

// Builder for creating and customizing a Conversation object
public class ConversationBuilder : NSObject {
    
    private var serviceURL = "http://wea-orchestratorv2.mybluemix.net/conversation/"
    private var workspaceID = "defaultID"
    private var username = "defaultDialogUser"
    private var password = "defaultDialogPass"
    
    private var sttUsername = "defaultSTTUser"
    private var sttPassword = "defaultSTTPass"
    
    private var ttsUsername = "defaultTTSUser"
    private var ttsPassword = "defaultTTSPass"
    
    /**
     Sets the dialog service path and workspace
     
     - parameter dialogPath: The path for the dialog service instance.
     - parameter workspaceId: The workspace within the dialog service you want to use.
     */
    public func dialogPath(path: String, workspaceId: String) {
        self.serviceURL = path
        self.workspaceID = workspaceId
    }
    
    /**
     Sets the credentials for the dialog service
     
     - parameter username: The username for the dialog service.
     - parameter password: The password for the dialog service.
     */
    public func dialogCredentials(username: String, password: String) {
        self.username = username
        self.password = password
    }
    

    
    /**
     Sets the credentials for the Text to Speech service
     
     - parameter username: The username for the Text to Speech service.
     - parameter password: The password for the Text to Speech service.
     */
    public func sttCredentials(username: String, password: String) {
        self.sttUsername = username
        self.sttPassword = password
    }
    
    /**
     Sets the credentials for the Speech to Text service
     
     - parameter username: The username for the Speech to Text service.
     - parameter password: The password for the Speech to Text service.
     */
    public func ttsCredentials(username: String, password: String) {
        self.ttsUsername = username
        self.ttsPassword = password
    }
    
    /**
     Builds and returns a Conversation object
     */
    public func build() -> ConversationHelper {
        
        let conversationService = Conversation(username: username, password: password)
        
        let speechToTextService = ConversationSpeechToTextService(username: sttUsername, password: sttPassword)
        let synthesizeService   = ConversationSynthesizeService(username: ttsUsername, password: ttsPassword)
        
        let builtConversation   = ConversationHelper(conversationService: conversationService, speechToTextService: speechToTextService, synthesizeService: synthesizeService)
        return builtConversation
    }
}