/**
 * (C) Copyright IBM Corp. 2020.
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
 Default query parameters for this project.
 */
public struct DefaultQueryParams: Codable, Equatable {

    /**
     An array of collection identifiers to query. If empty or omitted all collections in the project are queried.
     */
    public var collectionIDs: [String]?

    /**
     Default settings configuration for passage search options.
     */
    public var passages: DefaultQueryParamsPassages?

    /**
     Default project query settings for table results.
     */
    public var tableResults: DefaultQueryParamsTableResults?

    /**
     A string representing the default aggregation query for the project.
     */
    public var aggregation: String?

    /**
     Object containing suggested refinement settings.
     */
    public var suggestedRefinements: DefaultQueryParamsSuggestedRefinements?

    /**
     When `true`, a spelling suggestions for the query are returned by default.
     */
    public var spellingSuggestions: Bool?

    /**
     When `true`, a highlights for the query are returned by default.
     */
    public var highlight: Bool?

    /**
     The number of document results returned by default.
     */
    public var count: Int?

    /**
     A comma separated list of document fields to sort results by default.
     */
    public var sort: String?

    /**
     An array of field names to return in document results if present by default.
     */
    public var `return`: [String]?

    // Map each property name to the key that shall be used for encoding/decoding.
    private enum CodingKeys: String, CodingKey {
        case collectionIDs = "collection_ids"
        case passages = "passages"
        case tableResults = "table_results"
        case aggregation = "aggregation"
        case suggestedRefinements = "suggested_refinements"
        case spellingSuggestions = "spelling_suggestions"
        case highlight = "highlight"
        case count = "count"
        case sort = "sort"
        case `return` = "return"
    }

    /**
      Initialize a `DefaultQueryParams` with member variables.

      - parameter collectionIDs: An array of collection identifiers to query. If empty or omitted all collections in
        the project are queried.
      - parameter passages: Default settings configuration for passage search options.
      - parameter tableResults: Default project query settings for table results.
      - parameter aggregation: A string representing the default aggregation query for the project.
      - parameter suggestedRefinements: Object containing suggested refinement settings.
      - parameter spellingSuggestions: When `true`, a spelling suggestions for the query are returned by default.
      - parameter highlight: When `true`, a highlights for the query are returned by default.
      - parameter count: The number of document results returned by default.
      - parameter sort: A comma separated list of document fields to sort results by default.
      - parameter `return`: An array of field names to return in document results if present by default.

      - returns: An initialized `DefaultQueryParams`.
     */
    public init(
        collectionIDs: [String]? = nil,
        passages: DefaultQueryParamsPassages? = nil,
        tableResults: DefaultQueryParamsTableResults? = nil,
        aggregation: String? = nil,
        suggestedRefinements: DefaultQueryParamsSuggestedRefinements? = nil,
        spellingSuggestions: Bool? = nil,
        highlight: Bool? = nil,
        count: Int? = nil,
        sort: String? = nil,
        `return`: [String]? = nil
    )
    {
        self.collectionIDs = collectionIDs
        self.passages = passages
        self.tableResults = tableResults
        self.aggregation = aggregation
        self.suggestedRefinements = suggestedRefinements
        self.spellingSuggestions = spellingSuggestions
        self.highlight = highlight
        self.count = count
        self.sort = sort
        self.`return` = `return`
    }

}
