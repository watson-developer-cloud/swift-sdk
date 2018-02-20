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

/** An object specifying the Keyword enrichment and related parameters. */
public struct NluEnrichmentKeywords {

    /// When `true`, sentiment analysis of keywords will be performed on the specified field.
    public var sentiment: Bool?

    /// When `true`, emotion detection of keywords will be performed on the specified field.
    public var emotion: Bool?

    /// The maximum number of keywords to extract for each instance of the specified field.
    public var limit: Int?

    /**
     Initialize a `NluEnrichmentKeywords` with member variables.

     - parameter sentiment: When `true`, sentiment analysis of keywords will be performed on the specified field.
     - parameter emotion: When `true`, emotion detection of keywords will be performed on the specified field.
     - parameter limit: The maximum number of keywords to extract for each instance of the specified field.

     - returns: An initialized `NluEnrichmentKeywords`.
    */
    public init(sentiment: Bool? = nil, emotion: Bool? = nil, limit: Int? = nil) {
        self.sentiment = sentiment
        self.emotion = emotion
        self.limit = limit
    }
}

extension NluEnrichmentKeywords: Codable {

    private enum CodingKeys: String, CodingKey {
        case sentiment = "sentiment"
        case emotion = "emotion"
        case limit = "limit"
        static let allValues = [sentiment, emotion, limit]
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        sentiment = try container.decodeIfPresent(Bool.self, forKey: .sentiment)
        emotion = try container.decodeIfPresent(Bool.self, forKey: .emotion)
        limit = try container.decodeIfPresent(Int.self, forKey: .limit)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(sentiment, forKey: .sentiment)
        try container.encodeIfPresent(emotion, forKey: .emotion)
        try container.encodeIfPresent(limit, forKey: .limit)
    }

}
