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
 
 **DocumentUrl**
 
 Information about the Document. May include url, author, title, etc.
 
 */
public struct DocumentUrl: JSONDecodable {
    
    /** title of the document */
    public let title: String?
    
    /** url where the document is located */
    public let url: String?
    
    /** the author of the document */
    public let author: String?
    
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
    
    /** see **EnrichedTitle** */
    public let enrichedTitle: EnrichedTitle?

    /** an image within the document */
    public let image: String?
    
    /** see **ImageKeyword** */
    public let imageKeywords: [ImageKeyword]?
    
    /** see **Feed** */
    public let feeds: [Feed]?
    
    /** a cleaned version of the raw title */
    public let cleanedTitle: String?
    
    /** see **PublicationDate** */
    public let publicationDate: PublicationDate?
    
    /** a snipit of the document's text. This is largely for reference, the document's enture text
     is taken into account when running analysis */
    public let text: String?
    
    /// used internally to initialize a DocumentUrl object
    public init(json: JSON) throws {
        title = try? json.getString(at: "title")
        url = try? json.getString(at: "url")
        author = try? json.getString(at: "author")
        entities = try? json.decodedArray(at: "entities", type: Entity.self)
        relations = try? json.decodedArray(at: "relations", type: SAORelation.self)
        taxonomy = try? json.decodedArray(at: "taxonomy", type: Taxonomy.self)
        sentiment = try? json.decodedArray(at: "sentiment", type: Sentiment.self)
        keywords = try? json.decodedArray(at: "keywords", type: Keyword.self)
        concepts = try? json.decodedArray(at: "concept", type: Concept.self)
        enrichedTitle = try? json.decode(at: "enrichedTitle", type: EnrichedTitle.self)
        
        image = try? json.getString(at: "image")
        imageKeywords = try? json.decodedArray(at: "imageKeywords", type: ImageKeyword.self)
        feeds = try? json.decodedArray(at: "feeds", type: Feed.self)
        cleanedTitle = try? json.getString(at: "cleanedTitle")
        publicationDate = try? json.decode(at: "publicationDate", type: PublicationDate.self)
        text = try? json.getString(at: "text")
    }
    
}
