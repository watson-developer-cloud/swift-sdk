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

/** TrainingQuery. */
public struct TrainingQuery {

    public var queryID: String?

    public var naturalLanguageQuery: String?

    public var filter: String?

    public var examples: [TrainingExample]?

    /**
     Initialize a `TrainingQuery` with member variables.

     - parameter queryID:
     - parameter naturalLanguageQuery:
     - parameter filter:
     - parameter examples:

     - returns: An initialized `TrainingQuery`.
    */
    public init(queryID: String? = nil, naturalLanguageQuery: String? = nil, filter: String? = nil, examples: [TrainingExample]? = nil) {
        self.queryID = queryID
        self.naturalLanguageQuery = naturalLanguageQuery
        self.filter = filter
        self.examples = examples
    }
}

extension TrainingQuery: Codable {

    private enum CodingKeys: String, CodingKey {
        case queryID = "query_id"
        case naturalLanguageQuery = "natural_language_query"
        case filter = "filter"
        case examples = "examples"
        static let allValues = [queryID, naturalLanguageQuery, filter, examples]
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        queryID = try container.decodeIfPresent(String.self, forKey: .queryID)
        naturalLanguageQuery = try container.decodeIfPresent(String.self, forKey: .naturalLanguageQuery)
        filter = try container.decodeIfPresent(String.self, forKey: .filter)
        examples = try container.decodeIfPresent([TrainingExample].self, forKey: .examples)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(queryID, forKey: .queryID)
        try container.encodeIfPresent(naturalLanguageQuery, forKey: .naturalLanguageQuery)
        try container.encodeIfPresent(filter, forKey: .filter)
        try container.encodeIfPresent(examples, forKey: .examples)
    }

}
