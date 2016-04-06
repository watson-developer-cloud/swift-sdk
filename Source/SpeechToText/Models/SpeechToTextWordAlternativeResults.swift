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

/** Word alternatives produced by Speech to Text. */
public struct SpeechToTextWordAlternativeResults: Mappable {

    /// The time, in seconds, at which the word with alternative
    /// word hypotheses starts in the audio input.
    public var startTime: Double!

    /// The time, in seconds, at which the word with alternative
    /// word hypotheses ends in the audio input.
    public var endTime: Double!

    /// A list of alternative word hypotheses for a word in the audio input.
    public var alternatives: [SpeechToTextWordAlternativeResult]!

    /// Used internally to initialize a `SpeechToTextWordAlternativeResults` from JSON.
    public init?(_ map: Map) { }

    /// Used internally to serialize and deserialize JSON.
    public mutating func mapping(map: Map) {
        startTime    <- map["start_time"]
        endTime      <- map["end_time"]
        alternatives <- map["alternatives"]
    }
}
