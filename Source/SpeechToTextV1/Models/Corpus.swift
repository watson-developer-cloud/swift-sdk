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

/** Corpus. */
public struct Corpus {

    /// The status of the corpus: * `analyzed` indicates that the service has successfully analyzed the corpus; the custom model can be trained with data from the corpus. * `being_processed` indicates that the service is still analyzing the corpus; the service cannot accept requests to add new corpora or words, or to train the custom model. * `undetermined` indicates that the service encountered an error while processing the corpus.
    public enum Status: String {
        case analyzed = "analyzed"
        case beingProcessed = "being_processed"
        case undetermined = "undetermined"
    }

    /// The name of the corpus.
    public var name: String

    /// The total number of words in the corpus. The value is `0` while the corpus is being processed.
    public var totalWords: Int

    /// The number of OOV words in the corpus. The value is `0` while the corpus is being processed.
    public var outOfVocabularyWords: Int

    /// The status of the corpus: * `analyzed` indicates that the service has successfully analyzed the corpus; the custom model can be trained with data from the corpus. * `being_processed` indicates that the service is still analyzing the corpus; the service cannot accept requests to add new corpora or words, or to train the custom model. * `undetermined` indicates that the service encountered an error while processing the corpus.
    public var status: String

    /// If the status of the corpus is `undetermined`, the following message: `Analysis of corpus 'name' failed. Please try adding the corpus again by setting the 'allow_overwrite' flag to 'true'`.
    public var error: String?

    /**
     Initialize a `Corpus` with member variables.

     - parameter name: The name of the corpus.
     - parameter totalWords: The total number of words in the corpus. The value is `0` while the corpus is being processed.
     - parameter outOfVocabularyWords: The number of OOV words in the corpus. The value is `0` while the corpus is being processed.
     - parameter status: The status of the corpus: * `analyzed` indicates that the service has successfully analyzed the corpus; the custom model can be trained with data from the corpus. * `being_processed` indicates that the service is still analyzing the corpus; the service cannot accept requests to add new corpora or words, or to train the custom model. * `undetermined` indicates that the service encountered an error while processing the corpus.
     - parameter error: If the status of the corpus is `undetermined`, the following message: `Analysis of corpus 'name' failed. Please try adding the corpus again by setting the 'allow_overwrite' flag to 'true'`.

     - returns: An initialized `Corpus`.
    */
    public init(name: String, totalWords: Int, outOfVocabularyWords: Int, status: String, error: String? = nil) {
        self.name = name
        self.totalWords = totalWords
        self.outOfVocabularyWords = outOfVocabularyWords
        self.status = status
        self.error = error
    }
}

extension Corpus: Codable {

    private enum CodingKeys: String, CodingKey {
        case name = "name"
        case totalWords = "total_words"
        case outOfVocabularyWords = "out_of_vocabulary_words"
        case status = "status"
        case error = "error"
        static let allValues = [name, totalWords, outOfVocabularyWords, status, error]
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decode(String.self, forKey: .name)
        totalWords = try container.decode(Int.self, forKey: .totalWords)
        outOfVocabularyWords = try container.decode(Int.self, forKey: .outOfVocabularyWords)
        status = try container.decode(String.self, forKey: .status)
        error = try container.decodeIfPresent(String.self, forKey: .error)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(totalWords, forKey: .totalWords)
        try container.encode(outOfVocabularyWords, forKey: .outOfVocabularyWords)
        try container.encode(status, forKey: .status)
        try container.encodeIfPresent(error, forKey: .error)
    }

}
