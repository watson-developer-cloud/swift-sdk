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

/**
 The settings associated with a Speech to Text recognition request. Any `nil` parameters will
 use a default value provided by the Watson Speech to Text service.
 
 Visit https://ibm.biz/BdHCrX for more information about the Speech to Text service's
 parameters.
 */
public struct SpeechToTextSettings: WatsonRequestModel {

    /***** URL query parameters for WebSockets connection request. *****/

    /// Specifies the language in which the audio is spoken and the rate at which it was
    /// sampled. If `nil`, then the default model will be used. Visit https://ibm.biz/BdH93p
    /// for more information about the available models.
    public var model: String?

    /// By default, the Speech to Text service logs requests and their results. Logging is
    /// done only for the purpose of improving the service for future users—the logged data
    /// is not shared or made public. If you are concerned with protecting the privacy of users'
    /// personal information or otherwise do not want your requests to be logged, you can opt
    /// out of logging by setting this property to `true`.
    public var learningOptOut: Bool?

    /***** JSON parameters for `start` message. *****/

    /// The action to perform. Must be `start` to begin the request.
    private let action = "start"

    /// The format of the audio data. Endianness is automatically detected by the Speech to Text
    /// service. Visit https://ibm.biz/BdHCrB for more information about the supported formats.
    public var contentType: AudioMediaType

    /// If `true`, then the entire audio stream will be transcribed until it terminates rather
    /// than stopping at the first half-second of non-speech. The default is `false`.
    public var continuous: Bool?

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

    /**
     Initialize a `SpeechToTextSettings` object to set the parameters of a Watson Speech to
     Text recognition request.

     - parameter contentType: The format of the audio data. Endianness is automatically detected
        by the Speech to Text service. Visit https://ibm.biz/BdHCrB for more information about
        the supported formats.
     
     - returns: An initialized `SpeechToTextSettings` object with the given `contentType`.
        Configure additional parameters for the recognition request by directly modifying
        the returned object's properties.
     */
    public init(contentType: AudioMediaType) {
        self.contentType = contentType
    }

    /** Represent a `SpeechToTextSettings` as a dictionary of key-value pairs. */
    func toDictionary() -> [String: AnyObject] {
        var map = [String: AnyObject]()
        map["action"] = action
        map["content-type"] = contentType.toString
        map["continuous"] = continuous
        map["max_alternatives"] = maxAlternatives
        map["interim_results"] = interimResults
        map["word_confidence"] = wordConfidence
        map["timestamps"] = timestamps
        map["keywords"] = keywords
        map["keywords_threshold"] = keywordsThreshold
        map["word_alternatives_threshold"] = wordAlternativesThreshold
        map["inactivity_timeout"] = inactivityTimeout
        return map
    }
}

/**
 Audio formats supported by the Watson Speech to Text service.
 */
public enum AudioMediaType {
    case FLAC
    case L16(rate: Int, channels: Int)
    case WAV
    case Opus

    var toString: String {
        switch self {
        case .FLAC:                        return "audio/flac"
        case .L16(let rate, let channels): return "audio/l16;rate=\(rate);channels=\(channels)"
        case .WAV:                         return "audio/wav"
        case .Opus:                        return "audio/ogg;codecs=opus"
        }
    }
}
