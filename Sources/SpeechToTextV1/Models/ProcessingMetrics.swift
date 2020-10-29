/**
 * (C) Copyright IBM Corp. 2019.
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

/**
 If processing metrics are requested, information about the service's processing of the input audio. Processing metrics
 are not available with the synchronous **Recognize audio** method.
 */
public struct ProcessingMetrics: Codable, Equatable {

    /**
     Detailed timing information about the service's processing of the input audio.
     */
    public var processedAudio: ProcessedAudio

    /**
     The amount of real time in seconds that has passed since the service received the first byte of input audio. Values
     in this field are generally multiples of the specified metrics interval, with two differences:
     * Values might not reflect exact intervals (for instance, 0.25, 0.5, and so on). Actual values might be 0.27, 0.52,
     and so on, depending on when the service receives and processes audio.
     * The service also returns values for transcription events if you set the `interim_results` parameter to `true`.
     The service returns both processing metrics and transcription results when such events occur.
     */
    public var wallClockSinceFirstByteReceived: Double

    /**
     An indication of whether the metrics apply to a periodic interval or a transcription event:
     * `true` means that the response was triggered by a specified processing interval. The information contains
     processing metrics only.
     * `false` means that the response was triggered by a transcription event. The information contains processing
     metrics plus transcription results.
     Use the field to identify why the service generated the response and to filter different results if necessary.
     */
    public var periodic: Bool

    // Map each property name to the key that shall be used for encoding/decoding.
    private enum CodingKeys: String, CodingKey {
        case processedAudio = "processed_audio"
        case wallClockSinceFirstByteReceived = "wall_clock_since_first_byte_received"
        case periodic = "periodic"
    }

}
