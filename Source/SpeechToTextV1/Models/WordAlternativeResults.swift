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

/** WordAlternativeResults. */
public struct WordAlternativeResults: Codable, Equatable {

    /**
     The start time in seconds of the word from the input audio that corresponds to the word alternatives.
     */
    public var startTime: Double

    /**
     The end time in seconds of the word from the input audio that corresponds to the word alternatives.
     */
    public var endTime: Double

    /**
     An array of alternative hypotheses for a word from the input audio.
     */
    public var alternatives: [WordAlternativeResult]

    // Map each property name to the key that shall be used for encoding/decoding.
    private enum CodingKeys: String, CodingKey {
        case startTime = "start_time"
        case endTime = "end_time"
        case alternatives = "alternatives"
    }

}
