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
import Freddy

/**
 
 **Concept**
 
 A tagged concept extracted from a document. The concept may or may not have been explicitly
 mentioned. For example if an article mentions CERN and the Higgs boson, it will tag Large Hadron 
 Collider as a concept even if the term is not mentioned explicitly in the page.
 
 */


public struct Concept: JSONDecodable {
    
    /** detected concept tag*/
    public let text: String?
    
    /**
     relevance score for a detected concept tag.
     Possible values: (0.0 - 1.0)   [1.0 = most relevant]
     */
    public let relevance: Double?
    
    /**
     The path through the knowledge graph to the appropriate keyword. Only returned when request
     parameter is provided: knowledgeGraph=1
     */
    public let knowledgeGraph: KnowledgeGraph?
    
    /** the website associated with this concept tag */
    public let website: String?
    
    /** latitude longitude - the geographic coordinates associated with this concept tag */
    public let geo: String?
    
    /**
     sameAs link to DBpedia for this concept tag
     Note: Provided only for entities that exist in this linked data-set
     */
    public let dbpedia: String?
    
    /**
     sameAs link to YAGO for this concept tag
     Note: Provided only for entities that exist in this linked data-set
     */
    public let yago: String?
    
    /**
     sameAs link to OpenCyc for this concept tag
     Note: Provided only for entities that exist in this linked data-set
     */
    public let opencyc: String?
    
    /**
     sameAs link to Freebase for this concept tag.
     Note: Provided only for entities that exist in this linked data-set
     */
    public let freebase: String?
    
    /**
     sameAs link to the CIA World Factbook for this concept tag
     Note: Provided only for entities that exist in this linked data-set
     */
    public let ciaFactbook: String?
    
    /**
     sameAs link to the US Census for this concept tag
     
     Note: Provided only for entities that exist in this linked data-set
     */
    public let census: String?
    
    /**
     sameAs link to Geonames for this concept tag
     
     Note: Provided only for entities that exist in this linked data-set
     */
    public let geonames: String?
    
    /**
     sameAs link to MusicBrainz for this concept tag
     
     Note: Provided only for entities that exist in this linked data-set
     */
    public let musicBrainz: String?
    
    /**
     website link to CrunchBase for this concept tag.
     
     Note: Provided only for entities that exist in CrunchBase.
     */
    public let crunchbase: String?
    
    /// Used internally to initialize a Concept object
    public init(json: JSON) throws {
        text = try? json.string("text")
        if let relevanceString = try? json.string("relevance") {
            relevance = Double(relevanceString)
        } else {
            relevance = nil
        }
        knowledgeGraph = try? json.decode("knowledgeGraph", type: KnowledgeGraph.self)
        website = try? json.string("website")
        geo = try? json.string("geo")
        dbpedia = try? json.string("dbpedia")
        yago = try? json.string("yago")
        opencyc = try? json.string("opencyc")
        freebase = try? json.string("freebase")
        ciaFactbook = try? json.string("ciaFactbook")
        census = try? json.string("census")
        geonames = try? json.string("geonames")
        musicBrainz = try? json.string("musicBrainz")
        crunchbase = try? json.string("crunchbase")
    }
}
