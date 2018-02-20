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

/** An object specifying the emotion detection enrichment and related parameters. */
public struct NluEnrichmentEmotion {

    /// When `true`, emotion detection is performed on the entire field.
    public var document: Bool?

    /// A comma-separated list of target strings that will have any associated emotions detected.
    public var targets: [String]?

    /**
     Initialize a `NluEnrichmentEmotion` with member variables.

     - parameter document: When `true`, emotion detection is performed on the entire field.
     - parameter targets: A comma-separated list of target strings that will have any associated emotions detected.

     - returns: An initialized `NluEnrichmentEmotion`.
    */
    public init(document: Bool? = nil, targets: [String]? = nil) {
        self.document = document
        self.targets = targets
    }
}

extension NluEnrichmentEmotion: Codable {

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
