/**
 * Copyright IBM Corporation 2017
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

/** An object containing information about a corpus. */
public struct Corpus: JSONDecodable {

    /// The name of the corpus.
    public let name: String

    /// The total number of words in the corpus. This value is 0 while the corpus is being processed.
    public let totalWords: Int

    /// The number of out of vocabulary words in the corpus. This value is 0 while the corpus is
    /// still being processed.
    public let outOfVocabularyWords: Int

    /// The status of the corpus.
    public let status: CorpusStatus

    /// If the status of the corpus is undetermined, the error message will be noted here.
    public let error: String?

    /// Used internally to initialize a `Corpus` model from JSON.
    public init(json: JSONWrapper) throws {
        name = try json.getString(at: "name")
        totalWords = try json.getInt(at: "total_words")
        outOfVocabularyWords = try json.getInt(at: "out_of_vocabulary_words")
        guard let corpusStatus = CorpusStatus(rawValue: try json.getString(at: "status")) else {
            throw JSONWrapper.Error.valueNotConvertible(value: json, to: CorpusStatus.self)
        }
        status = corpusStatus
        error = try? json.getString(at: "error")
    }
}

/** The status of the corpus. */
public enum CorpusStatus: String {

    /// The service successfully analyzed the corpus. The custom model can now be trained with
    /// data from the corpus.
    case analyzed = "analyzed"

    /// The service is still analyzing the corpus. The service cannot accept requests to add new
    /// corpora or words, or to train the custom model.
    case beingProcessed = "being_processed"

    /// The service encountered an error while processing the corpus.
    case undetermined = "undetermined"
}
