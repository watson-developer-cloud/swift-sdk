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
public struct MessageContextGlobalSystem: Codable {

    /**
     The user time zone. The assistant uses the time zone to correctly resolve relative time references.
     */
    public var timezone: String?

    /**
     String value provided by the API client that should be unique per each distinct end user of the service powered by
     Assistant.
     */
    public var userID: String?

    /**
     This property is normally set by the Assistant which sets this to 1 during the first conversation turn and then
     increments it by 1 with every subsequent turn. A turn count equal to 0 (or > 0) informs the Assistant that this is
     (or is not) the first turn in a conversation which influences the behavior of some skills. The Conversation skill
     uses this to evaluate its `welcome` and `conversation_start` conditions.
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
     - parameter userID: String value provided by the API client that should be unique per each distinct end user of
       the service powered by Assistant.
     - parameter turnCount: This property is normally set by the Assistant which sets this to 1 during the first
       conversation turn and then increments it by 1 with every subsequent turn. A turn count equal to 0 (or > 0)
       informs the Assistant that this is (or is not) the first turn in a conversation which influences the behavior of
       some skills. The Conversation skill uses this to evaluate its `welcome` and `conversation_start` conditions.

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
