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
 Detailed information about the signal characteristics of the input audio.
 */
public struct AudioMetricsDetails: Codable, Equatable {

    /**
     If `true`, indicates the end of the audio stream, meaning that transcription is complete. Currently, the field is
     always `true`. The service returns metrics just once per audio stream. The results provide aggregated audio metrics
     that pertain to the complete audio stream.
     */
    public var `final`: Bool

    /**
     The end time in seconds of the block of audio to which the metrics apply.
     */
    public var endTime: Double

    /**
     The signal-to-noise ratio (SNR) for the audio signal. The value indicates the ratio of speech to noise in the
     audio. A valid value lies in the range of 0 to 100 decibels (dB). The service omits the field if it cannot compute
     the SNR for the audio.
     */
    public var signalToNoiseRatio: Double?

    /**
     The ratio of speech to non-speech segments in the audio signal. The value lies in the range of 0.0 to 1.0.
     */
    public var speechRatio: Double

    /**
     The probability that the audio signal is missing the upper half of its frequency content.
     * A value close to 1.0 typically indicates artificially up-sampled audio, which negatively impacts the accuracy of
     the transcription results.
     * A value at or near 0.0 indicates that the audio signal is good and has a full spectrum.
     * A value around 0.5 means that detection of the frequency content is unreliable or not available.
     */
    public var highFrequencyLoss: Double

    /**
     An array of `AudioMetricsHistogramBin` objects that defines a histogram of the cumulative direct current (DC)
     component of the audio signal.
     */
    public var directCurrentOffset: [AudioMetricsHistogramBin]

    /**
     An array of `AudioMetricsHistogramBin` objects that defines a histogram of the clipping rate for the audio
     segments. The clipping rate is defined as the fraction of samples in the segment that reach the maximum or minimum
     value that is offered by the audio quantization range. The service auto-detects either a 16-bit Pulse-Code
     Modulation(PCM) audio range (-32768 to +32767) or a unit range (-1.0 to +1.0). The clipping rate is between 0.0 and
     1.0, with higher values indicating possible degradation of speech recognition.
     */
    public var clippingRate: [AudioMetricsHistogramBin]

    /**
     An array of `AudioMetricsHistogramBin` objects that defines a histogram of the signal level in segments of the
     audio that contain speech. The signal level is computed as the Root-Mean-Square (RMS) value in a decibel (dB) scale
     normalized to the range 0.0 (minimum level) to 1.0 (maximum level).
     */
    public var speechLevel: [AudioMetricsHistogramBin]

    /**
     An array of `AudioMetricsHistogramBin` objects that defines a histogram of the signal level in segments of the
     audio that do not contain speech. The signal level is computed as the Root-Mean-Square (RMS) value in a decibel
     (dB) scale normalized to the range 0.0 (minimum level) to 1.0 (maximum level).
     */
    public var nonSpeechLevel: [AudioMetricsHistogramBin]

    // Map each property name to the key that shall be used for encoding/decoding.
    private enum CodingKeys: String, CodingKey {
        case `final` = "final"
        case endTime = "end_time"
        case signalToNoiseRatio = "signal_to_noise_ratio"
        case speechRatio = "speech_ratio"
        case highFrequencyLoss = "high_frequency_loss"
        case directCurrentOffset = "direct_current_offset"
        case clippingRate = "clipping_rate"
        case speechLevel = "speech_level"
        case nonSpeechLevel = "non_speech_level"
    }

}
