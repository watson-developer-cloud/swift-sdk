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

/** Translation. */
public struct Translation: Codable {

    /**
     **Japanese only.** The part of speech for the word. The service uses the value to produce the correct intonation
     for the word. You can create only a single entry, with or without a single part of speech, for any word; you cannot
     create multiple entries with different parts of speech for the same word. For more information, see [Working with
     Japanese entries](https://console.bluemix.net/docs/services/text-to-speech/custom-rules.html#jaNotes).
     */
    public enum PartOfSpeech: String {
        case josi = "Josi"
        case mesi = "Mesi"
        case kigo = "Kigo"
        case gobi = "Gobi"
        case dosi = "Dosi"
        case jodo = "Jodo"
        case koyu = "Koyu"
        case stbi = "Stbi"
        case suji = "Suji"
        case kedo = "Kedo"
        case fuku = "Fuku"
        case keyo = "Keyo"
        case stto = "Stto"
        case reta = "Reta"
        case stzo = "Stzo"
        case kato = "Kato"
        case hoka = "Hoka"
    }

    /**
     The phonetic or sounds-like translation for the word. A phonetic translation is based on the SSML format for
     representing the phonetic string of a word either as an IPA translation or as an IBM SPR translation. A sounds-like
     is one or more words that, when combined, sound like the word.
     */
    public var translation: String

    /**
     **Japanese only.** The part of speech for the word. The service uses the value to produce the correct intonation
     for the word. You can create only a single entry, with or without a single part of speech, for any word; you cannot
     create multiple entries with different parts of speech for the same word. For more information, see [Working with
     Japanese entries](https://console.bluemix.net/docs/services/text-to-speech/custom-rules.html#jaNotes).
     */
    public var partOfSpeech: String?

    // Map each property name to the key that shall be used for encoding/decoding.
    private enum CodingKeys: String, CodingKey {
        case translation = "translation"
        case partOfSpeech = "part_of_speech"
    }

    /**
     Initialize a `Translation` with member variables.

     - parameter translation: The phonetic or sounds-like translation for the word. A phonetic translation is based
       on the SSML format for representing the phonetic string of a word either as an IPA translation or as an IBM SPR
       translation. A sounds-like is one or more words that, when combined, sound like the word.
     - parameter partOfSpeech: **Japanese only.** The part of speech for the word. The service uses the value to
       produce the correct intonation for the word. You can create only a single entry, with or without a single part of
       speech, for any word; you cannot create multiple entries with different parts of speech for the same word. For
       more information, see [Working with Japanese
       entries](https://console.bluemix.net/docs/services/text-to-speech/custom-rules.html#jaNotes).

     - returns: An initialized `Translation`.
    */
    public init(
        translation: String,
        partOfSpeech: String? = nil
    )
    {
        self.translation = translation
        self.partOfSpeech = partOfSpeech
    }

}
