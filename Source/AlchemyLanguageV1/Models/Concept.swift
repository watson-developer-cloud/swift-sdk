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
 
 Returned by the AlchemyLanguage service.
 
 */
extension AlchemyLanguageV1 {
    
    public struct Concept: JSONDecodable {
        public let text: String?
        public let relevance: Double?
        public let knowledgeGraph: KnowledgeGraph?
        public let website: String?
        public let geo: String?
        public let dbpedia: String?
        public let yago: String?
        public let opencyc: String?
        public let freebase: String?
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
}