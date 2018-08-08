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

/**
 A response containing the documents and aggregations for the query.
 */
public struct QueryResponse: Decodable {

    public var matchingResults: Int?

    public var results: [QueryResult]?

    public var aggregations: [QueryAggregation]?

    public var passages: [QueryPassages]?

    public var duplicatesRemoved: Int?

    /**
     The session token for this query. The session token can be used to add events associated with this query to the
     query and event log.
     **Important:** Session tokens are case sensitive.
     */
    public var sessionToken: String?

    // Map each property name to the key that shall be used for encoding/decoding.
    private enum CodingKeys: String, CodingKey {
        case matchingResults = "matching_results"
        case results = "results"
        case aggregations = "aggregations"
        case passages = "passages"
        case duplicatesRemoved = "duplicates_removed"
        case sessionToken = "session_token"
    }

}
