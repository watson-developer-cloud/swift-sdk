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

/** WordAlternativeResults. */
public struct WordAlternativeResults {

    /// The start time in seconds of the word from the input audio that corresponds to the word alternatives.
    public var startTime: Double

    /// The end time in seconds of the word from the input audio that corresponds to the word alternatives.
    public var endTime: Double

    /// An array of alternative hypotheses for a word from the input audio.
    public var alternatives: [WordAlternativeResult]

    /**
     Initialize a `WordAlternativeResults` with member variables.

     - parameter startTime: The start time in seconds of the word from the input audio that corresponds to the word alternatives.
     - parameter endTime: The end time in seconds of the word from the input audio that corresponds to the word alternatives.
     - parameter alternatives: An array of alternative hypotheses for a word from the input audio.

     - returns: An initialized `WordAlternativeResults`.
    */
    public init(startTime: Double, endTime: Double, alternatives: [WordAlternativeResult]) {
        self.startTime = startTime
        self.endTime = endTime
        self.alternatives = alternatives
    }
}

extension WordAlternativeResults: Codable {

    private enum CodingKeys: String, CodingKey {
        case startTime = "start_time"
        case endTime = "end_time"
        case alternatives = "alternatives"
        static let allValues = [startTime, endTime, alternatives]
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        startTime = try container.decode(Double.self, forKey: .startTime)
        endTime = try container.decode(Double.self, forKey: .endTime)
        alternatives = try container.decode([WordAlternativeResult].self, forKey: .alternatives)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(startTime, forKey: .startTime)
        try container.encode(endTime, forKey: .endTime)
        try container.encode(alternatives, forKey: .alternatives)
    }

}
