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
 The important people, places, geopolitical entities and other types of entities in your content.
 */
public struct EntitiesResult: Codable, Equatable {

    /**
     Entity type.
     */
    public var type: String?

    /**
     The name of the entity.
     */
    public var text: String?

    /**
     Relevance score from 0 to 1. Higher values indicate greater relevance.
     */
    public var relevance: Double?

    /**
     Entity mentions and locations.
     */
    public var mentions: [EntityMention]?

    /**
     How many times the entity was mentioned in the text.
     */
    public var count: Int?

    /**
     Emotion analysis results for the entity, enabled with the `emotion` option.
     */
    public var emotion: EmotionScores?

    /**
     Sentiment analysis results for the entity, enabled with the `sentiment` option.
     */
    public var sentiment: FeatureSentimentResults?

    /**
     Disambiguation information for the entity.
     */
    public var disambiguation: DisambiguationResult?

    // Map each property name to the key that shall be used for encoding/decoding.
    private enum CodingKeys: String, CodingKey {
        case type = "type"
        case text = "text"
        case relevance = "relevance"
        case mentions = "mentions"
        case count = "count"
        case emotion = "emotion"
        case sentiment = "sentiment"
        case disambiguation = "disambiguation"
    }

}
