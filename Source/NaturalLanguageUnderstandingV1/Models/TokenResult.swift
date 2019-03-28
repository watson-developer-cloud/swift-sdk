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

/** TokenResult. */
public struct TokenResult: Codable, Equatable {

    /**
     The part of speech of the token. For descriptions of the values, see [Universal Dependencies POS
     tags](https://universaldependencies.org/u/pos/).
     */
    public enum PartOfSpeech: String {
        case adj = "ADJ"
        case adp = "ADP"
        case adv = "ADV"
        case aux = "AUX"
        case cconj = "CCONJ"
        case det = "DET"
        case intj = "INTJ"
        case noun = "NOUN"
        case num = "NUM"
        case part = "PART"
        case pron = "PRON"
        case propn = "PROPN"
        case punct = "PUNCT"
        case sconj = "SCONJ"
        case sym = "SYM"
        case verb = "VERB"
        case x = "X"
    }

    /**
     The token as it appears in the analyzed text.
     */
    public var text: String?

    /**
     The part of speech of the token. For descriptions of the values, see [Universal Dependencies POS
     tags](https://universaldependencies.org/u/pos/).
     */
    public var partOfSpeech: String?

    /**
     Character offsets indicating the beginning and end of the token in the analyzed text.
     */
    public var location: [Int]?

    /**
     The [lemma](https://wikipedia.org/wiki/Lemma_%28morphology%29) of the token.
     */
    public var lemma: String?

    // Map each property name to the key that shall be used for encoding/decoding.
    private enum CodingKeys: String, CodingKey {
        case text = "text"
        case partOfSpeech = "part_of_speech"
        case location = "location"
        case lemma = "lemma"
    }

}
