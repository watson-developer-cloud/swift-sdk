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
import Freddy

/**
 The settings associated with a Speech to Text recognition request. Any `nil` parameters will
 use a default value provided by the Watson Speech to Text service.
 
 Visit https://ibm.biz/BdHCrX for more information about the Speech to Text service's
 parameters.
 */
public struct RecognitionSettings: JSONEncodable {

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
     Initialize a `RecognitionSettings` object to set the parameters of a Watson Speech to
     Text recognition request.

     - parameter contentType: The format of the audio data. Endianness is automatically detected
        by the Speech to Text service. Visit https://ibm.biz/BdHCrB for more information about
        the supported formats.
     
     - returns: An initialized `RecognitionSettings` object with the given `contentType`.
        Configure additional parameters for the recognition request by directly modifying
        the returned object's properties.
     */
    public init(contentType: AudioMediaType) {
        self.contentType = contentType
    }

    /** Used internally to serialize a `RecognitionSettings` model to JSON. */
    public func toJSON() -> JSON {
        var json = [String: JSON]()
        json["action"] = .String(action)
        json["content-type"] = .String(contentType.toString)
        if let continuous = continuous {
            json["continuous"] = .Bool(continuous)
        }
        if let inactivityTimeout = inactivityTimeout {
            json["inactivity_timeout"] = .Int(inactivityTimeout)
        }
        if let keywords = keywords {
            json["keywords"] = keywords.toJSON()
        }
        if let keywordsThreshold = keywordsThreshold {
            json["keywords_threshold"] = .Double(keywordsThreshold)
        }
        if let maxAlternatives = maxAlternatives {
            json["max_alternatives"] = .Int(maxAlternatives)
        }
        if let interimResults = interimResults {
            json["interim_results"] = .Bool(interimResults)
        }
        if let wordAlternativesThreshold = wordAlternativesThreshold {
            json["word_alternatives_threshold"] = .Double(wordAlternativesThreshold)
        }
        if let wordConfidence = wordConfidence {
            json["word_confidence"] = .Bool(wordConfidence)
        }
        if let timestamps = timestamps {
            json["timestamps"] = .Bool(timestamps)
        }
        if let filterProfanity = filterProfanity {
            json["profanity_filter"] = .Bool(filterProfanity)
        }
        return .Dictionary(json)
    }
}

/**
 Audio formats supported by the Watson Speech to Text service.
 */
public enum AudioMediaType {
    
    /// FLAC audio format
    case FLAC
    
    /// L16 audio format with a rate and channels
    case L16(rate: Int, channels: Int)
    
    /// WAV audio format
    case WAV
    
    /// Opus audio format
    case Opus

    /// A representation of the audio format as a MIME type string.
    var toString: String {
        switch self {
        case .FLAC:                        return "audio/flac"
        case .L16(let rate, let channels): return "audio/l16;rate=\(rate);channels=\(channels)"
        case .WAV:                         return "audio/wav"
        case .Opus:                        return "audio/ogg;codecs=opus"
        }
    }
}
