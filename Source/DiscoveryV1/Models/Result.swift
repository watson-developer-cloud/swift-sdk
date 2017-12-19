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

/** A result produced by the Discovery service to analyze the input provided. */
public struct Result: JSONDecodable {
    /// The unique identifier of the document ID
    public let documentID: String?

    /// The confidence score of the result's analysis. Scores range from 0 to 1, with
    /// a higher score indicating greater confidence.
    public let score: Double?

    /// Status of the processed document which can be 'OK', 'ERROR' depending on if
    /// the document type and tags are accepted by the service.
    public let status: String?

    /// The attitude, opinion or feeling toward something such as a person, product,
    /// organization or location.
    public let documentSentiment: Sentiment?

    /// The extracted topic categories.
    public let taxonomy: [Taxonomy]?

    /// Enrichments to the document as specified by the configurations
    public var enrichedTitle: EnrichedTitle?

    /// The publication date of the collection in the format yyyy-MM-dd'T'HH:mm
    /// :ss.SSS'Z'.
    public let publicationDate: PublicationDate?

    /// A list of important topics extracted from the document.
    public let keywords: [Keyword]?

    /// Detected author of the document.
    public let author: String?

    /// The extracted relationships between the subject, action and object
    /// parts of a sentence.
    public let relations: [Relation]?

    /// The named entities extracted from a document.
    public let entities: [Entity]?

    /// Metadata of the document.
    public let extractedMetadata: String?

    /// HTML of the document.
    public let html: String?

    /// Entire text of the document including hyperlinks, url, etc.
    public let text: String?

    /// Results of Blekko search engine.
    public let blekko: BlekkoResult?

    /// Language of the document. If the language is something other than "en" for
    /// english, the document will fail to be processed and the Status of the QueryResponse
    /// will be 'ERROR'
    public let language: String?

    /// Text Alchemy API analyzes. Contains text of the document.
    public let alchemyapiText: String?

    /// Extracted host of the document.
    public let host: String?

    /// Extracted url of the document.
    public let extractedURL: String?

    /// Extracted title of the document.
    public let title: String?

    /// Extracted concepts of the document.
    public let concepts: [Concept]?

    /// A list of aggregations provided by the service.
    public let aggregations: [Aggregation]?

    /// The raw JSON object used to construct this model.
    public let json: [String: Any]

    /// Used internally to initialize a `Result` model from JSON.
    public init(json: JSONWrapper) throws {
        documentID = try? json.getString(at: "id")
        score = try? json.getDouble(at: "score")
        status = try? json.getString(at: "status")
        documentSentiment = try? json.decode(at: "docSentiment", type: Sentiment.self)
        taxonomy = try? json.decodedArray(at: "taxonomy", type: Taxonomy.self)
        enrichedTitle = try? json.decode(at: "enrichedTitle", type: EnrichedTitle.self)
        if enrichedTitle == nil {
            enrichedTitle = try? json.decode(at: "enriched_text", type: EnrichedTitle.self)
        }
        publicationDate = try? json.decode(at: "publicationDate", type: PublicationDate.self)
        keywords = try? json.decodedArray(at: "keywords", type: Keyword.self)
        author = try? json.getString(at: "author")
        relations = try? json.decodedArray(at: "relations", type: Relation.self)
        entities = try? json.decodedArray(at: "entities", type: Entity.self)
        extractedMetadata = try? json.getString(at: "extracted_metadata", "title")
        html = try? json.getString(at: "html")
        text = try? json.getString(at: "text")
        blekko = try? json.decode(at: "blekko", type: BlekkoResult.self)
        language = try? json.getString(at: "language")
        alchemyapiText = try? json.getString(at: "alchemyapi_text")
        host = try? json.getString(at: "host")
        extractedURL = try? json.getString(at: "url")
        title = try? json.getString(at: "title")
        concepts = try? json.decodedArray(at: "concepts", type: Concept.self)
        aggregations = try? json.decodedArray(at: "aggregations", type: Aggregation.self)
        self.json = try json.getDictionaryObject()
    }

    /// Used internally to serialize a 'Result' model to JSON.
    public func toJSONObject() -> Any {
        return json
    }
}
