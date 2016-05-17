/**
 * Copyright IBM Corporation 2016
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 **/
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
