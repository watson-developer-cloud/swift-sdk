/**
 * Copyright IBM Corporation 2016
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
import RestKit

/** Alternative word hypotheses from Speech to Text for a word in the audio input. */
public struct WordAlternativeResult: JSONDecodable {

    /// The confidence score of the alternative word hypothesis, between 0 and 1.
    public let confidence: Double

    /// The alternative word hypothesis for a word in the audio input.
    public let word: String

    /// Used internally to initialize an `WordAlternativeResult` model from JSON.
    public init(json: JSON) throws {
        confidence = try json.getDouble(at: "confidence")
        word = try json.getString(at: "word")
    }
}
