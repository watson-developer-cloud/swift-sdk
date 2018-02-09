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

/** IdentifiedLanguage. */
public struct IdentifiedLanguage {

    /// The code for an identified language.
    public var language: String

    /// The confidence score for the identified language.
    public var confidence: Double

    /**
     Initialize a `IdentifiedLanguage` with member variables.

     - parameter language: The code for an identified language.
     - parameter confidence: The confidence score for the identified language.

     - returns: An initialized `IdentifiedLanguage`.
    */
    public init(language: String, confidence: Double) {
        self.language = language
        self.confidence = confidence
    }
}

extension IdentifiedLanguage: Codable {

    private enum CodingKeys: String, CodingKey {
        case language = "language"
        case confidence = "confidence"
        static let allValues = [language, confidence]
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        language = try container.decode(String.self, forKey: .language)
        confidence = try container.decode(Double.self, forKey: .confidence)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(language, forKey: .language)
        try container.encode(confidence, forKey: .confidence)
    }

}
