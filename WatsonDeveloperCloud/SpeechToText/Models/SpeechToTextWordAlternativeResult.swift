/**
 * Copyright IBM Corporation 2015
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
import ObjectMapper

/** Alternative word hypotheses from Speech to Text for a word in the audio input. */
public struct SpeechToTextWordAlternativeResult: Mappable {

    /// The confidence score of the alternative word hypothesis, between 0 and 1.
    public var confidence: Double!

    /// The alternative word hypothesis for a word in the audio input.
    public var word: String!

    /// Used internally to initialize a `SpeechToTextWordAlternativeResult` from JSON.
    public init?(_ map: Map) { }

    /// Used internally to serialize and deserialize JSON.
    public mutating func mapping(map: Map) {
        confidence <- map["confidence"]
        word       <- map["word"]
    }
}
