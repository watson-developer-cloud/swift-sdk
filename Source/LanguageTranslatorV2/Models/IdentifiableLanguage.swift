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

/** IdentifiableLanguage. */
public struct IdentifiableLanguage {

    /// The code for an identifiable language.
    public var language: String

    /// The name of the identifiable language.
    public var name: String

    /**
     Initialize a `IdentifiableLanguage` with member variables.

     - parameter language: The code for an identifiable language.
     - parameter name: The name of the identifiable language.

     - returns: An initialized `IdentifiableLanguage`.
    */
    public init(language: String, name: String) {
        self.language = language
        self.name = name
    }
}

extension IdentifiableLanguage: Codable {

    private enum CodingKeys: String, CodingKey {
        case language = "language"
        case name = "name"
        static let allValues = [language, name]
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        language = try container.decode(String.self, forKey: .language)
        name = try container.decode(String.self, forKey: .name)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(language, forKey: .language)
        try container.encode(name, forKey: .name)
    }

}
