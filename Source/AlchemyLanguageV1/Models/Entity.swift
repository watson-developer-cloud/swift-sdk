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
 
 **Entity**
 
 A named entity (a person, company, organization, etc) extracted from a document by Alchemy services
 
 */

public struct Entity: JSONDecodable {
    /** how often this entity is seen */
    public let count: Int?
    /** disambiguation information for the detected entity (sent only if disambiguation occurred) */
    public let disambiguated: DisambiguatedLinks?
    /** see **KnowledgeGraph** */
    public let knowledgeGraph: KnowledgeGraph?
    /** example usage of our keyword */
    public let quotations: [Quotation]?
    /** relevance to content */
    public let relevance: Double?
    /** sentiment concerning keyword */
    public let sentiment: Sentiment?
    /** surrounding text */
    public let text: String?
    /** Classification */
    public let type: String?
    
    /// Used internally to initialize an Entity object
    public init(json: JSON) throws {
        if let countString = try? json.getString(at: "count") {
            count = Int(countString)
        } else {
            count = nil
        }
        disambiguated = try? json.decode(at: "disambiguated", type: DisambiguatedLinks.self)
        knowledgeGraph = try? json.decode(at: "knowledgeGraph", type: KnowledgeGraph.self)
        quotations = try? json.decodedArray(at: "quotations", type: Quotation.self)
        if let relevanceString = try? json.getString(at: "relevance") {
            relevance = Double(relevanceString)
        } else {
            relevance = nil
        }
        sentiment = try? json.decode(at: "sentiment", type: Sentiment.self)
        text = try? json.getString(at: "text")
        type = try? json.getString(at: "type")
    }
}

