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

/** NluEnrichmentFeatures. */
public struct NluEnrichmentFeatures: Codable, Equatable {

    /**
     An object specifying the Keyword enrichment and related parameters.
     */
    public var keywords: NluEnrichmentKeywords?

    /**
     An object speficying the Entities enrichment and related parameters.
     */
    public var entities: NluEnrichmentEntities?

    /**
     An object specifying the sentiment extraction enrichment and related parameters.
     */
    public var sentiment: NluEnrichmentSentiment?

    /**
     An object specifying the emotion detection enrichment and related parameters.
     */
    public var emotion: NluEnrichmentEmotion?

    /**
     An object that indicates the Categories enrichment will be applied to the specified field.
     */
    public var categories: NluEnrichmentCategories?

    /**
     An object specifiying the semantic roles enrichment and related parameters.
     */
    public var semanticRoles: NluEnrichmentSemanticRoles?

    /**
     An object specifying the relations enrichment and related parameters.
     */
    public var relations: NluEnrichmentRelations?

    /**
     An object specifiying the concepts enrichment and related parameters.
     */
    public var concepts: NluEnrichmentConcepts?

    // Map each property name to the key that shall be used for encoding/decoding.
    private enum CodingKeys: String, CodingKey {
        case keywords = "keywords"
        case entities = "entities"
        case sentiment = "sentiment"
        case emotion = "emotion"
        case categories = "categories"
        case semanticRoles = "semantic_roles"
        case relations = "relations"
        case concepts = "concepts"
    }

    /**
     Initialize a `NluEnrichmentFeatures` with member variables.

     - parameter keywords: An object specifying the Keyword enrichment and related parameters.
     - parameter entities: An object speficying the Entities enrichment and related parameters.
     - parameter sentiment: An object specifying the sentiment extraction enrichment and related parameters.
     - parameter emotion: An object specifying the emotion detection enrichment and related parameters.
     - parameter categories: An object that indicates the Categories enrichment will be applied to the specified
       field.
     - parameter semanticRoles: An object specifiying the semantic roles enrichment and related parameters.
     - parameter relations: An object specifying the relations enrichment and related parameters.
     - parameter concepts: An object specifiying the concepts enrichment and related parameters.

     - returns: An initialized `NluEnrichmentFeatures`.
    */
    public init(
        keywords: NluEnrichmentKeywords? = nil,
        entities: NluEnrichmentEntities? = nil,
        sentiment: NluEnrichmentSentiment? = nil,
        emotion: NluEnrichmentEmotion? = nil,
        categories: NluEnrichmentCategories? = nil,
        semanticRoles: NluEnrichmentSemanticRoles? = nil,
        relations: NluEnrichmentRelations? = nil,
        concepts: NluEnrichmentConcepts? = nil
    )
    {
        self.keywords = keywords
        self.entities = entities
        self.sentiment = sentiment
        self.emotion = emotion
        self.categories = categories
        self.semanticRoles = semanticRoles
        self.relations = relations
        self.concepts = concepts
    }

}
