/**
 * (C) Copyright IBM Corp. 2016, 2020.
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
 The settings associated with a Speech to Text recognition request. Any `nil` parameters will
 use a default value provided by the Watson Speech to Text service.

 For more information about the Speech to Text service parameters, visit:
 https://cloud.ibm.com/docs/services/speech-to-text/input.html
 */
public struct RecognitionSettings: Codable, Equatable {

    /// The action to perform. Must be `start` to begin the request.
    private let action = "start"

    /// The format of the audio data. Endianness is automatically detected by the Speech to Text
    /// service. For more information about the supported formats, visit:
    /// https://cloud.ibm.com/docs/services/speech-to-text/audio-formats.html
    public var contentType: String?

    /// If you specify a customization ID when you open the connection, you can use the customization
    /// weight to tell the service how much weight to give to words from the custom language model
    /// compared to those from the base model for the current request.
    public var customizationWeight: Double?

    /// The number of seconds after which the connection is to time out due to inactivity.
    /// Use `-1` to set the timeout to infinity. The default is `30` seconds.
    public var inactivityTimeout: Int?

    /// An array of keyword strings to be matched in the input audio. By default, the service
    /// does not perform any keyword spotting.
    public var keywords: [String]?

    /// A minimum level of confidence that the service must have to report a matching keyword
    /// in the input audio. The threshold must be a probability value between `0` and `1`
    /// inclusive. A match must have at least the specified confidence to be returned. If you
    /// specify a valid threshold, you must also specify at least one keyword. By default, the
    /// service does not perform any keyword spotting.
    public var keywordsThreshold: Double?

    /// The maximum number of alternative transcriptions to receive. The default is 1.
    public var maxAlternatives: Int?

    /// If `true`, then interim results (i.e. results that are not final) will be received
    /// for the transcription. The default is `false`.
    public var interimResults: Bool?

    /// A minimum level of confidence that the service must have to report a hypothesis for a
    /// word from the input audio. The threshold must be a probability value between `0` and `1`
    /// inclusive. A hypothesis must have at least the specified confidence to be returned as a
    /// word alternative. By default, the service does not return any word alternatives.
    public var wordAlternativesThreshold: Double?

    /// If `true`, then a confidence score will be received for each word of the transcription.
    /// The default is `false`.
    public var wordConfidence: Bool?

    /// If `true`, then per-word start and end times relative to the beginning of the audio will
    /// be received. The default is `false`.
    public var timestamps: Bool?

    /// If `true`, then profanity will be censored from the service's output, obscuring each
    /// occurrence with a set of asterisks. The default is `true`.
    public var filterProfanity: Bool?

    /// Indicates whether dates, times, series of digits and numbers, phone numbers, currency values,
    /// and Internet addresses are to be converted into more readable, conventional representations
    /// in the final transcript of a recognition request. If true, smart formatting is performed;
    /// if false (the default), no formatting is performed. Applies to US English transcription only.
    public var smartFormatting: Bool?

    /// If `true`, then speaker labels will be returned for each timestamp.  The default is `false`.
    public var speakerLabels: Bool?

    /// The name of a grammar that is to be used with the recognition request. If you specify a
    /// grammar, you must also use the `language_customization_id` parameter to specify the name of the custom language
    /// model for which the grammar is defined. The service recognizes only strings that are recognized by the specified
    /// grammar; it does not recognize other custom words from the model's words resource. See
    /// [Grammars](https://cloud.ibm.com/docs/services/speech-to-text/output.html).
    public var grammarName: String?

    /// If `true`, the service redacts, or masks, numeric data from final transcripts. The feature
    /// redacts any number that has three or more consecutive digits by replacing each digit with an `X` character. It is
    /// intended to redact sensitive numeric data, such as credit card numbers. By default, the service performs no
    /// redaction.
    /// When you enable redaction, the service automatically enables smart formatting, regardless of whether you
    /// explicitly disable that feature. To ensure maximum security, the service also disables keyword spotting (ignores
    /// the `keywords` and `keywords_threshold` parameters) and returns only a single final transcript (forces the
    /// `max_alternatives` parameter to be `1`).
    /// **Note:** Applies to US English, Japanese, and Korean transcription only.
    /// See [Numeric redaction](https://cloud.ibm.com/docs/services/speech-to-text/output.html#redaction).
    public var redaction: Bool?

    // If `true`, requests processing metrics about the service's transcription of the input audio. The service returns
    // processing metrics at the interval specified by the `processing_metrics_interval` property. It also returns
    // processing metrics for transcription events, for example, for final and interim results. By default, the service
    // returns no processing metrics.
    public var processingMetrics: Bool?

