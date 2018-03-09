/**
 * Copyright IBM Corporation 2017
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

/** An object containing information about speaker label object. */
public struct SpeakerLabel: JSONDecodable {

    /// The from/start timestamp, in seconds, of this speaker label
    public let fromTime: Double

    /// The to/end timestamp, in seconds, of this speaker label
    public let toTime: Double

    /// The confidence score of the speaker label between 0 and 1
    public let confidence: Double

    /// The speaker label in the form of an integer (greater than or equal to 0)
    public let speaker: Int

    /// The final field will only be true for the last word of a complete audio stream.  Otherwise, the final field will be false
    public let final: Bool

    /// Used internally to initialize a `SpeakerLabel` model from JSON.
    public init(json: JSONWrapper) throws {
        fromTime = try json.getDouble(at: "from")
        toTime = try json.getDouble(at: "to")
        confidence = try json.getDouble(at: "confidence")
        speaker = try json.getInt(at: "speaker")
        final = try json.getBool(at: "final")
    }
}
