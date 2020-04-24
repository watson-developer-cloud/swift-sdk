/**
 * (C) Copyright IBM Corp. 2018, 2020.
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
public struct TranslationResult: Codable, Equatable {

    /**
     An estimate of the number of words in the input text.
     */
    public var wordCount: Int

    /**
     Number of characters in the input text.
     */
    public var characterCount: Int

    /**
     The language code of the source text if the source language was automatically detected.
     */
    public var detectedLanguage: String?

    /**
     A score between 0 and 1 indicating the confidence of source language detection. A higher value indicates greater
     confidence. This is returned only when the service automatically detects the source language.
     */
    public var detectedLanguageConfidence: Double?

    /**
     List of translation output in UTF-8, corresponding to the input text entries.
     */
    public var translations: [Translation]

    // Map each property name to the key that shall be used for encoding/decoding.
    private enum CodingKeys: String, CodingKey {
        case wordCount = "word_count"
        case characterCount = "character_count"
        case detectedLanguage = "detected_language"
        case detectedLanguageConfidence = "detected_language_confidence"
        case translations = "translations"
    }

}
