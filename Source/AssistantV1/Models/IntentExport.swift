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

/** IntentExport. */
public struct IntentExport: Codable, Equatable {

    /**
     The name of the intent.
     */
    public var intentName: String

    /**
     The timestamp for creation of the intent.
     */
    public var created: Date?

    /**
     The timestamp for the last update to the intent.
     */
    public var updated: Date?

    /**
     The description of the intent.
     */
    public var description: String?

    /**
     An array of objects describing the user input examples for the intent.
     */
    public var examples: [Example]?

    // Map each property name to the key that shall be used for encoding/decoding.
    private enum CodingKeys: String, CodingKey {
        case intentName = "intent"
        case created = "created"
        case updated = "updated"
        case description = "description"
        case examples = "examples"
    }

}
