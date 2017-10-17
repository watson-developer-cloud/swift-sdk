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

/** The sentiment of the content. */
public struct SentimentResult {

    /// The document level sentiment.
    public var document: DocumentSentimentResults?

    /// The targeted sentiment to analyze.
    public var targets: [TargetedSentimentResults]?

    /**
     Initialize a `SentimentResult` with member variables.

     - parameter document: The document level sentiment.
     - parameter targets: The targeted sentiment to analyze.

     - returns: An initialized `SentimentResult`.
    */
    public init(document: DocumentSentimentResults? = nil, targets: [TargetedSentimentResults]? = nil) {
        self.document = document
        self.targets = targets
    }
}

extension SentimentResult: Codable {

    private enum CodingKeys: String, CodingKey {
        case document = "document"
        case targets = "targets"
        static let allValues = [document, targets]
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        document = try container.decodeIfPresent(DocumentSentimentResults.self, forKey: .document)
        targets = try container.decodeIfPresent([TargetedSentimentResults].self, forKey: .targets)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(document, forKey: .document)
        try container.encodeIfPresent(targets, forKey: .targets)
    }

}
