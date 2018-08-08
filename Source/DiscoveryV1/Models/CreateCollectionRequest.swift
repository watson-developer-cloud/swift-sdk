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

/** CreateCollectionRequest. */
public struct CreateCollectionRequest: Encodable {

    /**
     The language of the documents stored in the collection, in the form of an ISO 639-1 language code.
     */
    public enum Language: String {
        case en = "en"
        case es = "es"
        case de = "de"
        case ar = "ar"
        case fr = "fr"
        case it = "it"
        case ja = "ja"
        case ko = "ko"
        case pt = "pt"
        case nl = "nl"
    }

    /**
     The name of the collection to be created.
     */
    public var name: String

    /**
     A description of the collection.
     */
    public var description: String?

    /**
     The ID of the configuration in which the collection is to be created.
     */
    public var configurationID: String?

    /**
     The language of the documents stored in the collection, in the form of an ISO 639-1 language code.
     */
    public var language: String?

    // Map each property name to the key that shall be used for encoding/decoding.
    private enum CodingKeys: String, CodingKey {
        case name = "name"
        case description = "description"
        case configurationID = "configuration_id"
        case language = "language"
    }

    /**
     Initialize a `CreateCollectionRequest` with member variables.

     - parameter name: The name of the collection to be created.
     - parameter description: A description of the collection.
     - parameter configurationID: The ID of the configuration in which the collection is to be created.
     - parameter language: The language of the documents stored in the collection, in the form of an ISO 639-1
       language code.

     - returns: An initialized `CreateCollectionRequest`.
    */
    public init(
        name: String,
        description: String? = nil,
        configurationID: String? = nil,
        language: String? = nil
    )
    {
        self.name = name
        self.description = description
        self.configurationID = configurationID
        self.language = language
    }

}
