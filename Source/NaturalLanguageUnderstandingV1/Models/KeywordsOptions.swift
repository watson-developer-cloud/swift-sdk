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
 Returns important keywords in the content.
 Supported languages: English, French, German, Italian, Japanese, Korean, Portuguese, Russian, Spanish, Swedish.
 */
public struct KeywordsOptions: Codable, Equatable {

    /**
     Maximum number of keywords to return.
     */
    public var limit: Int?

    /**
     Set this to `true` to return sentiment information for detected keywords.
     */
    public var sentiment: Bool?

    /**
     Set this to `true` to analyze emotion for detected keywords.
     */
    public var emotion: Bool?

    // Map each property name to the key that shall be used for encoding/decoding.
    private enum CodingKeys: String, CodingKey {
        case limit = "limit"
        case sentiment = "sentiment"
        case emotion = "emotion"
    }

    /**
     Initialize a `KeywordsOptions` with member variables.

     - parameter limit: Maximum number of keywords to return.
     - parameter sentiment: Set this to `true` to return sentiment information for detected keywords.
     - parameter emotion: Set this to `true` to analyze emotion for detected keywords.

     - returns: An initialized `KeywordsOptions`.
    */
    public init(
        limit: Int? = nil,
        sentiment: Bool? = nil,
        emotion: Bool? = nil
    )
    {
        self.limit = limit
        self.sentiment = sentiment
        self.emotion = emotion
    }

}
