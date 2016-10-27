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
import RestKit

/**
 
 **Keyword**
 
 Important topics extracted from a document by AlchemyLanguage
 
 */

public struct Keyword: JSONDecodable {
    
    /** see **KnowledgeGraph** */
    public let knowledgeGraph: KnowledgeGraph?
    
    /** relevance score for detected keyword */
    public let relevance: Double?
    
    /** see **Sentiment** */
    public let sentiment: Sentiment?
    
    /** the detected keyword text */
    public let text: String?
    
    /// Used internally to initialize a Keyword object
    public init(json: JSON) throws {
        knowledgeGraph = try? json.decode(at: "knowledgeGraph", type: KnowledgeGraph.self)
        if let relevanceString = try? json.getString(at: "relevance") {
            relevance = Double(relevanceString)
        } else {
            relevance = nil
        }
        sentiment = try? json.decode(at: "sentiment", type: Sentiment.self)
        text = try? json.getString(at: "text")
    }
}

