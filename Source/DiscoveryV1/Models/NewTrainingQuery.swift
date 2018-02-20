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

/** NewTrainingQuery. */
public struct NewTrainingQuery {

    public var naturalLanguageQuery: String?

    public var filter: String?

    public var examples: [TrainingExample]?

    /**
     Initialize a `NewTrainingQuery` with member variables.

     - parameter naturalLanguageQuery:
     - parameter filter:
     - parameter examples:

     - returns: An initialized `NewTrainingQuery`.
    */
    public init(naturalLanguageQuery: String? = nil, filter: String? = nil, examples: [TrainingExample]? = nil) {
        self.naturalLanguageQuery = naturalLanguageQuery
        self.filter = filter
        self.examples = examples
    }
}

extension NewTrainingQuery: Codable {

    private enum CodingKeys: String, CodingKey {
        case naturalLanguageQuery = "natural_language_query"
        case filter = "filter"
        case examples = "examples"
        static let allValues = [naturalLanguageQuery, filter, examples]
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        naturalLanguageQuery = try container.decodeIfPresent(String.self, forKey: .naturalLanguageQuery)
        filter = try container.decodeIfPresent(String.self, forKey: .filter)
        examples = try container.decodeIfPresent([TrainingExample].self, forKey: .examples)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(naturalLanguageQuery, forKey: .naturalLanguageQuery)
        try container.encodeIfPresent(filter, forKey: .filter)
        try container.encodeIfPresent(examples, forKey: .examples)
    }

}
