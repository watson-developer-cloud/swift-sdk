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
 If audio metrics are requested, information about the signal characteristics of the input audio.
 */
public struct AudioMetrics: Codable, Equatable {

    /**
     The interval in seconds (typically 0.1 seconds) at which the service calculated the audio metrics. In other words,
     how often the service calculated the metrics. A single unit in each histogram (see the `AudioMetricsHistogramBin`
     object) is calculated based on a `sampling_interval` length of audio.
     */
    public var samplingInterval: Double

    /**
     Detailed information about the signal characteristics of the input audio.
     */
    public var accumulated: AudioMetricsDetails

    // Map each property name to the key that shall be used for encoding/decoding.
    private enum CodingKeys: String, CodingKey {
        case samplingInterval = "sampling_interval"
        case accumulated = "accumulated"
    }

}
