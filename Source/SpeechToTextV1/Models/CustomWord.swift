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

/** CustomWord. */
public struct CustomWord: Encodable {

    /**
     For the **Add custom words** method, you must specify the custom word that is to be added to or updated in the
     custom model. Do not include spaces in the word. Use a `-` (dash) or `_` (underscore) to connect the tokens of
     compound words.
     Omit this field for the **Add a custom word** method.
     */
    public var word: String?

    /**
     An array of sounds-like pronunciations for the custom word. Specify how words that are difficult to pronounce,
     foreign words, acronyms, and so on can be pronounced by users.
     * For a word that is not in the service's base vocabulary, omit the parameter to have the service automatically
     generate a sounds-like pronunciation for the word.
     * For a word that is in the service's base vocabulary, use the parameter to specify additional pronunciations for
     the word. You cannot override the default pronunciation of a word; pronunciations you add augment the pronunciation
     from the base vocabulary.
     A word can have at most five sounds-like pronunciations. A pronunciation can include at most 40 characters not
     including spaces.
     */
    public var soundsLike: [String]?

    /**
     An alternative spelling for the custom word when it appears in a transcript. Use the parameter when you want the
     word to have a spelling that is different from its usual representation or from its spelling in corpora training
     data.
     */
    public var displayAs: String?

    // Map each property name to the key that shall be used for encoding/decoding.
    private enum CodingKeys: String, CodingKey {
        case word = "word"
        case soundsLike = "sounds_like"
        case displayAs = "display_as"
    }

    /**
     Initialize a `CustomWord` with member variables.

     - parameter word: For the **Add custom words** method, you must specify the custom word that is to be added to
       or updated in the custom model. Do not include spaces in the word. Use a `-` (dash) or `_` (underscore) to
       connect the tokens of compound words.
       Omit this field for the **Add a custom word** method.
     - parameter soundsLike: An array of sounds-like pronunciations for the custom word. Specify how words that are
       difficult to pronounce, foreign words, acronyms, and so on can be pronounced by users.
       * For a word that is not in the service's base vocabulary, omit the parameter to have the service automatically
       generate a sounds-like pronunciation for the word.
       * For a word that is in the service's base vocabulary, use the parameter to specify additional pronunciations for
       the word. You cannot override the default pronunciation of a word; pronunciations you add augment the
       pronunciation from the base vocabulary.
       A word can have at most five sounds-like pronunciations. A pronunciation can include at most 40 characters not
       including spaces.
     - parameter displayAs: An alternative spelling for the custom word when it appears in a transcript. Use the
       parameter when you want the word to have a spelling that is different from its usual representation or from its
       spelling in corpora training data.

     - returns: An initialized `CustomWord`.
    */
    public init(
        word: String? = nil,
        soundsLike: [String]? = nil,
        displayAs: String? = nil
    )
    {
        self.word = word
        self.soundsLike = soundsLike
        self.displayAs = displayAs
    }

}
