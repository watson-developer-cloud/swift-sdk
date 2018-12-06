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

/** WordAlternativeResult. */
public struct WordAlternativeResult: Codable, Equatable {

    /**
     A confidence score for the word alternative hypothesis in the range of 0.0 to 1.0.
     */
    public var confidence: Double

    /**
     An alternative hypothesis for a word from the input audio.
     */
    public var word: String

    // Map each property name to the key that shall be used for encoding/decoding.
    private enum CodingKeys: String, CodingKey {
        case confidence = "confidence"
        case word = "word"
    }

}
