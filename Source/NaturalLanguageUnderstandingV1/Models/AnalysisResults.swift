/**
 * Copyright IBM Corporation 2019
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
 Analysis results for each requested feature.
 */
public struct AnalysisResults: Codable, Equatable {

    /**
     Language used to analyze the text.
     */
    public var language: String?

    /**
     Text that was used in the analysis.
     */
    public var analyzedText: String?

    /**
     URL of the webpage that was analyzed.
     */
    public var retrievedURL: String?

    /**
     API usage information for the request.
     */
    public var usage: AnalysisResultsUsage?

    /**
     The general concepts referenced or alluded to in the analyzed text.
     */
    public var concepts: [ConceptsResult]?

    /**
     The entities detected in the analyzed text.
     */
    public var entities: [EntitiesResult]?

    /**
     The keywords from the analyzed text.
     */
    public var keywords: [KeywordsResult]?

    /**
     The categories that the service assigned to the analyzed text.
     */
    public var categories: [CategoriesResult]?

    /**
     The anger, disgust, fear, joy, or sadness conveyed by the content.
     */
    public var emotion: EmotionResult?

    /**
     Webpage metadata, such as the author and the title of the page.
     */
    public var metadata: AnalysisResultsMetadata?

    /**
     The relationships between entities in the content.
     */
    public var relations: [RelationsResult]?

    /**
     Sentences parsed into `subject`, `action`, and `object` form.
     */
    public var semanticRoles: [SemanticRolesResult]?

    /**
     The sentiment of the content.
     */
    public var sentiment: SentimentResult?

    /**
     Tokens and sentences returned from syntax analysis.
     */
    public var syntax: SyntaxResult?

    // Map each property name to the key that shall be used for encoding/decoding.
    private enum CodingKeys: String, CodingKey {
        case language = "language"
        case analyzedText = "analyzed_text"
        case retrievedURL = "retrieved_url"
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
        case syntax = "syntax"
    }

}
