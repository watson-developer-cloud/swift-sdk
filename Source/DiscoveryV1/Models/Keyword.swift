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

/** Important topics extracted from a document by the Discovery service.*/

public struct Keyword: JSONDecodable {

    /// see **KnowledgeGraph**.
    public let knowledgeGraph: KnowledgeGraph?

    /// Relevance score for detected keyword.
    public let relevance: Double?

    /// See **Sentiment**.
    public let sentiment: Sentiment?

    /// The detected keyword text.
    public let text: String?

    /// The raw JSON object used to construct this model.
    public let json: [String: Any]

    /// Used internally to initialize a Keyword object
    public init(json: JSONWrapper) throws {
        knowledgeGraph = try? json.decode(at: "knowledgeGraph", type: KnowledgeGraph.self)
        relevance = try? json.getDouble(at: "relevance")
        sentiment = try? json.decode(at: "sentiment", type: Sentiment.self)
        text = try? json.getString(at: "text")
        self.json = try json.getDictionaryObject()
    }

    /// Used internally to serialize a 'Keyword' model to JSON.
    public func toJSONObject() -> Any {
        return json
    }
}
