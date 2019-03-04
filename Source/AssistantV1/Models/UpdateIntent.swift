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

/** UpdateIntent. */
internal struct UpdateIntent: Codable, Equatable {

    /**
     The name of the intent. This string must conform to the following restrictions:
     - It can contain only Unicode alphanumeric, underscore, hyphen, and dot characters.
     - It cannot begin with the reserved prefix `sys-`.
     - It must be no longer than 128 characters.
     */
    public var intent: String?

    /**
     The description of the intent. This string cannot contain carriage return, newline, or tab characters, and it must
     be no longer than 128 characters.
     */
    public var description: String?

    /**
     The timestamp for creation of the object.
     */
    public var created: Date?

    /**
     The timestamp for the most recent update to the object.
     */
    public var updated: Date?

    /**
     An array of user input examples for the intent.
     */
    public var examples: [Example]?

    // Map each property name to the key that shall be used for encoding/decoding.
    private enum CodingKeys: String, CodingKey {
        case intent = "intent"
        case description = "description"
        case created = "created"
        case updated = "updated"
        case examples = "examples"
    }

    /**
     Initialize a `UpdateIntent` with member variables.

     - parameter intent: The name of the intent. This string must conform to the following restrictions:
       - It can contain only Unicode alphanumeric, underscore, hyphen, and dot characters.
       - It cannot begin with the reserved prefix `sys-`.
       - It must be no longer than 128 characters.
     - parameter description: The description of the intent. This string cannot contain carriage return, newline, or
       tab characters, and it must be no longer than 128 characters.
     - parameter created: The timestamp for creation of the object.
     - parameter updated: The timestamp for the most recent update to the object.
     - parameter examples: An array of user input examples for the intent.

     - returns: An initialized `UpdateIntent`.
    */
    public init(
        intent: String? = nil,
        description: String? = nil,
        created: Date? = nil,
        updated: Date? = nil,
        examples: [Example]? = nil
    )
    {
        self.intent = intent
        self.description = description
        self.created = created
        self.updated = updated
        self.examples = examples
    }

}
