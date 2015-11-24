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

    public var text: String?
    public var relevance: Int?
    public var knowledgeGraph: KnowledgeGraph?
    public var website: String?
    public var geo: String?
    public var dbpedia: String?
    public var yago: String?
    public var opencyc: String?
    public var freebase: String?
    public var ciaFactbook: String?
    public var census: String?
    public var geonames: String?
    public var musicBrainz: String?
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
