/**
 * (C) Copyright IBM Corp. 2019.
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

/**
 Object containing training query details.
 */
public struct TrainingQuery: Codable, Equatable {

    /**
     The query ID associated with the training query.
     */
    public var queryID: String?

    /**
     The natural text query for the training query.
     */
    public var naturalLanguageQuery: String

    /**
     The filter used on the collection before the **natural_language_query** is applied.
     */
    public var filter: String?

    /**
     The date and time the query was created.
     */
    public var created: Date?

    /**
     The date and time the query was updated.
     */
    public var updated: Date?

    /**
     Array of training examples.
     */
    public var examples: [TrainingExample]

    // Map each property name to the key that shall be used for encoding/decoding.
    private enum CodingKeys: String, CodingKey {
        case queryID = "query_id"
        case naturalLanguageQuery = "natural_language_query"
        case filter = "filter"
        case created = "created"
        case updated = "updated"
        case examples = "examples"
    }

    /**
     Initialize a `TrainingQuery` with member variables.

     - parameter naturalLanguageQuery: The natural text query for the training query.
     - parameter examples: Array of training examples.
     - parameter queryID: The query ID associated with the training query.
     - parameter filter: The filter used on the collection before the **natural_language_query** is applied.
     - parameter created: The date and time the query was created.
     - parameter updated: The date and time the query was updated.

     - returns: An initialized `TrainingQuery`.
     */
    public init(
        naturalLanguageQuery: String,
        examples: [TrainingExample],
        queryID: String? = nil,
        filter: String? = nil,
        created: Date? = nil,
        updated: Date? = nil
    )
    {
        self.naturalLanguageQuery = naturalLanguageQuery
        self.examples = examples
        self.queryID = queryID
        self.filter = filter
        self.created = created
        self.updated = updated
    }

}
