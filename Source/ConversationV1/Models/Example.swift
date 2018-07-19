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

/** Example. */
public struct Example: Decodable {

    /**
     The text of the user input example.
     */
    public var exampleText: String

    /**
     The timestamp for creation of the example.
     */
    public var created: String?

    /**
     The timestamp for the last update to the example.
     */
    public var updated: String?

    /**
     An array of contextual entity mentions.
     */
    public var mentions: [Mentions]?

    // Map each property name to the key that shall be used for encoding/decoding.
    private enum CodingKeys: String, CodingKey {
        case exampleText = "text"
        case created = "created"
        case updated = "updated"
        case mentions = "mentions"
    }

}
