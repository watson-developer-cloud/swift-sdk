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

/** TrainingExamplePatch. */
public struct TrainingExamplePatch {

    public var crossReference: String?

    public var relevance: Int?

    /**
     Initialize a `TrainingExamplePatch` with member variables.

     - parameter crossReference:
     - parameter relevance:

     - returns: An initialized `TrainingExamplePatch`.
    */
    public init(crossReference: String? = nil, relevance: Int? = nil) {
        self.crossReference = crossReference
        self.relevance = relevance
    }
}

extension TrainingExamplePatch: Codable {

    private enum CodingKeys: String, CodingKey {
        case crossReference = "cross_reference"
        case relevance = "relevance"
        static let allValues = [crossReference, relevance]
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        crossReference = try container.decodeIfPresent(String.self, forKey: .crossReference)
        relevance = try container.decodeIfPresent(Int.self, forKey: .relevance)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(crossReference, forKey: .crossReference)
        try container.encodeIfPresent(relevance, forKey: .relevance)
    }

}
