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

/** A result from a Speech to Text recognition request. */
public struct SpeechToTextResult: Mappable {

    /// If `true`, then the transcription result for this
    /// utterance is final and will not be updated further.
    public var final: Bool!

    /// Alternative transcription results.
    public var alternatives: [SpeechToTextTranscription]!

    /// A dictionary of spotted keywords and their associated matches. A keyword will have
    /// no associated matches if it was not found within the audio input or the threshold
    /// was set too high.
    public var keywordResults: [String: [SpeechToTextKeywordResult]]?

    /// A list of acoustically similar alternatives for words of the input audio.
    public var wordAlternatives: [SpeechToTextWordAlternativeResults]?

    /// Used internally to initialize a `SpeechToTextResult` from JSON.
    public init?(_ map: Map) { }

    /// Used internally to serialize and deserialize JSON.
    public mutating func mapping(map: Map) {
        final            <- map["final"]
        alternatives     <- map["alternatives"]
        keywordResults   <- map["keywords_result"]
        wordAlternatives <- map["word_alternatives"]
    }
}
