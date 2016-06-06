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

public enum EnrichedUrl: String {
    
    case Image = "enriched.url.image"
    case ImageKeywords = "enriched.url.imageKeywords"
    case ImageKeywordText = "enriched.url.imageKeywords.imageKeyword.text"
    case ImageKeywordScore = "enriched.url.imageKeywords.imageKeyword.score"
    case Feeds = "enriched.url.feeds"
    case Feed = "enriched.url.feeds.feed.feed"
    case Url = "enriched.url.url"
    case Title = "enriched.url.title"
    case CleanedTitle = "enriched.url.cleanedTitle"
    case Language = "enriched.url.language"
    case PublicationDate = "enriched.url.publicationDate.date"
    case PublicationDateConfidence = "enriched.url.publicationDate.confident"
    case Text = "enriched.url.text"
    case Author = "enriched.url.author"
    case Keywords = "enriched.url.keywords"
    case KeywordText = "enriched.url.keywords.keyword.text"
    case KeywordRelevance = "enriched.url.keywords.keyword.relevance"
    case KeywordSentimentType = "enriched.url.keywords.keyword.sentiment.type"
    case KeywordSentimentScore = "enriched.url.keywords.keyword.sentiment.score"
    case KeywordSentimentMixed = "enriched.url.keywords.keyword.sentiment.mixed"
    case KeywordKnowledgeGraph = "enriched.url.keywords.keyword.knowledgeGraph.typeHierarchy"
    case Entities = "enriched.url.entities"
    case EntityText = "enriched.url.entities.entity.text"
    case EntityType = "enriched.url.entities.entity.type"
    case EntityKnowledgeGraph = "enriched.url.entities.entity.knowledgeGraph.typeHierarchy"
    case EntityCount = "enriched.url.entities.entity.count"
    case EntityRelevance = "enriched.url.entities.entity.relevance"
    case EntitySentimentType = "enriched.url.entities.entity.sentiment.type"
    case EntitySentimentScore = "enriched.url.entities.entity.sentiment.score"
    case EntitySentimentMixed = "enriched.url.entities.entity.sentiment.mixed"
    case EntityDisambiguatedName = "enriched.url.entities.entity.disambiguated.name"
    case EntityDisambiguatedGeo = "enriched.url.entities.entity.disambiguated.geo"
    case EntityDisambiguatedDbpedia = "enriched.url.entities.entity.disambiguated.dbpedia"
    case EntityDisambiguatedWebsite = "enriched.url.entities.entity.disambiguated.website"
    case EntityDisambiguatedSubType = "enriched.url.entities.entity.disambiguated.subType"
    case EntityDisambiguatedSubType_ = "enriched.url.entities.entity.disambiguated.subType.subType_"
    case EntityQuotations = "enriched.url.entities.entity.quotations"
    case EntityQuotation = "enriched.url.entities.entity.quotations.quotation_.quotation"
    case EntityQuotationSentimentType = "enriched.url.entities.entity.quotations.quotation_.sentiment.type"
    case EntityQuotationSentimentScore = "enriched.url.entities.entity.quotations.quotation_.sentiment.score"
    case EntityQuotationSentimentMixed = "enriched.url.entities.entity.quotations.quotation_.sentiment.mixed"
}