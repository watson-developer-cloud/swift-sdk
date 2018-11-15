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

/** Synonym. */
public struct Synonym: Codable, Equatable {

    /**
     The text of the synonym.
     */
    public var synonymText: String

    /**
     The timestamp for creation of the synonym.
     */
    public var created: Date?

    /**
     The timestamp for the most recent update to the synonym.
     */
    public var updated: Date?

    // Map each property name to the key that shall be used for encoding/decoding.
    private enum CodingKeys: String, CodingKey {
        case synonymText = "synonym"
        case created = "created"
        case updated = "updated"
    }

}
