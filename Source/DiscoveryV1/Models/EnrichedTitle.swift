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

/** A result produced by the Discovery service to analyze the input provided. */
public struct EnrichedTitle: JSONDecodable {

    /// Status of the document analyzed with enrichments.
    public let status: String?

    /// The attitude, opinion or feeling toward something such as a person, product,
    /// organization or location.
    public let documentSentiment: Sentiment?

    /// The extracted topic categories.
    public let taxonomy: [Taxonomy]?

    /// The relations between entities (such as people, locations, organizations, events,
    /// and the relationships between these entities.
    public let relations: [Relation]?

    /// Entities
    public let entities: [Entity]?

    /// The text of the document title.
    public let text: String?

    /// Concepts within the document.
    public let concepts: [Concept]?

    /// Keywords found.
    public let keywords: [Keyword]?

    /// The raw JSON object used to construct this model.
    public let json: [String: Any]

    /// Used internally to initialize an `EnrichedTitle` object from JSON.
    public init(json: JSONWrapper) throws {
        status = try? json.getString(at: "status")
        documentSentiment = try? json.decode(at: "docSentiment", type: Sentiment.self)
        taxonomy = try? json.decodedArray(at: "taxonomy", type: Taxonomy.self)
        relations = try? json.decodedArray(at: "relations", type: Relation.self)
        entities = try? json.decodedArray(at: "entities", type: Entity.self)
        text = try? json.getString(at: "text")
        concepts = try? json.decodedArray(at: "concepts", type: Concept.self)
        keywords = try? json.decodedArray(at: "keywords", type: Keyword.self)
        self.json = try json.getDictionaryObject()
    }

    /// Used internally to serialize an 'EnrichedTitle' model to JSON.
    public func toJSONObject() -> Any {
        return json
    }
}
