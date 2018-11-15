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

/** QueryEntities. */
internal struct QueryEntities: Codable, Equatable {

    /**
     The entity query feature to perform. Supported features are `disambiguate` and `similar_entities`.
     */
    public var feature: String?

    /**
     A text string that appears within the entity text field.
     */
    public var entity: QueryEntitiesEntity?

    /**
     Entity text to provide context for the queried entity and rank based on that association. For example, if you
     wanted to query the city of London in England your query would look for `London` with the context of `England`.
     */
    public var context: QueryEntitiesContext?

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
        case feature = "feature"
        case entity = "entity"
        case context = "context"
        case count = "count"
        case evidenceCount = "evidence_count"
    }

    /**
     Initialize a `QueryEntities` with member variables.

     - parameter feature: The entity query feature to perform. Supported features are `disambiguate` and
       `similar_entities`.
     - parameter entity: A text string that appears within the entity text field.
     - parameter context: Entity text to provide context for the queried entity and rank based on that association.
       For example, if you wanted to query the city of London in England your query would look for `London` with the
       context of `England`.
     - parameter count: The number of results to return. The default is `10`. The maximum is `1000`.
     - parameter evidenceCount: The number of evidence items to return for each result. The default is `0`. The
       maximum number of evidence items per query is 10,000.

     - returns: An initialized `QueryEntities`.
    */
    public init(
        feature: String? = nil,
        entity: QueryEntitiesEntity? = nil,
        context: QueryEntitiesContext? = nil,
        count: Int? = nil,
        evidenceCount: Int? = nil
    )
    {
        self.feature = feature
        self.entity = entity
        self.context = context
        self.count = count
        self.evidenceCount = evidenceCount
    }

}
