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

    /// A particular word from the transcript of the utterance.
    public var word: String!

    /// The start time, in seconds, of the given word in the audio input.
    public var startTime: Double!

    /// The end time, in seconds, of the given word in the audio input.
    public var endTime: Double!
    
}
