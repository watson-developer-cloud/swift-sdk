/**
 * Copyright IBM Corporation 2015
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

/** A named entity (a person, company, organization, etc) extracted from a document. */
public struct Entity: JSONDecodable {

    /// How often this entity is seen.
    public let count: Int?

    /// Disambiguation information for the detected entity (sent only if disambiguation occurred).
    public let disambiguated: DisambiguatedLinks?

    /// See **KnowledgeGraph**.
    public let knowledgeGraph: KnowledgeGraph?

    /// Relevance to content.
    public let relevance: Double?

    /// Sentiment concerning keyword.
    public let sentiment: Sentiment?

    /// Surrounding text of the entity.
    public let text: String?

    /// Classification of the entity.
    public let type: String?

    /// The raw JSON object used to construct this model.
    public let json: [String: Any]

    /// Used internally to initialize an `Entity` object from JSON.
    public init(json: JSONWrapper) throws {
        count = try? json.getInt(at: "count")
        disambiguated = try? json.decode(at: "disambiguated", type: DisambiguatedLinks.self)
        knowledgeGraph = try? json.decode(at: "knowledgeGraph", type: KnowledgeGraph.self)
        relevance = try? json.getDouble(at: "relevance")
        sentiment = try? json.decode(at: "sentiment", type: Sentiment.self)
        text = try? json.getString(at: "text")
        type = try? json.getString(at: "type")
        self.json = try json.getDictionaryObject()
    }

    /// Used internally to serialize an 'Entity' model to JSON.
    public func toJSONObject() -> Any {
        return json
    }
}
