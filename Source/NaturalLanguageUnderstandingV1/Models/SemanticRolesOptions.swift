/**
 * Copyright IBM Corporation 2017
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

/** An option specifying whether or not to identify the subjects, actions, and verbs in the analyzed content. */
public struct SemanticRolesOptions {

    /// Maximum number of semantic_roles results to return.
    public var limit: Int?

    /// Set this to true to return keyword information for subjects and objects.
    public var keywords: Bool?

    /// Set this to true to return entity information for subjects and objects.
    public var entities: Bool?

    /**
     Initialize a `SemanticRolesOptions` with member variables.

     - parameter limit: Maximum number of semantic_roles results to return.
     - parameter keywords: Set this to true to return keyword information for subjects and objects.
     - parameter entities: Set this to true to return entity information for subjects and objects.

     - returns: An initialized `SemanticRolesOptions`.
    */
    public init(limit: Int? = nil, keywords: Bool? = nil, entities: Bool? = nil) {
        self.limit = limit
        self.keywords = keywords
        self.entities = entities
    }
}

extension SemanticRolesOptions: Codable {

    private enum CodingKeys: String, CodingKey {
        case limit = "limit"
        case keywords = "keywords"
        case entities = "entities"
        static let allValues = [limit, keywords, entities]
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        limit = try container.decodeIfPresent(Int.self, forKey: .limit)
        keywords = try container.decodeIfPresent(Bool.self, forKey: .keywords)
        entities = try container.decodeIfPresent(Bool.self, forKey: .entities)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(limit, forKey: .limit)
        try container.encodeIfPresent(keywords, forKey: .keywords)
        try container.encodeIfPresent(entities, forKey: .entities)
    }

}
