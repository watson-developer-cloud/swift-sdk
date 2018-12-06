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

/**
 Parses sentences into subject, action, and object form.
 Supported languages: English, German, Japanese, Korean, Spanish.
 */
public struct SemanticRolesOptions: Codable, Equatable {

    /**
     Maximum number of semantic_roles results to return.
     */
    public var limit: Int?

    /**
     Set this to `true` to return keyword information for subjects and objects.
     */
    public var keywords: Bool?

    /**
     Set this to `true` to return entity information for subjects and objects.
     */
    public var entities: Bool?

    // Map each property name to the key that shall be used for encoding/decoding.
    private enum CodingKeys: String, CodingKey {
        case limit = "limit"
        case keywords = "keywords"
        case entities = "entities"
    }

    /**
     Initialize a `SemanticRolesOptions` with member variables.

     - parameter limit: Maximum number of semantic_roles results to return.
     - parameter keywords: Set this to `true` to return keyword information for subjects and objects.
     - parameter entities: Set this to `true` to return entity information for subjects and objects.

     - returns: An initialized `SemanticRolesOptions`.
    */
    public init(
        limit: Int? = nil,
        keywords: Bool? = nil,
        entities: Bool? = nil
    )
    {
        self.limit = limit
        self.keywords = keywords
        self.entities = entities
    }

}
