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

/** Words. */
public struct Words: Codable {

    /**
     The **Add custom words** method accepts an array of `Word` objects. Each object provides a word that is to be added
     or updated for the custom voice model and the word's translation.
     The **List custom words** method returns an array of `Word` objects. Each object shows a word and its translation
     from the custom voice model. The words are listed in alphabetical order, with uppercase letters listed before
     lowercase letters. The array is empty if the custom model contains no words.
     */
    public var words: [Word]

    // Map each property name to the key that shall be used for encoding/decoding.
    private enum CodingKeys: String, CodingKey {
        case words = "words"
    }

    /**
     Initialize a `Words` with member variables.

     - parameter words: The **Add custom words** method accepts an array of `Word` objects. Each object provides a
       word that is to be added or updated for the custom voice model and the word's translation.
       The **List custom words** method returns an array of `Word` objects. Each object shows a word and its translation
       from the custom voice model. The words are listed in alphabetical order, with uppercase letters listed before
       lowercase letters. The array is empty if the custom model contains no words.

     - returns: An initialized `Words`.
    */
    public init(
        words: [Word]
    )
    {
        self.words = words
    }

}
