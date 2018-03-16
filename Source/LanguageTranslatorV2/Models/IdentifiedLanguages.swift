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

/** IdentifiedLanguages. */
public struct IdentifiedLanguages {

    /// A ranking of identified languages with confidence scores.
    public var languages: [IdentifiedLanguage]

    /**
     Initialize a `IdentifiedLanguages` with member variables.

     - parameter languages: A ranking of identified languages with confidence scores.

     - returns: An initialized `IdentifiedLanguages`.
    */
    public init(languages: [IdentifiedLanguage]) {
        self.languages = languages
    }
}

extension IdentifiedLanguages: Codable {

    private enum CodingKeys: String, CodingKey {
        case languages = "languages"
        static let allValues = [languages]
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        languages = try container.decode([IdentifiedLanguage].self, forKey: .languages)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(languages, forKey: .languages)
    }

}
