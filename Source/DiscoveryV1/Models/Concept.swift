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
import RestKit

/**  A tagged concept extracted from a document. */
public struct Concept: JSONDecodable {

    /// Website referenced by the concept.
    public let website: String?
    
    /// The path through the knowledge graph to the appropriate keyword.
    public let knowledgeGraph: KnowledgeGraph?
    
    /// Link to Freebase data set for this concept tag.
    public let freebase: String?
    
    /// Link to DBpedia for this concept tag.
    public let dbpedia: String?
    
    /// The text of the concept.
    public let text: String?
    
    /// Relevance score for a detected concept tag ranging from [0, 1].
    /// Higher values represent higher relevance.
    public let relevance: Double?
    
    /// Latitude longitude - the geographic coordinates associated with this concept tag.
    public let geo: String?
    
    /// Link to YAGO for this concept tag.
    public let yago: String?
    
    /// Link to OpenCyc for this concept tag.
    public let opencyc: String?
    
    /// Link to the CIA World Factbook for this concept tag.
    public let ciaFactbook: String?
    
    /// Link to the US Census for this concept tag.
    public let census: String?
    
    /// Link to Geonames for this concept tag.
    public let geonames: String?
    
    /// Link to MusicBrainz for this concept tag.
    public let musicBrainz: String?
    
    /// Link to CrunchBase for this concept tag.
    public let crunchbase: String?
    
    /// The raw JSON object used to construct this model.
    public let json: [String: Any]
    
    /// Used internally to initialize a `Concept` object.
    public init(json: JSON) throws {
        website = try? json.getString(at: "website")
        knowledgeGraph = try? json.decode(at: "knowledgeGraph", type: KnowledgeGraph.self)
        freebase = try? json.getString(at: "freebase")
        dbpedia = try? json.getString(at: "dbpedia")
        text = try? json.getString(at: "text")
        relevance = try? json.getDouble(at: "relevance")
        geo = try? json.getString(at: "geo")
        yago = try? json.getString(at: "yago")
        opencyc = try? json.getString(at: "opencyc")
        ciaFactbook = try? json.getString(at: "ciaFactbook")
        census = try? json.getString(at: "census")
        geonames = try? json.getString(at: "geonames")
        musicBrainz = try? json.getString(at: "musicBrainz")
        crunchbase = try? json.getString(at: "crunchbase")
        self.json = try json.getDictionaryObject()
    }
    
    /// Used internally to serialize a 'Concept' model to JSON.
    public func toJSONObject() -> Any {
        return json
    }
}
    
