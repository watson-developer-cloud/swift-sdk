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

/** QueryRelationsFilter. */
public struct QueryRelationsFilter: Encodable {

    /**
     A list of relation types to include or exclude from the query.
     */
    public var relationTypes: QueryFilterType?

    /**
     A list of entity types to include or exclude from the query.
     */
    public var entityTypes: QueryFilterType?

    /**
     A comma-separated list of document IDs to include in the query.
     */
    public var documentIds: [String]?

    // Map each property name to the key that shall be used for encoding/decoding.
    private enum CodingKeys: String, CodingKey {
        case relationTypes = "relation_types"
        case entityTypes = "entity_types"
        case documentIds = "document_ids"
    }

    /**
     Initialize a `QueryRelationsFilter` with member variables.

     - parameter relationTypes: A list of relation types to include or exclude from the query.
     - parameter entityTypes: A list of entity types to include or exclude from the query.
     - parameter documentIds: A comma-separated list of document IDs to include in the query.

     - returns: An initialized `QueryRelationsFilter`.
    */
    public init(
        relationTypes: QueryFilterType? = nil,
        entityTypes: QueryFilterType? = nil,
        documentIds: [String]? = nil
    )
    {
        self.relationTypes = relationTypes
        self.entityTypes = entityTypes
        self.documentIds = documentIds
    }

}
