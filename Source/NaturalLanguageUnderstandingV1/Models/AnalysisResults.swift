/**
 * Copyright IBM Corporation 2017
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

/** Results of the analysis, organized by feature. */
public struct AnalysisResults {

    /// Language used to analyze the text.
    public var language: String?

    /// Text that was used in the analysis.
    public var analyzedText: String?

    /// URL that was used to retrieve HTML content.
    public var retrievedUrl: String?

    /// API usage information for the request.
    public var usage: Usage?

    /// The general concepts referenced or alluded to in the specified content.
    public var concepts: [ConceptsResult]?

    /// The important entities in the specified content.
    public var entities: [EntitiesResult]?

    /// The important keywords in content organized by relevance.
    public var keywords: [KeywordsResult]?

    /// The hierarchical 5-level taxonomy the content is categorized into.
    public var categories: [CategoriesResult]?

    /// The anger, disgust, fear, joy, or sadness conveyed by the content.
    public var emotion: EmotionResult?

    /// The metadata holds author information, publication date and the title of the text/HTML content.
    public var metadata: MetadataResult?

    /// The relationships between entities in the content.
    public var relations: [RelationsResult]?

    /// The subjects of actions and the objects the actions act upon.
    public var semanticRoles: [SemanticRolesResult]?

    /// The sentiment of the content.
    public var sentiment: SentimentResult?

    /**
     Initialize a `AnalysisResults` with member variables.

     - parameter concepts: The general concepts referenced or alluded to in the specified content.
     - parameter entities: The important entities in the specified content.
     - parameter keywords: The important keywords in content organized by relevance.
     - parameter categories: The hierarchical 5-level taxonomy the content is categorized into.
     - parameter emotion: The anger, disgust, fear, joy, or sadness conveyed by the content.
     - parameter metadata: The metadata holds author information, publication date and the title of the text/HTML content.
     - parameter relations: The relationships between entities in the content.
     - parameter semanticRoles: The subjects of actions and the objects the actions act upon.
     - parameter sentiment: The sentiment of the content.
     - parameter language: Language used to analyze the text.
     - parameter analyzedText: Text that was used in the analysis.
     - parameter retrievedUrl: URL that was used to retrieve HTML content.
     - parameter usage: API usage information for the request.

     - returns: An initialized `AnalysisResults`.
    */
    public init(concepts: [ConceptsResult]? = nil, entities: [EntitiesResult]? = nil, keywords: [KeywordsResult]? = nil, categories: [CategoriesResult]? = nil, emotion: EmotionResult? = nil, metadata: MetadataResult? = nil, relations: [RelationsResult]? = nil, semanticRoles: [SemanticRolesResult]? = nil, sentiment: SentimentResult? = nil, language: String? = nil, analyzedText: String? = nil, retrievedUrl: String? = nil, usage: Usage? = nil) {
        self.concepts = concepts
        self.entities = entities
        self.keywords = keywords
        self.categories = categories
        self.emotion = emotion
        self.metadata = metadata
        self.relations = relations
        self.semanticRoles = semanticRoles
        self.sentiment = sentiment
        self.language = language
        self.analyzedText = analyzedText
        self.retrievedUrl = retrievedUrl
        self.usage = usage
    }
}

extension AnalysisResults: Codable {

    private enum CodingKeys: String, CodingKey {
        case language = "language"
        case analyzedText = "analyzed_text"
        case retrievedUrl = "retrieved_url"
        case usage = "usage"
        case concepts = "concepts"
        case entities = "entities"
        case keywords = "keywords"
        case categories = "categories"
        case emotion = "emotion"
        case metadata = "metadata"
        case relations = "relations"
        case semanticRoles = "semantic_roles"
        case sentiment = "sentiment"
        static let allValues = [language, analyzedText, retrievedUrl, usage, concepts, entities, keywords, categories, emotion, metadata, relations, semanticRoles, sentiment]
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        language = try container.decodeIfPresent(String.self, forKey: .language)
        analyzedText = try container.decodeIfPresent(String.self, forKey: .analyzedText)
        retrievedUrl = try container.decodeIfPresent(String.self, forKey: .retrievedUrl)
        usage = try container.decodeIfPresent(Usage.self, forKey: .usage)
        concepts = try container.decodeIfPresent([ConceptsResult].self, forKey: .concepts)
        entities = try container.decodeIfPresent([EntitiesResult].self, forKey: .entities)
        keywords = try container.decodeIfPresent([KeywordsResult].self, forKey: .keywords)
        categories = try container.decodeIfPresent([CategoriesResult].self, forKey: .categories)
        emotion = try container.decodeIfPresent(EmotionResult.self, forKey: .emotion)
        metadata = try container.decodeIfPresent(MetadataResult.self, forKey: .metadata)
        relations = try container.decodeIfPresent([RelationsResult].self, forKey: .relations)
        semanticRoles = try container.decodeIfPresent([SemanticRolesResult].self, forKey: .semanticRoles)
        sentiment = try container.decodeIfPresent(SentimentResult.self, forKey: .sentiment)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(language, forKey: .language)
        try container.encodeIfPresent(analyzedText, forKey: .analyzedText)
        try container.encodeIfPresent(retrievedUrl, forKey: .retrievedUrl)
        try container.encodeIfPresent(usage, forKey: .usage)
        try container.encodeIfPresent(concepts, forKey: .concepts)
        try container.encodeIfPresent(entities, forKey: .entities)
        try container.encodeIfPresent(keywords, forKey: .keywords)
        try container.encodeIfPresent(categories, forKey: .categories)
        try container.encodeIfPresent(emotion, forKey: .emotion)
        try container.encodeIfPresent(metadata, forKey: .metadata)
        try container.encodeIfPresent(relations, forKey: .relations)
        try container.encodeIfPresent(semanticRoles, forKey: .semanticRoles)
        try container.encodeIfPresent(sentiment, forKey: .sentiment)
    }

}
