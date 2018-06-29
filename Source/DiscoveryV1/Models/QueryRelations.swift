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
 A respresentation of a relationship query.
 */
public struct QueryRelations: Encodable {

    /**
     The sorting method for the relationships, can be `score` or `frequency`. `frequency` is the number of unique times
     each entity is identified. The default is `score`.
     */
    public enum Sort: String {
        case score = "score"
        case frequency = "frequency"
    }

    /**
     An array of entities to find relationships for.
     */
    public var entities: [QueryRelationsEntity]?

    /**
     Entity text to provide context for the queried entity and rank based on that association. For example, if you
     wanted to query the city of London in England your query would look for `London` with the context of `England`.
     */
    public var context: QueryEntitiesContext?

    /**
     The sorting method for the relationships, can be `score` or `frequency`. `frequency` is the number of unique times
     each entity is identified. The default is `score`.
     */
    public var sort: String?

    /**
     Filters to apply to the relationship query.
     */
    public var filter: QueryRelationsFilter?

    /**
     The number of results to return. The default is `10`. The maximum is `1000`.
     */
    public var count: Int?

    /**
     The number of evidence items to return for each result. The default is `0`. The maximum number of evidence items
     per query is 10,000.
     */
    public var evidenceCount: Int?

    // Map each property name to the key that shall be used for encoding/decoding.
    private enum CodingKeys: String, CodingKey {
        case entities = "entities"
        case context = "context"
        case sort = "sort"
        case filter = "filter"
        case count = "count"
        case evidenceCount = "evidence_count"
    }

    /**
     Initialize a `QueryRelations` with member variables.

     - parameter entities: An array of entities to find relationships for.
     - parameter context: Entity text to provide context for the queried entity and rank based on that association.
       For example, if you wanted to query the city of London in England your query would look for `London` with the
       context of `England`.
     - parameter sort: The sorting method for the relationships, can be `score` or `frequency`. `frequency` is the
       number of unique times each entity is identified. The default is `score`.
     - parameter filter: Filters to apply to the relationship query.
     - parameter count: The number of results to return. The default is `10`. The maximum is `1000`.
     - parameter evidenceCount: The number of evidence items to return for each result. The default is `0`. The
       maximum number of evidence items per query is 10,000.

     - returns: An initialized `QueryRelations`.
    */
    public init(
        entities: [QueryRelationsEntity]? = nil,
        context: QueryEntitiesContext? = nil,
        sort: String? = nil,
        filter: QueryRelationsFilter? = nil,
        count: Int? = nil,
        evidenceCount: Int? = nil
    )
    {
        self.entities = entities
        self.context = context
        self.sort = sort
        self.filter = filter
        self.count = count
        self.evidenceCount = evidenceCount
    }

}
