/**
 * Copyright IBM Corporation 2017
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

/** LogExport. */
public struct LogExport {

    /// A request formatted for the Conversation service.
    public var request: MessageRequest

    /// A response from the Conversation service.
    public var response: MessageResponse

    /// A unique identifier for the logged message.
    public var logID: String

    /// The timestamp for receipt of the message.
    public var requestTimestamp: String

    /// The timestamp for the system response to the message.
    public var responseTimestamp: String

    /// The workspace ID.
    public var workspaceID: String

    /// The language of the workspace where the message request was made.
    public var language: String

    /**
     Initialize a `LogExport` with member variables.

     - parameter request: A request formatted for the Conversation service.
     - parameter response: A response from the Conversation service.
     - parameter logID: A unique identifier for the logged message.
     - parameter requestTimestamp: The timestamp for receipt of the message.
     - parameter responseTimestamp: The timestamp for the system response to the message.
     - parameter workspaceID: The workspace ID.
     - parameter language: The language of the workspace where the message request was made.

     - returns: An initialized `LogExport`.
    */
    public init(request: MessageRequest, response: MessageResponse, logID: String, requestTimestamp: String, responseTimestamp: String, workspaceID: String, language: String) {
        self.request = request
        self.response = response
        self.logID = logID
        self.requestTimestamp = requestTimestamp
        self.responseTimestamp = responseTimestamp
        self.workspaceID = workspaceID
        self.language = language
    }
}

extension LogExport: Codable {

    private enum CodingKeys: String, CodingKey {
        case request = "request"
        case response = "response"
        case logID = "log_id"
        case requestTimestamp = "request_timestamp"
        case responseTimestamp = "response_timestamp"
        case workspaceID = "workspace_id"
        case language = "language"
        static let allValues = [request, response, logID, requestTimestamp, responseTimestamp, workspaceID, language]
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        request = try container.decode(MessageRequest.self, forKey: .request)
        response = try container.decode(MessageResponse.self, forKey: .response)
        logID = try container.decode(String.self, forKey: .logID)
        requestTimestamp = try container.decode(String.self, forKey: .requestTimestamp)
        responseTimestamp = try container.decode(String.self, forKey: .responseTimestamp)
        workspaceID = try container.decode(String.self, forKey: .workspaceID)
        language = try container.decode(String.self, forKey: .language)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(request, forKey: .request)
        try container.encode(response, forKey: .response)
        try container.encode(logID, forKey: .logID)
        try container.encode(requestTimestamp, forKey: .requestTimestamp)
        try container.encode(responseTimestamp, forKey: .responseTimestamp)
        try container.encode(workspaceID, forKey: .workspaceID)
        try container.encode(language, forKey: .language)
    }

}
