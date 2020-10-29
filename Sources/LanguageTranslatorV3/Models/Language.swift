/**
 * (C) Copyright IBM Corp. 2020.
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
 Response payload for languages.
 */
public struct Language: Codable, Equatable {

    /**
     The language code for the language (for example, `af`).
     */
    public var language: String?

    /**
     The name of the language in English (for example, `Afrikaans`).
     */
    public var languageName: String?

    /**
     The native name of the language (for example, `Afrikaans`).
     */
    public var nativeLanguageName: String?

    /**
     The country code for the language (for example, `ZA` for South Africa).
     */
    public var countryCode: String?

    /**
     Indicates whether words of the language are separated by whitespace: `true` if the words are separated; `false`
     otherwise.
     */
    public var wordsSeparated: Bool?

    /**
     Indicates the direction of the language: `right_to_left` or `left_to_right`.
     */
    public var direction: String?

    /**
     Indicates whether the language can be used as the source for translation: `true` if the language can be used as the
     source; `false` otherwise.
     */
    public var supportedAsSource: Bool?

    /**
     Indicates whether the language can be used as the target for translation: `true` if the language can be used as the
     target; `false` otherwise.
     */
    public var supportedAsTarget: Bool?

    /**
     Indicates whether the language supports automatic detection: `true` if the language can be detected automatically;
     `false` otherwise.
     */
    public var identifiable: Bool?

    // Map each property name to the key that shall be used for encoding/decoding.
    private enum CodingKeys: String, CodingKey {
        case language = "language"
        case languageName = "language_name"
        case nativeLanguageName = "native_language_name"
        case countryCode = "country_code"
        case wordsSeparated = "words_separated"
        case direction = "direction"
        case supportedAsSource = "supported_as_source"
        case supportedAsTarget = "supported_as_target"
        case identifiable = "identifiable"
    }

}
