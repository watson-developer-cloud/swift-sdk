/**
 * (C) Copyright IBM Corp. 2020, 2022.
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
 Session context data that is shared by all skills used by the assistant.
 */
public struct MessageContextGlobalStateless: Codable, Equatable {

    /**
     Built-in system properties that apply to all skills used by the assistant.
     */
    public var system: MessageContextGlobalSystem?

    /**
     The unique identifier of the session.
     */
    public var sessionID: String?

    // Map each property name to the key that shall be used for encoding/decoding.
    private enum CodingKeys: String, CodingKey {
        case system = "system"
        case sessionID = "session_id"
    }

    /**
      Initialize a `MessageContextGlobalStateless` with member variables.

      - parameter system: Built-in system properties that apply to all skills used by the assistant.
      - parameter sessionID: The unique identifier of the session.

      - returns: An initialized `MessageContextGlobalStateless`.
     */
    public init(
        system: MessageContextGlobalSystem? = nil,
        sessionID: String? = nil
    )
    {
        self.system = system
        self.sessionID = sessionID
    }

}
