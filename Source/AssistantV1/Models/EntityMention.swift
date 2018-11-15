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
 An object describing a contextual entity mention.
 */
public struct EntityMention: Codable, Equatable {

    /**
     The text of the user input example.
     */
    public var exampleText: String

    /**
     The name of the intent.
     */
    public var intentName: String

    /**
     An array of zero-based character offsets that indicate where the entity mentions begin and end in the input text.
     */
    public var location: [Int]

    // Map each property name to the key that shall be used for encoding/decoding.
    private enum CodingKeys: String, CodingKey {
        case exampleText = "text"
        case intentName = "intent"
        case location = "location"
    }

}
