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
import RestKit

/** An object containing the results returned by the NLU service. */
public struct AnalysisResults: JSONDecodable {
    
    /// Language used to analyze the text.
    public let language: String?
    
    /// Text that was used in the analysis.
    public let analyzedText: String?
    
    /// URL that was used to retrieve HTML content.
    public let retrievedUrl: String?
    
    /// The number of features used in the API call.
    public let usage: Usage?
    
    /// The general concepts referenced or alluded to in the specified content.
    public let concepts: [ConceptsResult]?
    
    /// The important entities in the specified content.
    public let entities: [EntitiesResult]?
    
    /// The important keywords in content organized by relevance.
    public let keywords: [KeywordsResult]?
    
    /// The hierarchical 5-level taxonomy the content is categorized into.
    public let categories: [CategoriesResult]?
    
    /// The anger, disgust, fear, joy, or sadness conveyed by the content.
    public let emotion: EmotionResult?
    
    /// The metadata holds author information, publication date and the title of the text/HTML content.
    public let metadata: MetadataResult?
    
    /// The relationships between entities in the content.
    public let relations: [RelationsResult]?
    
    /// The subjects of actions and the objects the actions act upon.
    public let semanticRoles: [SemanticRolesResult]?
    
    /// The sentiment of the content.
    public let sentiment: SentimentResult?
    
    /// Used internally to initialize a `AnalysisResults` model from JSON.
    public init(json: JSON) throws {
        language = try? json.getString(at: "language")
        analyzedText = try? json.getString(at: "analyzed_text")
        retrievedUrl = try? json.getString(at: "retrieved_url")
        usage = try? json.decode(at: "usage", type: Usage.self)
        concepts = try? json.decodedArray(at: "concepts", type: ConceptsResult.self)
        entities = try? json.decodedArray(at: "entities", type: EntitiesResult.self)
        keywords = try? json.decodedArray(at: "keywords", type: KeywordsResult.self)
        categories = try? json.decodedArray(at: "categories", type: CategoriesResult.self)
        emotion = try? json.decode(at: "emotion", type: EmotionResult.self)
        metadata = try? json.decode(at: "metadata", type: MetadataResult.self)
        relations = try? json.decodedArray(at: "relations", type: RelationsResult.self)
        semanticRoles = try? json.decodedArray(at: "semantic_roles", type: SemanticRolesResult.self)
        sentiment = try? json.decode(at: "sentiment", type: SentimentResult.self)
    }
}

/** An object containing how many features used. */
public struct Usage: JSONDecodable {
    
    /// The number of features used in the API call.
    public let features: Int
    
    /// Used internally to initialize a 'Usage' model from JSON.
    public init(json: JSON) throws {
        features = try json.getInt(at: "features")
    }
}
