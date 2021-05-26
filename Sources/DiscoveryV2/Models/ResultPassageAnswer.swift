/**
 * (C) Copyright IBM Corp. 2021.
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
 Object containing a potential answer to the specified query.
 */
public struct ResultPassageAnswer: Codable, Equatable {

    /**
     Answer text for the specified query as identified by Discovery.
     */
    public var answerText: String?

    /**
     The position of the first character of the extracted answer in the originating field.
     */
    public var startOffset: Int?

    /**
     The position of the last character of the extracted answer in the originating field.
     */
    public var endOffset: Int?

    /**
     An estimate of the probability that the answer is relevant.
     */
    public var confidence: Double?

    // Map each property name to the key that shall be used for encoding/decoding.
    private enum CodingKeys: String, CodingKey {
        case answerText = "answer_text"
        case startOffset = "start_offset"
        case endOffset = "end_offset"
        case confidence = "confidence"
    }

}
