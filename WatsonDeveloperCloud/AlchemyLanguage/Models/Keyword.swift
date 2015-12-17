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
 
 **Keyword**
 
 Returned by the AlchemyLanguage service.
 
 */
public struct Keyword: Mappable {

    /** The path through the knowledge graph to the appropriate keyword */
    public var knowledgeGraph: KnowledgeGraph?

    /** relevance to inputted content */
    public var relevance: Double?

    /** sentiment concerning content */
    public var sentiment: Sentiment?

    /** related text */
    public var text: String?
    
    
    public init?(_ map: Map) {}
    
    public mutating func mapping(map: Map) {
        
        knowledgeGraph <- map["knowledgeGraph"]
        relevance <- (map["relevance"], Transformation.stringToDouble)
        sentiment <- map["sentiment"]
        text <- map["text"]
        
    }
    
}
