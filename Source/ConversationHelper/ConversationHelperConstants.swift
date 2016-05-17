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
