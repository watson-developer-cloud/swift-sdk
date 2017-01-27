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

/** Analysis features and options */
public struct Features: JSONDecodable,JSONEncodable {
    public let concepts: ConceptsOptions?
    public let emotion: EmotionOptions?
    public let entities: EntitiesOptions?
    public let keywords: KeywordsOptions?
    public let metadata: MetadataOptions?
    public let relations: RelationsOptions?
    public let semanticRoles: SemanticRolesOptions?
    public let sentiment: SentimentOptions?
    public let categories: CategoriesOptions?

    /**
     Initialize a `Features` with required member variables.

     - returns: An initialized `Features`.
    */
    public init() {
        self.concepts = nil
        self.emotion = nil
        self.entities = nil
        self.keywords = nil
        self.metadata = nil
        self.relations = nil
        self.semanticRoles = nil
        self.sentiment = nil
        self.categories = nil
    }

    /**
    Initialize a `Features` with all member variables.

     - parameter concepts: 
     - parameter emotion: 
     - parameter entities: 
     - parameter keywords: 
     - parameter metadata: 
     - parameter relations: 
     - parameter semanticRoles: 
     - parameter sentiment: 
     - parameter categories: 

    - returns: An initialized `Features`.
    */
    public init(concepts: ConceptsOptions, emotion: EmotionOptions, entities: EntitiesOptions, keywords: KeywordsOptions, metadata: MetadataOptions, relations: RelationsOptions, semanticRoles: SemanticRolesOptions, sentiment: SentimentOptions, categories: CategoriesOptions) {
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

    // MARK: JSONDecodable
    /// Used internally to initialize a `Features` model from JSON.
    public init(json: JSON) throws {
        concepts = try? json.getJSON(at: "concepts") as! ConceptsOptions
        emotion = try? json.getJSON(at: "emotion") as! EmotionOptions
        entities = try? json.getJSON(at: "entities") as! EntitiesOptions
        keywords = try? json.getJSON(at: "keywords") as! KeywordsOptions
        metadata = try? json.getJSON(at: "metadata") as! MetadataOptions
        relations = try? json.getJSON(at: "relations") as! RelationsOptions
        semanticRoles = try? json.getJSON(at: "semantic_roles") as! SemanticRolesOptions
        sentiment = try? json.getJSON(at: "sentiment") as! SentimentOptions
        categories = try? json.getJSON(at: "categories") as! CategoriesOptions
    }

    // MARK: JSONEncodable
    /// Used internally to serialize a `Features` model to JSON.
    public func toJSONObject() -> Any {
        var json = [String: Any]()
        if let concepts = concepts { json["concepts"] = concepts }
        if let emotion = emotion { json["emotion"] = emotion }
        if let entities = entities { json["entities"] = entities }
        if let keywords = keywords { json["keywords"] = keywords }
        if let metadata = metadata { json["metadata"] = metadata }
        if let relations = relations { json["relations"] = relations }
        if let semanticRoles = semanticRoles { json["semantic_roles"] = semanticRoles }
        if let sentiment = sentiment { json["sentiment"] = sentiment }
        if let categories = categories { json["categories"] = categories }
        return json
    }
}
