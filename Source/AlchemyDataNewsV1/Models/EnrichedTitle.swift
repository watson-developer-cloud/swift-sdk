/**
 * Copyright IBM Corporation 2016
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
import Freddy

public struct EnrichedTitle: JSONDecodable {
    
    public let entities: [Entity]?
    public let relations: [SAORelation]?
    public let taxonomy: [Taxonomy]?
    // I'm not sure the following exist, but they might
    public let sentiment: [Sentiment]?
    public let keywords: [Keyword]?
    public let concepts: [Concept]?
    
    public init(json: JSON) throws {
        entities = try? json.arrayOf("entities", type: Entity.self)
        relations = try? json.arrayOf("relations", type: SAORelation.self)
        taxonomy = try? json.arrayOf("taxonomy", type: Taxonomy.self)
        sentiment = try? json.arrayOf("sentiment", type: Sentiment.self)
        keywords = try? json.arrayOf("keywords", type: Keyword.self)
        concepts = try? json.arrayOf("concept", type: Concept.self)
    }
    
}
