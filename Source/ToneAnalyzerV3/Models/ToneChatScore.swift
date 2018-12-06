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

/** ToneChatScore. */
public struct ToneChatScore: Codable, Equatable {

    /**
     The unique, non-localized identifier of the tone for the results. The service returns results only for tones whose
     scores meet a minimum threshold of 0.5.
     */
    public enum ToneID: String {
        case excited = "excited"
        case frustrated = "frustrated"
        case impolite = "impolite"
        case polite = "polite"
        case sad = "sad"
        case satisfied = "satisfied"
        case sympathetic = "sympathetic"
    }

    /**
     The score for the tone in the range of 0.5 to 1. A score greater than 0.75 indicates a high likelihood that the
     tone is perceived in the utterance.
     */
    public var score: Double

    /**
     The unique, non-localized identifier of the tone for the results. The service returns results only for tones whose
     scores meet a minimum threshold of 0.5.
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
