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
 Top value result for the term aggregation.
 */
public struct QueryGroupByAggregationResult: Codable, Equatable {

    /**
     Value of the field with a non-zero frequency in the document set.
     */
    public var key: String

    /**
     Number of documents containing the 'key'.
     */
    public var matchingResults: Int

    /**
     The relevancy for this group.
     */
    public var relevancy: Double?

    /**
     The number of documents which have the group as the value of specified field in the whole set of documents in this
     collection. Returned only when the `relevancy` parameter is set to `true`.
     */
    public var totalMatchingDocuments: Int?

    /**
     The estimated number of documents which would match the query and also meet the condition. Returned only when the
     `relevancy` parameter is set to `true`.
     */
    public var estimatedMatchingDocuments: Int?

    /**
     An array of sub aggregations.
     */
    public var aggregations: [QueryAggregation]?

    // Map each property name to the key that shall be used for encoding/decoding.
    private enum CodingKeys: String, CodingKey {
        case key = "key"
        case matchingResults = "matching_results"
        case relevancy = "relevancy"
        case totalMatchingDocuments = "total_matching_documents"
        case estimatedMatchingDocuments = "estimated_matching_documents"
        case aggregations = "aggregations"
    }

}
