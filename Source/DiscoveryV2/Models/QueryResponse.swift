/**
 * (C) Copyright IBM Corp. 2019, 2020.
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
 A response containing the documents and aggregations for the query.
 */
public struct QueryResponse: Codable, Equatable {

    /**
     The number of matching results for the query.
     */
    public var matchingResults: Int?

    /**
     Array of document results for the query.
     */
    public var results: [QueryResult]?

    /**
     Array of aggregations for the query.
     */
    public var aggregations: [QueryAggregation]?

    /**
     An object contain retrieval type information.
     */
    public var retrievalDetails: RetrievalDetails?

    /**
     Suggested correction to the submitted **natural_language_query** value.
     */
    public var suggestedQuery: String?

    /**
     Array of suggested refinements.
     */
    public var suggestedRefinements: [QuerySuggestedRefinement]?

    /**
     Array of table results.
     */
    public var tableResults: [QueryTableResult]?

    // Map each property name to the key that shall be used for encoding/decoding.
    private enum CodingKeys: String, CodingKey {
        case matchingResults = "matching_results"
        case results = "results"
        case aggregations = "aggregations"
        case retrievalDetails = "retrieval_details"
        case suggestedQuery = "suggested_query"
        case suggestedRefinements = "suggested_refinements"
        case tableResults = "table_results"
    }

}
