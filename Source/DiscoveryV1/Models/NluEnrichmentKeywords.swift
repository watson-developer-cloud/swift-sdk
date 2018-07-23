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
 An object specifying the Keyword enrichment and related parameters.
 */
public struct NluEnrichmentKeywords: Codable {

    /**
     When `true`, sentiment analysis of keywords will be performed on the specified field.
     */
    public var sentiment: Bool?

    /**
     When `true`, emotion detection of keywords will be performed on the specified field.
     */
    public var emotion: Bool?

    /**
     The maximum number of keywords to extract for each instance of the specified field.
     */
    public var limit: Int?

    // Map each property name to the key that shall be used for encoding/decoding.
    private enum CodingKeys: String, CodingKey {
        case sentiment = "sentiment"
        case emotion = "emotion"
        case limit = "limit"
    }

    /**
     Initialize a `NluEnrichmentKeywords` with member variables.

     - parameter sentiment: When `true`, sentiment analysis of keywords will be performed on the specified field.
     - parameter emotion: When `true`, emotion detection of keywords will be performed on the specified field.
     - parameter limit: The maximum number of keywords to extract for each instance of the specified field.

     - returns: An initialized `NluEnrichmentKeywords`.
    */
    public init(
        sentiment: Bool? = nil,
        emotion: Bool? = nil,
        limit: Int? = nil
    )
    {
        self.sentiment = sentiment
        self.emotion = emotion
        self.limit = limit
    }

}
