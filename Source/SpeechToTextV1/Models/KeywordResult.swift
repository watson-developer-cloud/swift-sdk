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

/** KeywordResult. */
public struct KeywordResult: Decodable {

    /**
     A specified keyword normalized to the spoken phrase that matched in the audio input.
     */
    public var normalizedText: String

    /**
     The start time in seconds of the keyword match.
     */
    public var startTime: Double

    /**
     The end time in seconds of the keyword match.
     */
    public var endTime: Double

    /**
     A confidence score for the keyword match in the range of 0.0 to 1.0.
     */
    public var confidence: Double

    // Map each property name to the key that shall be used for encoding/decoding.
    private enum CodingKeys: String, CodingKey {
        case normalizedText = "normalized_text"
        case startTime = "start_time"
        case endTime = "end_time"
        case confidence = "confidence"
    }

}
