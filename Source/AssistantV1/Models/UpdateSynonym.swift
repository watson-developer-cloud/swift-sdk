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

/** UpdateSynonym. */
internal struct UpdateSynonym: Codable, Equatable {

    /**
     The text of the synonym. This string must conform to the following restrictions:
     - It cannot contain carriage return, newline, or tab characters.
     - It cannot consist of only whitespace characters.
     - It must be no longer than 64 characters.
     */
    public var synonym: String?

    /**
     The timestamp for creation of the object.
     */
    public var created: Date?

    /**
     The timestamp for the most recent update to the object.
     */
    public var updated: Date?

    // Map each property name to the key that shall be used for encoding/decoding.
    private enum CodingKeys: String, CodingKey {
        case synonym = "synonym"
        case created = "created"
        case updated = "updated"
    }

    /**
     Initialize a `UpdateSynonym` with member variables.

     - parameter synonym: The text of the synonym. This string must conform to the following restrictions:
       - It cannot contain carriage return, newline, or tab characters.
       - It cannot consist of only whitespace characters.
       - It must be no longer than 64 characters.
     - parameter created: The timestamp for creation of the object.
     - parameter updated: The timestamp for the most recent update to the object.

     - returns: An initialized `UpdateSynonym`.
    */
    public init(
        synonym: String? = nil,
        created: Date? = nil,
        updated: Date? = nil
    )
    {
        self.synonym = synonym
        self.created = created
        self.updated = updated
    }

}
