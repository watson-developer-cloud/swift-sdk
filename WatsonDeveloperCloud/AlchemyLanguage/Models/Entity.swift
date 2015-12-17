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
 
 **Entity**
 
 Returned by the AlchemyLanguage & AlchemyDataNews services.
 
 */
public struct Entity: AlchemyGenericModel, Mappable {
    
    // MARK: AlchemyGenericModel
    public var totalTransactions: Int?
    
    // MARK: Entity
    /** how often this entity is seen */
    public var count: Int?

    /** disambiguation information for the detected entity (sent only if disambiguation occurred) */
    public var disambiguated: DisambiguatedLinks?

    /** see **KnowledgeGraph** */
    public var knowledgeGraph: KnowledgeGraph?

    /** example usage of our keyword */
    public var quotations: [Quotation]? = []

    /** relevance to content */
    public var relevance: Double?

    /** sentiment concerning keyword */
    public var sentiment: Sentiment?

    /** surrounding text */
    public var text: String?

    /** Person, City, Country */
    public var type: String?
    
    
    public init?(_ map: Map) {}
    
    public mutating func mapping(map: Map) {
        
        // alchemyGenericModel
        totalTransactions <- (map["totalTransactions"], Transformation.stringToInt)
        
        // entity
        count <- map["count"]
        disambiguated <- map["disambiguated"]
        knowledgeGraph <- map["knowledgeGraph"]
        quotations <- map["quotations"]
        relevance <- map["relevance"]
        sentiment <- map["sentiment"]
        text <- map["text"]
        type <- map["type"]
        
    }
    
}
