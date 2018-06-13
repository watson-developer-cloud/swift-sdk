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

/** SpeakerLabelsResult. */
public struct SpeakerLabelsResult: Decodable {

    /**
     The start time of a word from the transcript. The value matches the start time of a word from the `timestamps`
     array.
     */
    public var from: Double

    /**
     The end time of a word from the transcript. The value matches the end time of a word from the `timestamps` array.
     */
    public var to: Double

    /**
     The numeric identifier that the service assigns to a speaker from the audio. Speaker IDs begin at `0` initially but
     can evolve and change across interim results (if supported by the method) and between interim and final results as
     the service processes the audio. They are not guaranteed to be sequential, contiguous, or ordered.
     */
    public var speaker: Int

    /**
     A score that indicates the service's confidence in its identification of the speaker in the range of 0 to 1.
     */
    public var confidence: Double

    /**
     An indication of whether the service might further change word and speaker-label results. A value of `true` means
     that the service guarantees not to send any further updates for the current or any preceding results; `false` means
     that the service might send further updates to the results.
     */
    public var finalResults: Bool

    // Map each property name to the key that shall be used for encoding/decoding.
    private enum CodingKeys: String, CodingKey {
        case from = "from"
        case to = "to"
        case speaker = "speaker"
        case confidence = "confidence"
        case finalResults = "final"
    }

}
