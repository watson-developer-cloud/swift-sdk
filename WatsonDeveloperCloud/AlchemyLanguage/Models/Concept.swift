/**
 * Copyright 2015 IBM Corp. All Rights Reserved.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import Foundation
import ObjectMapper

/**
 
 **Concept**
 
 Returned by the AlchemyLanguage service.
 
 */
public struct Concept: Mappable {

    /** detected concept tag*/
    public var text: String?

    /** 
    relevance score for a detected concept tag.

    Possible values: (0.0 - 1.0)   [1.0 = most relevant]
    */
    public var relevance: Int?

    // linked data for the detected concept tag (sent only if linkedData is enabled)
    /** 
    The path through the knowledge graph to the appropriate keyword. Only returned when request parameter is provided: knowledgeGraph=1
    */
    public var knowledgeGraph: KnowledgeGraph?

    /** the website associated with this concept tag */
    public var website: String?

    /** latitude longitude - the geographic coordinates associated with this concept tag */
    public var geo: String?

    /**  
    sameAs link to DBpedia for this concept tag

    Note: Provided only for entities that exist in this linked data-set
    */
    public var dbpedia: String?

    /**  
    sameAs link to YAGO for this concept tag

    Note: Provided only for entities that exist in this linked data-set
    */
    public var yago: String?

    /**  s
    ameAs link to OpenCyc for this concept tag

    Note: Provided only for entities that exist in this linked data-set
    */
    public var opencyc: String?

    /**  
    sameAs link to Freebase for this concept tag.

    Note: Provided only for entities that exist in this linked data-set
    */
    public var freebase: String?

    /**  
    sameAs link to the CIA World Factbook for this concept tag

    Note: Provided only for entities that exist in this linked data-set
    */
    public var ciaFactbook: String?

    /**     
    sameAs link to the US Census for this concept tag

    Note: Provided only for entities that exist in this linked data-set
    */
    public var census: String?

    /**  
    sameAs link to Geonames for this concept tag

    Note: Provided only for entities that exist in this linked data-set
    */
    public var geonames: String?

    /**  
    sameAs link to MusicBrainz for this concept tag

    Note: Provided only for entities that exist in this linked data-set
    */
    public var musicBrainz: String?

    /**  
    website link to CrunchBase for this concept tag.

    Note: Provided only for entities that exist in CrunchBase.
    */
    public var crunchbase: String?
    
    
    public init?(_ map: Map) {}
    
    public mutating func mapping(map: Map) {

        text <- map["text"]
        relevance <- map["relevance"]
        knowledgeGraph <- map["knowledgeGraph"]
        website <- map["website"]
        geo <- map["geo"]
        dbpedia <- map["dbpedia"]
        yago <- map["yago"]
        opencyc <- map["opencyc"]
        freebase <- map["freebase"]
        ciaFactbook <- map["ciaFactbook"]
        census <- map["census"]
        geonames <- map["geonames"]
        musicBrainz <- map["musicBrainz"]
        crunchbase <- map["crunchbase"]
        
    }
    
}
