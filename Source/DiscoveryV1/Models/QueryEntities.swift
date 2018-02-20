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
public struct QueryEntities {

    /// The entity query feature to perform. Must be `disambiguate`.
    public var feature: String?

    /// A text string that appears within the entity text field.
    public var entity: QueryEntitiesEntity?

    /// Entity text to provide context for the queried entity and rank based on that association. For example, if you wanted to query the city of London in England your query would look for `London` with the context of `England`.
    public var context: QueryEntitiesContext?

    /// The number of results to return. The default is `10`. The maximum is `1000`.
    public var count: Int?

    /**
     Initialize a `QueryEntities` with member variables.

     - parameter feature: The entity query feature to perform. Must be `disambiguate`.
     - parameter entity: A text string that appears within the entity text field.
     - parameter context: Entity text to provide context for the queried entity and rank based on that association. For example, if you wanted to query the city of London in England your query would look for `London` with the context of `England`.
     - parameter count: The number of results to return. The default is `10`. The maximum is `1000`.

     - returns: An initialized `QueryEntities`.
    */
    public init(feature: String? = nil, entity: QueryEntitiesEntity? = nil, context: QueryEntitiesContext? = nil, count: Int? = nil) {
        self.feature = feature
        self.entity = entity
        self.context = context
        self.count = count
    }
}

extension QueryEntities: Codable {

    private enum CodingKeys: String, CodingKey {
        case feature = "feature"
        case entity = "entity"
        case context = "context"
        case count = "count"
        static let allValues = [feature, entity, context, count]
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        feature = try container.decodeIfPresent(String.self, forKey: .feature)
        entity = try container.decodeIfPresent(QueryEntitiesEntity.self, forKey: .entity)
        context = try container.decodeIfPresent(QueryEntitiesContext.self, forKey: .context)
        count = try container.decodeIfPresent(Int.self, forKey: .count)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(feature, forKey: .feature)
        try container.encodeIfPresent(entity, forKey: .entity)
        try container.encodeIfPresent(context, forKey: .context)
        try container.encodeIfPresent(count, forKey: .count)
    }

}
