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
 Optional properties that control how the assistant responds.
 */
public struct MessageInputOptionsStateless: Codable, Equatable {

    /**
     Whether to restart dialog processing at the root of the dialog, regardless of any previously visited nodes.
     **Note:** This does not affect `turn_count` or any other context variables.
     */
    public var restart: Bool?

    /**
     Whether to return more than one intent. Set to `true` to return all matching intents.
     */
    public var alternateIntents: Bool?

    /**
     Spelling correction options for the message. Any options specified on an individual message override the settings
     configured for the skill.
     */
    public var spelling: MessageInputOptionsSpelling?

    /**
     Whether to return additional diagnostic information. Set to `true` to return additional information in the
     `output.debug` property.
     */
    public var debug: Bool?

    // Map each property name to the key that shall be used for encoding/decoding.
    private enum CodingKeys: String, CodingKey {
        case restart = "restart"
        case alternateIntents = "alternate_intents"
        case spelling = "spelling"
        case debug = "debug"
    }

    /**
      Initialize a `MessageInputOptionsStateless` with member variables.

      - parameter restart: Whether to restart dialog processing at the root of the dialog, regardless of any
        previously visited nodes. **Note:** This does not affect `turn_count` or any other context variables.
      - parameter alternateIntents: Whether to return more than one intent. Set to `true` to return all matching
        intents.
      - parameter spelling: Spelling correction options for the message. Any options specified on an individual
        message override the settings configured for the skill.
      - parameter debug: Whether to return additional diagnostic information. Set to `true` to return additional
        information in the `output.debug` property.

      - returns: An initialized `MessageInputOptionsStateless`.
     */
    public init(
        restart: Bool? = nil,
        alternateIntents: Bool? = nil,
        spelling: MessageInputOptionsSpelling? = nil,
        debug: Bool? = nil
    )
    {
        self.restart = restart
        self.alternateIntents = alternateIntents
        self.spelling = spelling
        self.debug = debug
    }

}
