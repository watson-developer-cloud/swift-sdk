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
import RestKit

/** An option specifying whether or not to identify the subjects, actions, and verbs in the 
 analyzed content. */
public struct SemanticRolesOptions: JSONEncodable {
    
    /// Maximum number of semantic_roles results to return.
    public let limit: Int?
    
    /// Set this to true to return keyword information for subjects and objects.
    public let keywords: Bool?
    
    /// Set this to true to return entity information for subjects and objects.
    public let entities: Bool?
    
    /// Set this to true to only return results in which the subjects and objects contain entities.
    public let requireEntities: Bool?
    
    /// Set this to false to hide entity disambiguation information in the response.
    public let disambiguate: Bool?

    /**
    Initialize a `SemanticRolesOptions` with all member variables.

     - parameter limit: Maximum number of semantic_roles results to return.
     - parameter keywords: Set this to true to return keyword information for subjects and objects.
     - parameter entities: Set this to true to return entity information for subjects and objects.
     - parameter requireEntities: Set this to true to only return results in which the subjects and objects contain entities.
     - parameter disambiguate: Set this to false to hide entity disambiguation information in the response.

    - returns: An initialized `SemanticRolesOptions`.
    */
    public init(
        limit: Int? = nil,
        keywords: Bool? = nil,
        entities: Bool? = nil,
        requireEntities: Bool? = nil,
        disambiguate: Bool? = nil)
    {
        self.limit = limit
        self.keywords = keywords
        self.entities = entities
        self.requireEntities = requireEntities
        self.disambiguate = disambiguate
    }

    /// Used internally to serialize a `SemanticRolesOptions` model to JSON.
    public func toJSONObject() -> Any {
        var json = [String: Any]()
        if let limit = limit { json["limit"] = limit }
        if let keywords = keywords { json["keywords"] = keywords }
        if let entities = entities { json["entities"] = entities }
        if let requireEntities = requireEntities { json["require_entities"] = requireEntities }
        if let disambiguate = disambiguate { json["disambiguate"] = disambiguate }
        return json
    }
}
