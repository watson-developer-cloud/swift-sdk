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
 The important keywords in the content, organized by relevance.
 */
public struct KeywordsResult: Codable, Equatable {

    /**
     Number of times the keyword appears in the analyzed text.
     */
    public var count: Int?

    /**
     Relevance score from 0 to 1. Higher values indicate greater relevance.
     */
    public var relevance: Double?

    /**
     The keyword text.
     */
    public var text: String?

    /**
     Emotion analysis results for the keyword, enabled with the `emotion` option.
     */
    public var emotion: EmotionScores?

    /**
     Sentiment analysis results for the keyword, enabled with the `sentiment` option.
     */
    public var sentiment: FeatureSentimentResults?

    // Map each property name to the key that shall be used for encoding/decoding.
    private enum CodingKeys: String, CodingKey {
        case count = "count"
        case relevance = "relevance"
        case text = "text"
        case emotion = "emotion"
        case sentiment = "sentiment"
    }

}
