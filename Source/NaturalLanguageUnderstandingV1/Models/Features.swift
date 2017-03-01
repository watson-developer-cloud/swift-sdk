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

/** Analysis features and options. */
public struct Features: JSONEncodable {
    
    /// Whether or not to return the concepts that are mentioned in the analyzed text.
    public let concepts: ConceptsOptions?
    
    /// Whether or not to extract the emotions implied in the analyzed text.
    public let emotion: EmotionOptions?
    
    /// Whether or not to extract detected entity objects from the analyzed text.
    public let entities: EntitiesOptions?
    
    /// Whether or not to return the keywords in the analyzed text.
    public let keywords: KeywordsOptions?
    
    /// Whether or not the author, publication date, and title of the analyzed text should be returned.
    /// This parameter is only available for URL and HTML input.
    public let metadata: MetadataOptions?
    
    /// Whether or not to return the relationships between detected entities in the analyzed text.
    public let relations: RelationsOptions?
    
    /// Whether or not to return the subject-action-object relations from the analyzed text.
    public let semanticRoles: SemanticRolesOptions?
    
    /// Whether or not to return the overall sentiment of the analyzed text.
    public let sentiment: SentimentOptions?
    
    /// Wether or not to return the high level category the content is categorized as (i.e. news, art).
    public let categories: CategoriesOptions?

    /**
    Initialize a `Features` object. You must include at least one feature.

     - parameter concepts: Whether or not to return the concepts that are mentioned in the analyzed 
        text.
     - parameter emotion: Whether or not to extract the emotions implied in the analyzed text.
     - parameter entities: Whether or not to extract detected entity objects from the analyzed text.
     - parameter keywords: Whether or not to return the keywords in the analyzed text.
     - parameter metadata: Whether or not the author, publication date, and title of the analyzed text 
        should be returned. This is only available for URL and HTML input.
     - parameter relations: Whether or not to return the relationships between detected entities in the 
        analyzed text.
     - parameter semanticRoles: Whether or not to return the subject-action-object relations from the 
        analyzed text.
     - parameter sentiment: Whether or not to return the overall sentiment of the analyzed text.
     - parameter categories: Whether or not to return the high level category the content is categorized 
        as (i.e. news, art).

    - returns: An initialized `Features`.
    */
    public init(
        concepts: ConceptsOptions? = nil,
        emotion: EmotionOptions? = nil,
        entities: EntitiesOptions? = nil,
        keywords: KeywordsOptions? = nil,
        metadata: MetadataOptions? = nil,
        relations: RelationsOptions? = nil,
        semanticRoles: SemanticRolesOptions? = nil,
        sentiment: SentimentOptions? = nil,
        categories: CategoriesOptions? = nil)
    {
        self.concepts = concepts
        self.emotion = emotion
        self.entities = entities
        self.keywords = keywords
        self.metadata = metadata
        self.relations = relations
        self.semanticRoles = semanticRoles
        self.sentiment = sentiment
        self.categories = categories
    }

    /// Used internally to serialize a `Features` model to JSON.
    public func toJSONObject() -> Any {
        var json = [String: Any]()
        if let concepts = concepts { json["concepts"] = concepts.toJSONObject() }
        if let emotion = emotion { json["emotion"] = emotion.toJSONObject() }
        if let entities = entities { json["entities"] = entities.toJSONObject() }
        if let keywords = keywords { json["keywords"] = keywords.toJSONObject() }
        if let metadata = metadata { json["metadata"] = metadata.toJSONObject() }
        if let relations = relations { json["relations"] = relations.toJSONObject() }
        if let semanticRoles = semanticRoles { json["semantic_roles"] = semanticRoles.toJSONObject() }
        if let sentiment = sentiment { json["sentiment"] = sentiment.toJSONObject() }
        if let categories = categories { json["categories"] = categories.toJSONObject() }
        return json
    }
}
