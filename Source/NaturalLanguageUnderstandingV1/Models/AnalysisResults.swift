/**
 * Copyright IBM Corporation 2018
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

/**
 Results of the analysis, organized by feature.
 */
public struct AnalysisResults: Decodable {

    /**
     Language used to analyze the text.
     */
    public var language: String?

    /**
     Text that was used in the analysis.
     */
    public var analyzedText: String?

    /**
     URL that was used to retrieve HTML content.
     */
    public var retrievedUrl: String?

    /**
     API usage information for the request.
     */
    public var usage: Usage?

    /**
     The general concepts referenced or alluded to in the specified content.
     */
    public var concepts: [ConceptsResult]?

    /**
     The important entities in the specified content.
     */
    public var entities: [EntitiesResult]?

    /**
     The important keywords in content organized by relevance.
     */
    public var keywords: [KeywordsResult]?

    /**
     The hierarchical 5-level taxonomy the content is categorized into.
     */
    public var categories: [CategoriesResult]?

    /**
     The anger, disgust, fear, joy, or sadness conveyed by the content.
     */
    public var emotion: EmotionResult?

    /**
     The metadata holds author information, publication date and the title of the text/HTML content.
     */
    public var metadata: MetadataResult?

    /**
     The relationships between entities in the content.
     */
    public var relations: [RelationsResult]?

    /**
     The subjects of actions and the objects the actions act upon.
     */
    public var semanticRoles: [SemanticRolesResult]?

    /**
     The sentiment of the content.
     */
    public var sentiment: SentimentResult?

    // Map each property name to the key that shall be used for encoding/decoding.
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
    }

}
