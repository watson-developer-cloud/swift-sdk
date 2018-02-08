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

/** The important people, places, geopolitical entities and other types of entities in your content. */
public struct EntitiesResult {

    /// Entity type.
    public var type: String?

    /// The name of the entity.
    public var text: String?

    /// Relevance score from 0 to 1. Higher values indicate greater relevance.
    public var relevance: Double?

    /// Entity mentions and locations.
    public var mentions: [EntityMention]?

    /// How many times the entity was mentioned in the text.
    public var count: Int?

    /// Emotion analysis results for the entity, enabled with the "emotion" option.
    public var emotion: EmotionScores?

    /// Sentiment analysis results for the entity, enabled with the "sentiment" option.
    public var sentiment: FeatureSentimentResults?

    /// Disambiguation information for the entity.
    public var disambiguation: DisambiguationResult?

    /**
     Initialize a `EntitiesResult` with member variables.

     - parameter type: Entity type.
     - parameter text: The name of the entity.
     - parameter relevance: Relevance score from 0 to 1. Higher values indicate greater relevance.
     - parameter mentions: Entity mentions and locations.
     - parameter count: How many times the entity was mentioned in the text.
     - parameter emotion: Emotion analysis results for the entity, enabled with the "emotion" option.
     - parameter sentiment: Sentiment analysis results for the entity, enabled with the "sentiment" option.
     - parameter disambiguation: Disambiguation information for the entity.

     - returns: An initialized `EntitiesResult`.
    */
    public init(type: String? = nil, text: String? = nil, relevance: Double? = nil, mentions: [EntityMention]? = nil, count: Int? = nil, emotion: EmotionScores? = nil, sentiment: FeatureSentimentResults? = nil, disambiguation: DisambiguationResult? = nil) {
        self.type = type
        self.text = text
        self.relevance = relevance
        self.mentions = mentions
        self.count = count
        self.emotion = emotion
        self.sentiment = sentiment
        self.disambiguation = disambiguation
    }
}

extension EntitiesResult: Codable {

    private enum CodingKeys: String, CodingKey {
        case type = "type"
        case text = "text"
        case relevance = "relevance"
        case mentions = "mentions"
        case count = "count"
        case emotion = "emotion"
        case sentiment = "sentiment"
        case disambiguation = "disambiguation"
        static let allValues = [type, text, relevance, mentions, count, emotion, sentiment, disambiguation]
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        type = try container.decodeIfPresent(String.self, forKey: .type)
        text = try container.decodeIfPresent(String.self, forKey: .text)
        relevance = try container.decodeIfPresent(Double.self, forKey: .relevance)
        mentions = try container.decodeIfPresent([EntityMention].self, forKey: .mentions)
        count = try container.decodeIfPresent(Int.self, forKey: .count)
        emotion = try container.decodeIfPresent(EmotionScores.self, forKey: .emotion)
        sentiment = try container.decodeIfPresent(FeatureSentimentResults.self, forKey: .sentiment)
        disambiguation = try container.decodeIfPresent(DisambiguationResult.self, forKey: .disambiguation)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(type, forKey: .type)
        try container.encodeIfPresent(text, forKey: .text)
        try container.encodeIfPresent(relevance, forKey: .relevance)
        try container.encodeIfPresent(mentions, forKey: .mentions)
        try container.encodeIfPresent(count, forKey: .count)
        try container.encodeIfPresent(emotion, forKey: .emotion)
        try container.encodeIfPresent(sentiment, forKey: .sentiment)
        try container.encodeIfPresent(disambiguation, forKey: .disambiguation)
    }

}
