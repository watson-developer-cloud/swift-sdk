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

/**
 The settings associated with a Speech to Text recognition request. Any `nil` parameters will
 use a default value provided by the Watson Speech to Text service.

 For more information about the Speech to Text service parameters, visit:
 https://console.bluemix.net/docs/services/speech-to-text/input.html
 */
public struct RecognitionSettings: Encodable {

    /// The action to perform. Must be `start` to begin the request.
    private let action = "start"

    /// The format of the audio data. Endianness is automatically detected by the Speech to Text
    /// service. For more information aboutthe supported formats, visit:
    /// https://console.bluemix.net/docs/services/speech-to-text/input.html#formats
    public var contentType: String

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

    /**
     Initialize a `RecognitionSettings` object to set the parameters of a Watson Speech to
     Text recognition request.

     - parameter contentType: The format of the audio data. Endianness is automatically detected
        by the Speech to Text service. For more information about the supported formats, visit:
        https://console.bluemix.net/docs/services/speech-to-text/input.html#formats

     - returns: An initialized `RecognitionSettings` object with the given `contentType`.
        Configure additional parameters for the recognition request by directly modifying
        the returned object's properties.
     */
    public init(contentType: String) {
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
    }
}
