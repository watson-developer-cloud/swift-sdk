/**
 * Copyright IBM Corporation 2018
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

/** SpeechRecognitionResult. */
public struct SpeechRecognitionResult: Codable, Equatable {

    /**
     An indication of whether the transcription results are final. If `true`, the results for this utterance are not
     updated further; no additional results are sent for a `result_index` once its results are indicated as final.
     */
    public var finalResults: Bool

    /**
     An array of alternative transcripts. The `alternatives` array can include additional requested output such as word
     confidence or timestamps.
     */
    public var alternatives: [SpeechRecognitionAlternative]

    /**
     A dictionary (or associative array) whose keys are the strings specified for `keywords` if both that parameter and
     `keywords_threshold` are specified. The value for each key is an array of matches spotted in the audio for that
     keyword. Each match is described by a `KeywordResult` object. A keyword for which no matches are found is omitted
     from the dictionary. The dictionary is omitted entirely if no matches are found for any keywords.
     */
    public var keywordsResult: [String: [KeywordResult]]?

    /**
     An array of alternative hypotheses found for words of the input audio if a `word_alternatives_threshold` is
     specified.
     */
    public var wordAlternatives: [WordAlternativeResults]?

    // Map each property name to the key that shall be used for encoding/decoding.
    private enum CodingKeys: String, CodingKey {
        case finalResults = "final"
        case alternatives = "alternatives"
        case keywordsResult = "keywords_result"
        case wordAlternatives = "word_alternatives"
    }

}
