/**
 * Copyright IBM Corporation 2018
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
 Properties that are shared by all skills used by the assistant.
 */
public struct MessageContextGlobalSystem: Codable, Equatable {

    /**
     The user time zone. The assistant uses the time zone to correctly resolve relative time references.
     */
    public var timezone: String?

    /**
     A string value that identifies the user who is interacting with the assistant. The client must provide a unique
     identifier for each individual end user who accesses the application. For Plus and Premium plans, this user ID is
     used to identify unique users for billing purposes. This string cannot contain carriage return, newline, or tab
     characters.
     */
    public var userID: String?

    /**
     A counter that is automatically incremented with each turn of the conversation. A value of 1 indicates that this is
     the the first turn of a new conversation, which can affect the behavior of some skills.
     */
    public var turnCount: Int?

    // Map each property name to the key that shall be used for encoding/decoding.
    private enum CodingKeys: String, CodingKey {
        case timezone = "timezone"
        case userID = "user_id"
        case turnCount = "turn_count"
    }

    /**
     Initialize a `MessageContextGlobalSystem` with member variables.

     - parameter timezone: The user time zone. The assistant uses the time zone to correctly resolve relative time
       references.
     - parameter userID: A string value that identifies the user who is interacting with the assistant. The client
       must provide a unique identifier for each individual end user who accesses the application. For Plus and Premium
       plans, this user ID is used to identify unique users for billing purposes. This string cannot contain carriage
       return, newline, or tab characters.
     - parameter turnCount: A counter that is automatically incremented with each turn of the conversation. A value
       of 1 indicates that this is the the first turn of a new conversation, which can affect the behavior of some
       skills.

     - returns: An initialized `MessageContextGlobalSystem`.
    */
    public init(
        timezone: String? = nil,
        userID: String? = nil,
        turnCount: Int? = nil
    )
    {
        self.timezone = timezone
        self.userID = userID
        self.turnCount = turnCount
    }

}
