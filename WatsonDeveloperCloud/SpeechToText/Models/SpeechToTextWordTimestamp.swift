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

/** The timestamp of a word in a Speech to Text transcription. */
public struct SpeechToTextWordTimestamp {

    /// A particular word from the transcription.
    public var word: String!

    /// The start time, in seconds, of the given word in the audio input.
    public var startTime: Double!

    /// The end time, in seconds, of the given word in the audio input.
    public var endTime: Double!

}

/** An ObjectMapper transformation for `SpeechToTextWordTimestamp`. */
struct SpeechToTextWordTimestampTransform: TransformType {
    typealias Object = SpeechToTextWordTimestamp
    typealias JSON = [AnyObject]

    /**
     Transform JSON to a `SpeechToTextWordTimestamp`.

     - parameter value: The JSON object to transform.

     - returns: A `SpeechToTextWordTimestamp` object.
     */
    func transformFromJSON(value: AnyObject?) -> Object? {
        guard let array = value as? [AnyObject],
              let word = array[0] as? String,
              let startTime = array[1] as? Double,
              let endTime = array[2] as? Double else
        {
            return nil
        }

        return SpeechToTextWordTimestamp(word: word, startTime: startTime, endTime: endTime)
    }

    /**
     Transform a `SpeechToTextWordTimestamp` to JSON.

     - parameter value: The `SpeechToTextWordTimestamp` object to transform.

     - returns: A JSON object.
     */
    func transformToJSON(value: Object?) -> JSON? {
        guard let wordTimestamp = value else {
            return nil
        }

        return [wordTimestamp.word, wordTimestamp.startTime, wordTimestamp.endTime]
    }
}
