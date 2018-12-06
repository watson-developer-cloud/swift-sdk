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

/** The confidence of a word in a Speech to Text transcription. */
public struct WordConfidence: Codable, Equatable {

    /// A particular word from the transcription.
    public let word: String

    /// The confidence of the given word, between 0 and 1.
    public let confidence: Double

    /// Used internally to initialize a `WordConfidence` model from JSON.
    public init(from decoder: Decoder) throws {
        var container = try decoder.unkeyedContainer()
        word = try container.decode(String.self)
        confidence = try container.decode(Double.self)
    }
}
