/**
 * (C) Copyright IBM Corp. 2020.
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

/**
 Log.
 */
public struct Log: Codable, Equatable {

    /**
     A unique identifier for the logged event.
     */
    public var logID: String

    /**
     A stateful message request formatted for the Watson Assistant service.
     */
    public var request: MessageRequest

    /**
     A response from the Watson Assistant service.
     */
    public var response: MessageResponse

    /**
     Unique identifier of the assistant.
     */
    public var assistantID: String

    /**
     The ID of the session the message was part of.
     */
    public var sessionID: String

    /**
     The unique identifier of the skill that responded to the message.
     */
    public var skillID: String

    /**
     The name of the snapshot (dialog skill version) that responded to the message (for example, `draft`).
     */
    public var snapshot: String

    /**
     The timestamp for receipt of the message.
     */
    public var requestTimestamp: String

    /**
     The timestamp for the system response to the message.
     */
    public var responseTimestamp: String

    /**
     The language of the assistant to which the message request was made.
     */
    public var language: String

    /**
     The customer ID specified for the message, if any.
     */
    public var customerID: String?

    // Map each property name to the key that shall be used for encoding/decoding.
    private enum CodingKeys: String, CodingKey {
        case logID = "log_id"
        case request = "request"
        case response = "response"
        case assistantID = "assistant_id"
        case sessionID = "session_id"
        case skillID = "skill_id"
        case snapshot = "snapshot"
        case requestTimestamp = "request_timestamp"
        case responseTimestamp = "response_timestamp"
        case language = "language"
        case customerID = "customer_id"
    }

}
