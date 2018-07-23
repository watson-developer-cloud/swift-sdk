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

/** CreateExample. */
public struct CreateExample: Encodable {

    /**
     The text of a user input example. This string must conform to the following restrictions:
     - It cannot contain carriage return, newline, or tab characters.
     - It cannot consist of only whitespace characters.
     - It must be no longer than 1024 characters.
     */
    public var text: String

    // Map each property name to the key that shall be used for encoding/decoding.
    private enum CodingKeys: String, CodingKey {
        case text = "text"
    }

    /**
     Initialize a `CreateExample` with member variables.

     - parameter text: The text of a user input example. This string must conform to the following restrictions:
       - It cannot contain carriage return, newline, or tab characters.
       - It cannot consist of only whitespace characters.
       - It must be no longer than 1024 characters.

     - returns: An initialized `CreateExample`.
    */
    public init(
        text: String
    )
    {
        self.text = text
    }

}
