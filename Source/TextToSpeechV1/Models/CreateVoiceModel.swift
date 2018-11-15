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
internal struct CreateVoiceModel: Codable, Equatable {

    /**
     The language of the new custom voice model. Omit the parameter to use the the default language, `en-US`.
     */
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

    /**
     The name of the new custom voice model.
     */
    public var name: String

    /**
     The language of the new custom voice model. Omit the parameter to use the the default language, `en-US`.
     */
    public var language: String?

    /**
     A description of the new custom voice model. Specifying a description is recommended.
     */
    public var description: String?

    // Map each property name to the key that shall be used for encoding/decoding.
    private enum CodingKeys: String, CodingKey {
        case name = "name"
        case language = "language"
        case description = "description"
    }

    /**
     Initialize a `CreateVoiceModel` with member variables.

     - parameter name: The name of the new custom voice model.
     - parameter language: The language of the new custom voice model. Omit the parameter to use the the default
       language, `en-US`.
     - parameter description: A description of the new custom voice model. Specifying a description is recommended.

     - returns: An initialized `CreateVoiceModel`.
    */
    public init(
        name: String,
        language: String? = nil,
        description: String? = nil
    )
    {
        self.name = name
        self.language = language
        self.description = description
    }

}
