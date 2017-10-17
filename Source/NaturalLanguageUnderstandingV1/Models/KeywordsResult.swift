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

/** The most important keywords in the content, organized by relevance. */
public struct KeywordsResult {

    /// Relevance score from 0 to 1. Higher values indicate greater relevance.
    public var relevance: Double?

    /// The keyword text.
    public var text: String?

    /// Emotion analysis results for the keyword, enabled with the "emotion" option.
    public var emotion: EmotionScores?

    /// Sentiment analysis results for the keyword, enabled with the "sentiment" option.
    public var sentiment: FeatureSentimentResults?

    /**
     Initialize a `KeywordsResult` with member variables.

     - parameter relevance: Relevance score from 0 to 1. Higher values indicate greater relevance.
     - parameter text: The keyword text.
     - parameter emotion: Emotion analysis results for the keyword, enabled with the "emotion" option.
     - parameter sentiment: Sentiment analysis results for the keyword, enabled with the "sentiment" option.

     - returns: An initialized `KeywordsResult`.
    */
    public init(relevance: Double? = nil, text: String? = nil, emotion: EmotionScores? = nil, sentiment: FeatureSentimentResults? = nil) {
        self.relevance = relevance
        self.text = text
        self.emotion = emotion
        self.sentiment = sentiment
    }
}

extension KeywordsResult: Codable {

    private enum CodingKeys: String, CodingKey {
        case relevance = "relevance"
        case text = "text"
        case emotion = "emotion"
        case sentiment = "sentiment"
        static let allValues = [relevance, text, emotion, sentiment]
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        relevance = try container.decodeIfPresent(Double.self, forKey: .relevance)
        text = try container.decodeIfPresent(String.self, forKey: .text)
        emotion = try container.decodeIfPresent(EmotionScores.self, forKey: .emotion)
        sentiment = try container.decodeIfPresent(FeatureSentimentResults.self, forKey: .sentiment)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(relevance, forKey: .relevance)
        try container.encodeIfPresent(text, forKey: .text)
        try container.encodeIfPresent(emotion, forKey: .emotion)
        try container.encodeIfPresent(sentiment, forKey: .sentiment)
    }

}
