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

/** Whether or not to analyze content for general concepts that are referenced or alluded to. */
public struct ConceptsOptions {

    /// Maximum number of concepts to return.
    public var limit: Int?

    /**
     Initialize a `ConceptsOptions` with member variables.

     - parameter limit: Maximum number of concepts to return.

     - returns: An initialized `ConceptsOptions`.
    */
    public init(limit: Int? = nil) {
        self.limit = limit
    }
}

extension ConceptsOptions: Codable {

    private enum CodingKeys: String, CodingKey {
        case limit = "limit"
        static let allValues = [limit]
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        limit = try container.decodeIfPresent(Int.self, forKey: .limit)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(limit, forKey: .limit)
    }

}
