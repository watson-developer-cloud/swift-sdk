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
 An object specifiying the semantic roles enrichment and related parameters.
 */
public struct NluEnrichmentSemanticRoles: Codable {

    /**
     When `true`, entities are extracted from the identified sentence parts.
     */
    public var entities: Bool?

    /**
     When `true`, keywords are extracted from the identified sentence parts.
     */
    public var keywords: Bool?

    /**
     The maximum number of semantic roles enrichments to extact from each instance of the specified field.
     */
    public var limit: Int?

    // Map each property name to the key that shall be used for encoding/decoding.
    private enum CodingKeys: String, CodingKey {
        case entities = "entities"
        case keywords = "keywords"
        case limit = "limit"
    }

    /**
     Initialize a `NluEnrichmentSemanticRoles` with member variables.

     - parameter entities: When `true`, entities are extracted from the identified sentence parts.
     - parameter keywords: When `true`, keywords are extracted from the identified sentence parts.
     - parameter limit: The maximum number of semantic roles enrichments to extact from each instance of the
       specified field.

     - returns: An initialized `NluEnrichmentSemanticRoles`.
    */
    public init(
        entities: Bool? = nil,
        keywords: Bool? = nil,
        limit: Int? = nil
    )
    {
        self.entities = entities
        self.keywords = keywords
        self.limit = limit
    }

}
