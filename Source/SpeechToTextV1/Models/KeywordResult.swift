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

/** A keyword identified by Speech to Text. */
public struct KeywordResult: JSONDecodable {

    /// The specified keyword normalized to the spoken phrase that matched in the audio input.
    public let normalizedText: String

    /// The start time, in seconds, of the keyword match.
    public let startTime: Double

    /// The end time, in seconds, of the keyword match.
    public let endTime: Double

    /// The confidence score of the keyword match, between 0 and 1. The confidence must be at
    /// least as great as the specified threshold to be included in the results.
    public let confidence: Double

    /// Used internally to initialize a `KeywordResult` model from JSON.
    public init(json: JSONWrapper) throws {
        normalizedText = try json.getString(at: "normalized_text")
        startTime = try json.getDouble(at: "start_time")
        endTime = try json.getDouble(at: "end_time")
        confidence = try json.getDouble(at: "confidence")
    }
}
