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

/** TranslationResult. */
public struct TranslationResult {

    /// Number of words of the complete input text.
    public var wordCount: Int

    /// Number of characters of the complete input text.
    public var characterCount: Int

    /// List of translation output in UTF-8, corresponding to the list of input text.
    public var translations: [Translation]

    /**
     Initialize a `TranslationResult` with member variables.

     - parameter wordCount: Number of words of the complete input text.
     - parameter characterCount: Number of characters of the complete input text.
     - parameter translations: List of translation output in UTF-8, corresponding to the list of input text.

     - returns: An initialized `TranslationResult`.
    */
    public init(wordCount: Int, characterCount: Int, translations: [Translation]) {
        self.wordCount = wordCount
        self.characterCount = characterCount
        self.translations = translations
    }
}

extension TranslationResult: Codable {

    private enum CodingKeys: String, CodingKey {
        case wordCount = "word_count"
        case characterCount = "character_count"
        case translations = "translations"
        static let allValues = [wordCount, characterCount, translations]
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        wordCount = try container.decode(Int.self, forKey: .wordCount)
        characterCount = try container.decode(Int.self, forKey: .characterCount)
        translations = try container.decode([Translation].self, forKey: .translations)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(wordCount, forKey: .wordCount)
        try container.encode(characterCount, forKey: .characterCount)
        try container.encode(translations, forKey: .translations)
    }

}