    // Specifies the interval in real wall-clock seconds at which the service is to return processing metrics. The
    // parameter is ignored unless the `processing_metrics` property is set to `true`. The property accepts a minimum
    // value of 0.1 seconds. The level of precision is not restricted, so you can specify values such as 0.25 and 0.125.
    // The service does not impose a maximum value. If you want to receive processing metrics only for transcription
    // events instead of at periodic intervals, set the value to a large number. If the value is larger than the
    // duration of the audio, the service returns processing metrics only for transcription events.
    public var processingMetricsInterval: Double?

    // If `true`, requests detailed information about the signal characteristics of the input audio. The service returns
    // audio metrics with the final transcription results. By default, the service returns no audio metrics.
    public var audioMetrics: Bool?

    /// If `true`, specifies the duration of the pause interval at which the service
    /// splits a transcript into multiple final results. If the service detects pauses or extended silence before it
    /// reaches the end of the audio stream, its response can include multiple final results. Silence indicates a point
    /// at which the speaker pauses between spoken words or phrases.
    /// Specify a value for the pause interval in the range of 0.0 to 120.0.
    /// * A value greater than 0 specifies the interval that the service is to use for speech recognition.
    /// * A value of 0 indicates that the service is to use the default interval. It is equivalent to omitting the
    /// parameter.
    /// The default pause interval for most languages is 0.8 seconds; the default for Chinese is 0.6 seconds.
    /// See [End of phrase silence time](https://cloud.ibm.com/docs/speech-to-text?topic=speech-to-text-output#silence_time).
    public var endOfPhraseSilenceTime: Double?

    /// If `true`, directs the service to split the transcript into multiple
    /// final results based on semantic features of the input, for example, at the conclusion of meaningful phrases such
    /// as sentences. The service bases its understanding of semantic features on the base language model that you use
    /// with a request. Custom language models and grammars can also influence how and where the service splits a
    /// transcript. By default, the service splits transcripts based solely on the pause interval.
    /// See [Split transcript at phrase](https://cloud.ibm.com/docs/speech-to-text?topic=speech-to-text-output#split_transcript).
    public var splitTranscriptAtPhraseEnd: Bool?

    /// The sensitivity of speech activity detection that the service is to
    /// perform. Use the parameter to suppress word insertions from music, coughing, and other non-speech events. The
    /// service biases the audio it passes for speech recognition by evaluating the input audio against prior models of
    /// speech and non-speech activity.
    /// Specify a value between 0.0 and 1.0:
    /// * 0.0 suppresses all audio (no speech is transcribed).
    /// * 0.5 (the default) provides a reasonable compromise for the level of sensitivity.
    /// * 1.0 suppresses no audio (speech detection sensitivity is disabled).
    /// The values increase on a monotonic curve. See [Speech Activity
    /// Detection](https://cloud.ibm.com/docs/speech-to-text?topic=speech-to-text-input#detection).
    public var speechDetectorSensitivity: Double?

    /// The level to which the service is to suppress background audio based on
    /// its volume to prevent it from being transcribed as speech. Use the parameter to suppress side conversations or
    /// background noise.
    /// Specify a value in the range of 0.0 to 1.0:
    /// * 0.0 (the default) provides no suppression (background audio suppression is disabled).
    /// * 0.5 provides a reasonable level of audio suppression for general usage.
    /// * 1.0 suppresses all audio (no audio is transcribed).
    /// The values increase on a monotonic curve. See [Speech Activity
    /// Detection](https://cloud.ibm.com/docs/speech-to-text?topic=speech-to-text-input#detection).
    public var backgroundAudioSuppression: Double?

    /**
     Initialize a `RecognitionSettings` object to set the parameters of a Watson Speech to
     Text recognition request.
     - parameter contentType: The format of the audio data. Endianness is automatically detected
        by the Speech to Text service. For more information about the supported formats, visit:
        https://cloud.ibm.com/docs/services/speech-to-text/audio-formats.html
     - returns: An initialized `RecognitionSettings` object with the given `contentType`.
        Configure additional parameters for the recognition request by directly modifying
        the returned object's properties.
     */
    public init(contentType: String? = nil) {
        self.contentType = contentType
    }

    private enum CodingKeys: String, CodingKey {
        case action = "action"
        case contentType = "content-type"
        case customizationWeight = "customization_weight"
        case inactivityTimeout = "inactivity_timeout"
        case keywords = "keywords"
        case keywordsThreshold = "keywords_threshold"
        case maxAlternatives = "max_alternatives"
        case interimResults = "interim_results"
        case wordAlternativesThreshold = "word_alternatives_threshold"
        case wordConfidence = "word_confidence"
        case timestamps = "timestamps"
        case filterProfanity = "profanity_filter"
        case smartFormatting = "smart_formatting"
        case speakerLabels = "speaker_labels"
        case grammarName = "grammar_name"
        case redaction = "redaction"
        case processingMetrics = "processing_metrics"
        case processingMetricsInterval = "processing_metrics_interval"
        case audioMetrics = "audio_metrics"
    }
}
