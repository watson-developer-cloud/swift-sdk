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

/** UtteranceAnalysis. */
public struct UtteranceAnalysis: Codable, Equatable {

    /**
     The unique identifier of the utterance. The first utterance has ID 0, and the ID of each subsequent utterance is
     incremented by one.
     */
    public var utteranceID: Int

    /**
     The text of the utterance.
     */
    public var utteranceText: String

    /**
     An array of `ToneChatScore` objects that provides results for the most prevalent tones of the utterance. The array
     includes results for any tone whose score is at least 0.5. The array is empty if no tone has a score that meets
     this threshold.
     */
    public var tones: [ToneChatScore]

    /**
     **`2017-09-21`:** An error message if the utterance contains more than 500 characters. The service does not analyze
     the utterance. **`2016-05-19`:** Not returned.
     */
    public var error: String?

    // Map each property name to the key that shall be used for encoding/decoding.
    private enum CodingKeys: String, CodingKey {
        case utteranceID = "utterance_id"
        case utteranceText = "utterance_text"
        case tones = "tones"
        case error = "error"
    }

}
