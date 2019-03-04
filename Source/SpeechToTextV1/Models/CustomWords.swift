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

/** CustomWords. */
internal struct CustomWords: Codable, Equatable {

    /**
     An array of `CustomWord` objects that provides information about each custom word that is to be added to or updated
     in the custom language model.
     */
    public var words: [CustomWord]

    // Map each property name to the key that shall be used for encoding/decoding.
    private enum CodingKeys: String, CodingKey {
        case words = "words"
    }

    /**
     Initialize a `CustomWords` with member variables.

     - parameter words: An array of `CustomWord` objects that provides information about each custom word that is to
       be added to or updated in the custom language model.

     - returns: An initialized `CustomWords`.
    */
    public init(
        words: [CustomWord]
    )
    {
        self.words = words
    }

}
