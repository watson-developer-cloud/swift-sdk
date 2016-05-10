/************************************************************************/
 /*                                                                      */
 /* IBM Confidential                                                     */
 /* OCO Source Materials                                                 */
 /*                                                                      */
 /* (C) Copyright IBM Corp. 2015, 2016                                   */
 /*                                                                      */
 /* The source code for this program is not published or otherwise       */
 /* divested of its trade secrets, irrespective of what has been         */
 /* deposited with the U.S. Copyright Office.                            */
 /*                                                                      */
 /************************************************************************/

import Foundation

// Class that bridges to the Watson SpeechToTextSettings class
public class SpeechToTextOptions: NSObject {
    
    /// Model used
    public var model: String = ""
    /// By default, the Speech to Text service logs requests and their results. Logging is
    /// done only for the purpose of improving the service for future users—the logged data
    /// is not shared or made public. If you are concerned with protecting the privacy of users'
    /// personal information or otherwise do not want your requests to be logged, you can opt
    /// out of logging by setting this property to `true`.
    public var learningOptOut: Bool = false
    /// The format of the audio data. Endianness is automatically detected by the Speech to Text
    public var contentType: AudioType = AudioType.WAV
    /// If `true`, then the entire audio stream will be transcribed until it terminates rather
    /// than stopping at the first half-second of non-speech. The default is `false`.
    public var continuous: Bool = false
    /// The number of seconds after which the connection is to time out due to inactivity.
    /// Use `-1` to set the timeout to infinity. The default is `30` seconds.
    public var inactivityTimeout: Int = 30
    /// An array of keyword strings to be matched in the input audio. By default, the service
    /// does not perform any keyword spotting.
    public var keywords: NSArray = NSArray()
    /// A minimum level of confidence that the service must have to report a matching keyword
    /// in the input audio. The threshold must be a probability value between `0` and `1`
    /// inclusive. A match must have at least the specified confidence to be returned. If you
    /// specify a valid threshold, you must also specify at least one keyword. By default, the
    /// service does not perform any keyword spotting.
    public var keywordsThreshold: Double = 0.0
    /// The maximum number of alternative transcriptions to receive. The default is 1.
    public var maxAlternatives: Int = 0
    /// If `true`, then interim results (i.e. results that are not final) will be received
    /// for the transcription. The default is `false`.
    public var intremResults: Bool = false
    /// A minimum level of confidence that the service must have to report a hypothesis for a
    /// word from the input audio. The threshold must be a probability value between `0` and `1`
    /// inclusive. A hypothesis must have at least the specified confidence to be returned as a
    /// word alternative. By default, the service does not return any word alternatives.
    public var wordAlternativesThreshold: Double = 0.0
    /// If `true`, then a confidence score will be received for each word of the transcription.
    /// The default is `false`.
    public var wordConfidence: Bool = false
    /// If `true`, then per-word start and end times relative to the beginning of the audio will
    /// be received. The default is `false`.
    public var timestamps: Bool = false
    /// If `true`, then profanity will be censored from the service's output, obscuring each
    /// occurrence with a set of asterisks. The default is `true`.
    public var filterProfanity: Bool = true
    // The sample rate for L16 encoded audio. The defualt is `48000`.
    public var audioTypeL16Rate: Int = 48000
    // The number of channels an L16 encoded audio track has. The default is `1`.
    public var audioTypeL16Channels: Int = 1
    
    public init(contentType: AudioType) {
        super.init()
        self.contentType = contentType
    }
    
    public init(ContentType: AudioType, l16Rate: Int, l16Channels: Int) {
        super.init()
        self.audioTypeL16Rate = l16Rate
        self.audioTypeL16Channels = l16Channels
    }
    
    public override init() {
        super.init()
    }
    
    /**
     Convert settings to the SpeechToTextSettings object.
     */
    func toSpeechToTextSettings() -> SpeechToTextSettings {
        var sttSettings : SpeechToTextSettings
        if(contentType == AudioType.L16) {
            sttSettings = SpeechToTextSettings(contentType: AudioMediaType.L16(rate: audioTypeL16Rate, channels: audioTypeL16Channels))
        } else {
            sttSettings = SpeechToTextSettings(contentType: contentType.toAudioMediaType)
        }
        if self.model != "" {
            sttSettings.model = self.model
        }
        sttSettings.learningOptOut = self.learningOptOut
        sttSettings.continuous = self.continuous
        sttSettings.inactivityTimeout = self.inactivityTimeout
        if(self.keywords.count > 0) {
            sttSettings.keywords = self.keywords as? [String]
        }
        if(self.keywordsThreshold != 0.0) {
            sttSettings.keywordsThreshold = self.keywordsThreshold
        }
        if(self.maxAlternatives != 0) {
            sttSettings.maxAlternatives = self.maxAlternatives
        }
        
        sttSettings.interimResults = self.intremResults
        if(self.wordAlternativesThreshold != 0.0) {
            sttSettings.wordAlternativesThreshold = self.wordAlternativesThreshold
        }
        
        sttSettings.wordConfidence = self.wordConfidence
        sttSettings.timestamps = self.timestamps
        sttSettings.filterProfanity = self.filterProfanity
        return sttSettings
    }
    
    /**
     Audio formats supported by the Watson Speech to Text service.
     */
    @objc public enum AudioType : NSInteger {
        case FLAC
     //   case L16(rate: Int, channels: Int)
        case L16
        case WAV
        case Opus
        
        var toString: String {
            switch self {
            case .FLAC:                        return "audio/flac"
     //       case .L16(let rate, let channels): return "audio/l16;rate=\(rate);channels=\(channels)"
            case .L16:                         return "audio/l16;"
            case .WAV:                         return "audio/wav"
            case .Opus:                        return "audio/ogg;codecs=opus"
            }
        }
        
        private var toAudioMediaType: AudioMediaType {
            switch self {
            case .FLAC:                        return AudioMediaType.FLAC
      //      case .L16(let rate, let channels): return AudioMediaType.L16(rate: rate, channels: channels)
            case .L16:                         return AudioMediaType.L16(rate: 48000, channels: 1)
            case .WAV:                         return AudioMediaType.WAV
            case .Opus:                        return AudioMediaType.Opus
            }
        }
    }
}
