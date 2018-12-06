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
 A request formatted for the Watson Assistant service.
 */
internal struct MessageRequest: Codable, Equatable {

    /**
     The user input.
     */
    public var input: MessageInput?

    /**
     State information for the conversation.
     */
    public var context: MessageContext?

    // Map each property name to the key that shall be used for encoding/decoding.
    private enum CodingKeys: String, CodingKey {
        case input = "input"
        case context = "context"
    }

    /**
     Initialize a `MessageRequest` with member variables.

     - parameter input: The user input.
     - parameter context: State information for the conversation.

     - returns: An initialized `MessageRequest`.
    */
    public init(
        input: MessageInput? = nil,
        context: MessageContext? = nil
    )
    {
        self.input = input
        self.context = context
    }

}
