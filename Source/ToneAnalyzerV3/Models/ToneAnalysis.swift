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

/** ToneAnalysis. */
public struct ToneAnalysis {

    /// An object of type `DocumentAnalysis` that provides the results of the analysis for the full input document.
    public var documentTone: DocumentAnalysis

    /// An array of `SentenceAnalysis` objects that provides the results of the analysis for the individual sentences of the input content. The service returns results only for the first 100 sentences of the input. The field is omitted if the `sentences` parameter of the request is set to `false`.
    public var sentencesTone: [SentenceAnalysis]?

    /**
     Initialize a `ToneAnalysis` with member variables.

     - parameter documentTone: An object of type `DocumentAnalysis` that provides the results of the analysis for the full input document.
     - parameter sentencesTone: An array of `SentenceAnalysis` objects that provides the results of the analysis for the individual sentences of the input content. The service returns results only for the first 100 sentences of the input. The field is omitted if the `sentences` parameter of the request is set to `false`.

     - returns: An initialized `ToneAnalysis`.
    */
    public init(documentTone: DocumentAnalysis, sentencesTone: [SentenceAnalysis]? = nil) {
        self.documentTone = documentTone
        self.sentencesTone = sentencesTone
    }
}

extension ToneAnalysis: Codable {

    private enum CodingKeys: String, CodingKey {
        case documentTone = "document_tone"
        case sentencesTone = "sentences_tone"
        static let allValues = [documentTone, sentencesTone]
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        documentTone = try container.decode(DocumentAnalysis.self, forKey: .documentTone)
        sentencesTone = try container.decodeIfPresent([SentenceAnalysis].self, forKey: .sentencesTone)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(documentTone, forKey: .documentTone)
        try container.encodeIfPresent(sentencesTone, forKey: .sentencesTone)
    }

}
