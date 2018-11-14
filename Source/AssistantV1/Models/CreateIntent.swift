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

/** CreateIntent. */
public struct CreateIntent: Codable, Equatable {

    /**
     The name of the intent. This string must conform to the following restrictions:
     - It can contain only Unicode alphanumeric, underscore, hyphen, and dot characters.
     - It cannot begin with the reserved prefix `sys-`.
     - It must be no longer than 128 characters.
     */
    public var intent: String

    /**
     The description of the intent. This string cannot contain carriage return, newline, or tab characters, and it must
     be no longer than 128 characters.
     */
    public var description: String?

    /**
     An array of user input examples for the intent.
     */
    public var examples: [CreateExample]?

    // Map each property name to the key that shall be used for encoding/decoding.
    private enum CodingKeys: String, CodingKey {
        case intent = "intent"
        case description = "description"
        case examples = "examples"
    }

    /**
     Initialize a `CreateIntent` with member variables.

     - parameter intent: The name of the intent. This string must conform to the following restrictions:
       - It can contain only Unicode alphanumeric, underscore, hyphen, and dot characters.
       - It cannot begin with the reserved prefix `sys-`.
       - It must be no longer than 128 characters.
     - parameter description: The description of the intent. This string cannot contain carriage return, newline, or
       tab characters, and it must be no longer than 128 characters.
     - parameter examples: An array of user input examples for the intent.

     - returns: An initialized `CreateIntent`.
    */
    public init(
        intent: String,
        description: String? = nil,
        examples: [CreateExample]? = nil
    )
    {
        self.intent = intent
        self.description = description
        self.examples = examples
    }

}
