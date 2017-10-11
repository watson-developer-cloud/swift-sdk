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

/** An option specifying if sentiment of detected entities, keywords, or phrases should be returned. */
public struct SentimentOptions {

    /// Set this to false to hide document-level sentiment results.
    public var document: Bool?

    /// Sentiment results will be returned for each target string that is found in the document.
    public var targets: [String]?

    /**
     Initialize a `SentimentOptions` with member variables.

     - parameter document: Set this to false to hide document-level sentiment results.
     - parameter targets: Sentiment results will be returned for each target string that is found in the document.

     - returns: An initialized `SentimentOptions`.
    */
    public init(document: Bool? = nil, targets: [String]? = nil) {
        self.document = document
        self.targets = targets
    }
}

extension SentimentOptions: Codable {

    private enum CodingKeys: String, CodingKey {
        case document = "document"
        case targets = "targets"
        static let allValues = [document, targets]
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        document = try container.decodeIfPresent(Bool.self, forKey: .document)
        targets = try container.decodeIfPresent([String].self, forKey: .targets)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(document, forKey: .document)
        try container.encodeIfPresent(targets, forKey: .targets)
    }

}
