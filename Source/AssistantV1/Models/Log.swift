/**
 * Copyright IBM Corporation 2019
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

/** Log. */
public struct Log: Codable, Equatable {

    /**
     A request sent to the workspace, including the user input and context.
     */
    public var request: MessageRequest

    /**
     The response sent by the workspace, including the output text, detected intents and entities, and context.
     */
    public var response: MessageResponse

    /**
     A unique identifier for the logged event.
     */
    public var logID: String

    /**
     The timestamp for receipt of the message.
     */
    public var requestTimestamp: String

    /**
     The timestamp for the system response to the message.
     */
    public var responseTimestamp: String

    /**
     The unique identifier of the workspace where the request was made.
     */
    public var workspaceID: String

    /**
     The language of the workspace where the message request was made.
     */
    public var language: String

    // Map each property name to the key that shall be used for encoding/decoding.
    private enum CodingKeys: String, CodingKey {
        case request = "request"
        case response = "response"
        case logID = "log_id"
        case requestTimestamp = "request_timestamp"
        case responseTimestamp = "response_timestamp"
        case workspaceID = "workspace_id"
        case language = "language"
    }

}
