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
 Optional properties that control how the assistant responds.
 */
public struct MessageInputOptions: Codable {

    /**
     Whether to return additional diagnostic information. Set to `true` to return additional information under the
     `output.debug` key.
     */
    public var debug: Bool?

    /**
     Whether to start a new conversation with this user input. Specify `true` to clear the state information stored by
     the session.
     */
    public var restart: Bool?

    /**
     Whether to return more than one intent. Set to `true` to return all matching intents.
     */
    public var alternateIntents: Bool?

    /**
     Whether to return session context with the response. If you specify `true`, the response will include the `context`
     property.
     */
    public var returnContext: Bool?

    // Map each property name to the key that shall be used for encoding/decoding.
    private enum CodingKeys: String, CodingKey {
        case debug = "debug"
        case restart = "restart"
        case alternateIntents = "alternate_intents"
        case returnContext = "return_context"
    }

    /**
     Initialize a `MessageInputOptions` with member variables.

     - parameter debug: Whether to return additional diagnostic information. Set to `true` to return additional
       information under the `output.debug` key.
     - parameter restart: Whether to start a new conversation with this user input. Specify `true` to clear the state
       information stored by the session.
     - parameter alternateIntents: Whether to return more than one intent. Set to `true` to return all matching
       intents.
     - parameter returnContext: Whether to return session context with the response. If you specify `true`, the
       response will include the `context` property.

     - returns: An initialized `MessageInputOptions`.
    */
    public init(
        debug: Bool? = nil,
        restart: Bool? = nil,
        alternateIntents: Bool? = nil,
        returnContext: Bool? = nil
    )
    {
        self.debug = debug
        self.restart = restart
        self.alternateIntents = alternateIntents
        self.returnContext = returnContext
    }

}
