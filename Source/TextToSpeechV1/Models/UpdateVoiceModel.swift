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

/** UpdateVoiceModel. */
internal struct UpdateVoiceModel: Encodable {

    /**
     A new name for the custom voice model.
     */
    public var name: String?

    /**
     A new description for the custom voice model.
     */
    public var description: String?

    /**
     An array of `Word` objects that provides the words and their translations that are to be added or updated for the
     custom voice model. Pass an empty array to make no additions or updates.
     */
    public var words: [Word]?

    // Map each property name to the key that shall be used for encoding/decoding.
    private enum CodingKeys: String, CodingKey {
        case name = "name"
        case description = "description"
        case words = "words"
    }

    /**
     Initialize a `UpdateVoiceModel` with member variables.

     - parameter name: A new name for the custom voice model.
     - parameter description: A new description for the custom voice model.
     - parameter words: An array of `Word` objects that provides the words and their translations that are to be
       added or updated for the custom voice model. Pass an empty array to make no additions or updates.

     - returns: An initialized `UpdateVoiceModel`.
    */
    public init(
        name: String? = nil,
        description: String? = nil,
        words: [Word]? = nil
    )
    {
        self.name = name
        self.description = description
        self.words = words
    }

}
