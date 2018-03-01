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

/**

 **EnrichedTitle**

 Enriched information related to a document's title, defined by the inital query parameters

 */
public struct EnrichedTitle: JSONDecodable {

    /** see **Entity** */
    public let entities: [Entity]?

    /** see **SAORelation** */
    public let relations: [SAORelation]?

    /** see **Taxonomy** */
    public let taxonomy: [Taxonomy]?

    /** see **Sentiment** */
    public let sentiment: [Sentiment]?

    /** see **Keyword** */
    public let keywords: [Keyword]?

    /** see **Concept** */
    public let concepts: [Concept]?

    /// used internally to initialize an EnrichedTitle object
    public init(json: JSONWrapper) throws {
        entities = try? json.decodedArray(at: "entities", type: Entity.self)
        relations = try? json.decodedArray(at: "relations", type: SAORelation.self)
        taxonomy = try? json.decodedArray(at: "taxonomy", type: Taxonomy.self)
        sentiment = try? json.decodedArray(at: "sentiment", type: Sentiment.self)
        keywords = try? json.decodedArray(at: "keywords", type: Keyword.self)
        concepts = try? json.decodedArray(at: "concept", type: Concept.self)
    }

}
