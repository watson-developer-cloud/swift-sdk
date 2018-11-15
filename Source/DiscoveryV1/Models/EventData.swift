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
 Query event data object.
 */
public struct EventData: Codable, Equatable {

    /**
     The **environment_id** associated with the query that the event is associated with.
     */
    public var environmentID: String

    /**
     The session token that was returned as part of the query results that this event is associated with.
     */
    public var sessionToken: String

    /**
     The optional timestamp for the event that was created. If not provided, the time that the event was created in the
     log was used.
     */
    public var clientTimestamp: Date?

    /**
     The rank of the result item which the event is associated with.
     */
    public var displayRank: Int?

    /**
     The **collection_id** of the document that this event is associated with.
     */
    public var collectionID: String

    /**
     The **document_id** of the document that this event is associated with.
     */
    public var documentID: String

    /**
     The query identifier stored in the log. The query and any events associated with that query are stored with the
     same **query_id**.
     */
    public var queryID: String?

    // Map each property name to the key that shall be used for encoding/decoding.
    private enum CodingKeys: String, CodingKey {
        case environmentID = "environment_id"
        case sessionToken = "session_token"
        case clientTimestamp = "client_timestamp"
        case displayRank = "display_rank"
        case collectionID = "collection_id"
        case documentID = "document_id"
        case queryID = "query_id"
    }

    /**
     Initialize a `EventData` with member variables.

     - parameter environmentID: The **environment_id** associated with the query that the event is associated with.
     - parameter sessionToken: The session token that was returned as part of the query results that this event is
       associated with.
     - parameter collectionID: The **collection_id** of the document that this event is associated with.
     - parameter documentID: The **document_id** of the document that this event is associated with.
     - parameter clientTimestamp: The optional timestamp for the event that was created. If not provided, the time
       that the event was created in the log was used.
     - parameter displayRank: The rank of the result item which the event is associated with.
     - parameter queryID: The query identifier stored in the log. The query and any events associated with that query
       are stored with the same **query_id**.

     - returns: An initialized `EventData`.
    */
    public init(
        environmentID: String,
        sessionToken: String,
        collectionID: String,
        documentID: String,
        clientTimestamp: Date? = nil,
        displayRank: Int? = nil,
        queryID: String? = nil
    )
    {
        self.environmentID = environmentID
        self.sessionToken = sessionToken
        self.collectionID = collectionID
        self.documentID = documentID
        self.clientTimestamp = clientTimestamp
        self.displayRank = displayRank
        self.queryID = queryID
    }

}
