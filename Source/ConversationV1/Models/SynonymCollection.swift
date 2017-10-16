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

/** SynonymCollection. */
public struct SynonymCollection {

    /// An array of synonyms.
    public var synonyms: [Synonym]

    /// An object defining the pagination data for the returned objects.
    public var pagination: Pagination

    /**
     Initialize a `SynonymCollection` with member variables.

     - parameter synonyms: An array of synonyms.
     - parameter pagination: An object defining the pagination data for the returned objects.

     - returns: An initialized `SynonymCollection`.
    */
    public init(synonyms: [Synonym], pagination: Pagination) {
        self.synonyms = synonyms
        self.pagination = pagination
    }
}

extension SynonymCollection: Codable {

    private enum CodingKeys: String, CodingKey {
        case synonyms = "synonyms"
        case pagination = "pagination"
        static let allValues = [synonyms, pagination]
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        synonyms = try container.decode([Synonym].self, forKey: .synonyms)
        pagination = try container.decode(Pagination.self, forKey: .pagination)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(synonyms, forKey: .synonyms)
        try container.encode(pagination, forKey: .pagination)
    }

}
