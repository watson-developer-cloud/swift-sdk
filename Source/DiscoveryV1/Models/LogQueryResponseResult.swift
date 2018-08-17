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
 Individual result object for a **logs** query. Each object represents either a query to a Discovery collection or an
 event that is associated with a query.
 */
public struct LogQueryResponseResult: Decodable {

    /**
     The type of log entry returned.
      **query** indicates that the log represents the results of a call to the single collection **query** method.
      **event** indicates that the log represents  a call to the **events** API.
     */
    public enum DocumentType: String {
        case query = "query"
        case event = "event"
    }

    /**
     The type of event that this object respresents. Possible values are
      -  `query` the log of a query to a collection
      -  `click` the result of a call to the **events** endpoint.
     */
    public enum EventType: String {
        case click = "click"
        case query = "query"
    }

    /**
     The type of result that this **event** is associated with. Only returned with logs of type `event`.
     */
    public enum ResultType: String {
        case document = "document"
    }

    /**
     The environment ID that is associated with this log entry.
     */
    public var environmentID: String?

    /**
     The **customer_id** label that was specified in the header of the query or event API call that corresponds to this
     log entry.
     */
    public var customerID: String?

    /**
     The type of log entry returned.
      **query** indicates that the log represents the results of a call to the single collection **query** method.
      **event** indicates that the log represents  a call to the **events** API.
     */
    public var documentType: String?

    /**
     The value of the **natural_language_query** query parameter that was used to create these results. Only returned
     with logs of type **query**.
     **Note:** Other query parameters (such as **filter** or **deduplicate**) might  have been used with this query, but
     are not recorded.
     */
    public var naturalLanguageQuery: String?

    /**
     Object containing result information that was returned by the query used to create this log entry. Only returned
     with logs of type `query`.
     */
    public var documentResults: LogQueryResponseResultDocuments?

    /**
     Date that the log result was created. Returned in `YYYY-MM-DDThh:mm:ssZ` format.
     */
    public var createdTimestamp: String?

    /**
     Date specified by the user when recording an event. Returned in `YYYY-MM-DDThh:mm:ssZ` format. Only returned with
     logs of type **event**.
     */
    public var clientTimestamp: String?

    /**
     Identifier that corresponds to the **natural_language_query** string used in the original or associated query. All
     **event** and **query** log entries that have the same original **natural_language_query** string also have them
     same **query_id**. This field can be used to recall all **event** and **query** log results that have the same
     original query (**event** logs do not contain the original **natural_language_query** field).
     */
    public var queryID: String?

    /**
     Unique identifier (within a 24-hour period) that identifies a single `query` log and any `event` logs that were
     created for it.
     **Note:** If the exact same query is run at the exact same time on different days, the **session_token** for those
     queries might be identical. However, the **created_timestamp** differs.
     **Note:** Session tokens are case sensitive. To avoid matching on session tokens that are identical except for
     case, use the exact match operator (`::`) when you query for a specific session token.
     */
    public var sessionToken: String?

    /**
     The collection ID of the document associated with this event. Only returned with logs of type `event`.
     */
    public var collectionID: String?

    /**
     The original display rank of the document associated with this event. Only returned with logs of type `event`.
     */
    public var displayRank: Int?

    /**
     The document ID of the document associated with this event. Only returned with logs of type `event`.
     */
    public var documentID: String?

    /**
     The type of event that this object respresents. Possible values are
      -  `query` the log of a query to a collection
      -  `click` the result of a call to the **events** endpoint.
     */
    public var eventType: String?

    /**
     The type of result that this **event** is associated with. Only returned with logs of type `event`.
     */
    public var resultType: String?

    // Map each property name to the key that shall be used for encoding/decoding.
    private enum CodingKeys: String, CodingKey {
        case environmentID = "environment_id"
        case customerID = "customer_id"
        case documentType = "document_type"
        case naturalLanguageQuery = "natural_language_query"
        case documentResults = "document_results"
        case createdTimestamp = "created_timestamp"
        case clientTimestamp = "client_timestamp"
        case queryID = "query_id"
        case sessionToken = "session_token"
        case collectionID = "collection_id"
        case displayRank = "display_rank"
        case documentID = "document_id"
        case eventType = "event_type"
        case resultType = "result_type"
    }

}
