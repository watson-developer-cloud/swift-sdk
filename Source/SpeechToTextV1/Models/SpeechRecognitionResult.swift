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
public struct SpeechRecognitionResult {

    /// An indication of whether the transcription results are final. If `true`, the results for this utterance are not updated further; no additional results are sent for a `result_index` once its results are indicated as final.
    public var finalResults: Bool

    /// An array of alternative transcripts. The `alternatives` array can include additional requested output such as word confidence or timestamps.
    public var alternatives: [SpeechRecognitionAlternative]

    /// A dictionary (or associative array) whose keys are the strings specified for `keywords` if both that parameter and `keywords_threshold` are specified. A keyword for which no matches are found is omitted from the array. The array is omitted if no keywords are found.
    public var keywordsResult: [String: [KeywordResult]]?

    /// An array of alternative hypotheses found for words of the input audio if a `word_alternatives_threshold` is specified.
    public var wordAlternatives: [WordAlternativeResults]?

    /**
     Initialize a `SpeechRecognitionResult` with member variables.

     - parameter finalResults: An indication of whether the transcription results are final. If `true`, the results for this utterance are not updated further; no additional results are sent for a `result_index` once its results are indicated as final.
     - parameter alternatives: An array of alternative transcripts. The `alternatives` array can include additional requested output such as word confidence or timestamps.
     - parameter keywordsResult: A dictionary (or associative array) whose keys are the strings specified for `keywords` if both that parameter and `keywords_threshold` are specified. A keyword for which no matches are found is omitted from the array. The array is omitted if no keywords are found.
     - parameter wordAlternatives: An array of alternative hypotheses found for words of the input audio if a `word_alternatives_threshold` is specified.

     - returns: An initialized `SpeechRecognitionResult`.
    */
    public init(finalResults: Bool, alternatives: [SpeechRecognitionAlternative], keywordsResult: [String: [KeywordResult]]? = nil, wordAlternatives: [WordAlternativeResults]? = nil) {
        self.finalResults = finalResults
        self.alternatives = alternatives
        self.keywordsResult = keywordsResult
        self.wordAlternatives = wordAlternatives
    }
}

extension SpeechRecognitionResult: Codable {

    private enum CodingKeys: String, CodingKey {
        case finalResults = "final"
        case alternatives = "alternatives"
        case keywordsResult = "keywords_result"
        case wordAlternatives = "word_alternatives"
        static let allValues = [finalResults, alternatives, keywordsResult, wordAlternatives]
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        finalResults = try container.decode(Bool.self, forKey: .finalResults)
        alternatives = try container.decode([SpeechRecognitionAlternative].self, forKey: .alternatives)
        keywordsResult = try container.decodeIfPresent([String: [KeywordResult]].self, forKey: .keywordsResult)
        wordAlternatives = try container.decodeIfPresent([WordAlternativeResults].self, forKey: .wordAlternatives)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(finalResults, forKey: .finalResults)
        try container.encode(alternatives, forKey: .alternatives)
        try container.encodeIfPresent(keywordsResult, forKey: .keywordsResult)
        try container.encodeIfPresent(wordAlternatives, forKey: .wordAlternatives)
    }

}
