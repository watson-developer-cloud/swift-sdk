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

/** CreateVoiceModel. */
public struct CreateVoiceModel {

    /// The language of the new custom voice model. Omit the parameter to use the the default language, `en-US`.
    public enum Language: String {
        case deDe = "de-DE"
        case enUs = "en-US"
        case enGb = "en-GB"
        case esEs = "es-ES"
        case esLa = "es-LA"
        case esUs = "es-US"
        case frFr = "fr-FR"
        case itIt = "it-IT"
        case jaJp = "ja-JP"
        case ptBr = "pt-BR"
    }

    /// The name of the new custom voice model.
    public var name: String

    /// The language of the new custom voice model. Omit the parameter to use the the default language, `en-US`.
    public var language: String?

    /// A description of the new custom voice model. Specifying a description is recommended.
    public var description: String?

    /**
     Initialize a `CreateVoiceModel` with member variables.

     - parameter name: The name of the new custom voice model.
     - parameter language: The language of the new custom voice model. Omit the parameter to use the the default language, `en-US`.
     - parameter description: A description of the new custom voice model. Specifying a description is recommended.

     - returns: An initialized `CreateVoiceModel`.
    */
    public init(name: String, language: String? = nil, description: String? = nil) {
        self.name = name
        self.language = language
        self.description = description
    }
}

extension CreateVoiceModel: Codable {

    private enum CodingKeys: String, CodingKey {
        case name = "name"
        case language = "language"
        case description = "description"
        static let allValues = [name, language, description]
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decode(String.self, forKey: .name)
        language = try container.decodeIfPresent(String.self, forKey: .language)
        description = try container.decodeIfPresent(String.self, forKey: .description)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encodeIfPresent(language, forKey: .language)
        try container.encodeIfPresent(description, forKey: .description)
    }

}
