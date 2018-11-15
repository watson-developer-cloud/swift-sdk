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

/** ToneScore. */
public struct ToneScore: Codable, Equatable {

    /**
     The score for the tone.
     * **`2017-09-21`:** The score that is returned lies in the range of 0.5 to 1. A score greater than 0.75 indicates a
     high likelihood that the tone is perceived in the content.
     * **`2016-05-19`:** The score that is returned lies in the range of 0 to 1. A score less than 0.5 indicates that
     the tone is unlikely to be perceived in the content; a score greater than 0.75 indicates a high likelihood that the
     tone is perceived.
     */
    public var score: Double

    /**
     The unique, non-localized identifier of the tone.
     * **`2017-09-21`:** The service can return results for the following tone IDs: `anger`, `fear`, `joy`, and
     `sadness` (emotional tones); `analytical`, `confident`, and `tentative` (language tones). The service returns
     results only for tones whose scores meet a minimum threshold of 0.5.
     * **`2016-05-19`:** The service can return results for the following tone IDs of the different categories: for the
     `emotion` category: `anger`, `disgust`, `fear`, `joy`, and `sadness`; for the `language` category: `analytical`,
     `confident`, and `tentative`; for the `social` category: `openness_big5`, `conscientiousness_big5`,
     `extraversion_big5`, `agreeableness_big5`, and `emotional_range_big5`. The service returns scores for all tones of
     a category, regardless of their values.
     */
    public var toneID: String

    /**
     The user-visible, localized name of the tone.
     */
    public var toneName: String

    // Map each property name to the key that shall be used for encoding/decoding.
    private enum CodingKeys: String, CodingKey {
        case score = "score"
        case toneID = "tone_id"
        case toneName = "tone_name"
    }

}
