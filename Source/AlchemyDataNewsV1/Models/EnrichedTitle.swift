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

/**
 
 **EnrichedTitle**
 
 Enriched information related to a document's title, defined by the inital query parameters
 
 */
public struct EnrichedTitle: JSONDecodable {
    
    /** see **Entity** */
    public let entities: [Entity]?
    
    /** see **SAORelation** */
    public let relations: [SAORelation]?
    
    /** see **Taxonomy** */
    public let taxonomy: [Taxonomy]?
    
    /** see **Sentiment** */
    public let sentiment: [Sentiment]?
    
    /** see **Keyword** */
    public let keywords: [Keyword]?
    
    /** see **Concept** */
    public let concepts: [Concept]?
    
    /// used internally to initialize an EnrichedTitle object
    public init(json: [String: Any]) throws {
        entities = try? json.objects(at: "entities")
        relations = try? json.objects(at: "relations")
        taxonomy = try? json.objects(at: "taxonomy")
        sentiment = try? json.objects(at: "sentiment")
        keywords = try? json.objects(at: "keywords")
        concepts = try? json.objects(at: "concept")
    }
    
}
