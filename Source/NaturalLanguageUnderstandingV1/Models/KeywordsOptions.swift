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

/** An option indicating whether or not important keywords from the analyzed content should be returned. */
public struct KeywordsOptions {

    /// Maximum number of keywords to return.
    public var limit: Int?

    /// Set this to true to return sentiment information for detected keywords.
    public var sentiment: Bool?

    /// Set this to true to analyze emotion for detected keywords.
    public var emotion: Bool?

    /**
     Initialize a `KeywordsOptions` with member variables.

     - parameter limit: Maximum number of keywords to return.
     - parameter sentiment: Set this to true to return sentiment information for detected keywords.
     - parameter emotion: Set this to true to analyze emotion for detected keywords.

     - returns: An initialized `KeywordsOptions`.
    */
    public init(limit: Int? = nil, sentiment: Bool? = nil, emotion: Bool? = nil) {
        self.limit = limit
        self.sentiment = sentiment
        self.emotion = emotion
    }
}

extension KeywordsOptions: Codable {

    private enum CodingKeys: String, CodingKey {
        case limit = "limit"
        case sentiment = "sentiment"
        case emotion = "emotion"
        static let allValues = [limit, sentiment, emotion]
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        limit = try container.decodeIfPresent(Int.self, forKey: .limit)
        sentiment = try container.decodeIfPresent(Bool.self, forKey: .sentiment)
        emotion = try container.decodeIfPresent(Bool.self, forKey: .emotion)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(limit, forKey: .limit)
        try container.encodeIfPresent(sentiment, forKey: .sentiment)
        try container.encodeIfPresent(emotion, forKey: .emotion)
    }

}
