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
 An object that describes a response with response type `search_skill`.

 Enums with an associated value of DialogNodeOutputGenericDialogNodeOutputResponseTypeSearchSkill:
    DialogNodeOutputGeneric
 */
public struct DialogNodeOutputGenericDialogNodeOutputResponseTypeSearchSkill: Codable, Equatable {

    /**
     The type of response returned by the dialog node. The specified response type must be supported by the client
     application or channel.
     **Note:** The **search_skill** response type is used only by the v2 runtime API.
     */
    public enum ResponseType: String {
        case searchSkill = "search_skill"
    }

    /**
     The type of the search query.
     */
    public enum QueryType: String {
        case naturalLanguage = "natural_language"
        case discoveryQueryLanguage = "discovery_query_language"
    }

    /**
     The type of response returned by the dialog node. The specified response type must be supported by the client
     application or channel.
     **Note:** The **search_skill** response type is used only by the v2 runtime API.
     */
    public var responseType: String

    /**
     The text of the search query. This can be either a natural-language query or a query that uses the Discovery query
     language syntax, depending on the value of the **query_type** property. For more information, see the [Discovery
     service documentation](https://cloud.ibm.com/docs/discovery?topic=discovery-query-operators#query-operators).
     */
    public var query: String

    /**
     The type of the search query.
     */
    public var queryType: String

    /**
     An optional filter that narrows the set of documents to be searched. For more information, see the [Discovery
     service documentation]([Discovery service
     documentation](https://cloud.ibm.com/docs/discovery?topic=discovery-query-parameters#filter).
     */
    public var filter: String?

    /**
     The version of the Discovery service API to use for the query.
     */
    public var discoveryVersion: String?

    // Map each property name to the key that shall be used for encoding/decoding.
    private enum CodingKeys: String, CodingKey {
        case responseType = "response_type"
        case query = "query"
        case queryType = "query_type"
        case filter = "filter"
        case discoveryVersion = "discovery_version"
    }

    /**
      Initialize a `DialogNodeOutputGenericDialogNodeOutputResponseTypeSearchSkill` with member variables.

      - parameter responseType: The type of response returned by the dialog node. The specified response type must be
        supported by the client application or channel.
        **Note:** The **search_skill** response type is used only by the v2 runtime API.
      - parameter query: The text of the search query. This can be either a natural-language query or a query that
        uses the Discovery query language syntax, depending on the value of the **query_type** property. For more
        information, see the [Discovery service
        documentation](https://cloud.ibm.com/docs/discovery?topic=discovery-query-operators#query-operators).
      - parameter queryType: The type of the search query.
      - parameter filter: An optional filter that narrows the set of documents to be searched. For more information,
        see the [Discovery service documentation]([Discovery service
        documentation](https://cloud.ibm.com/docs/discovery?topic=discovery-query-parameters#filter).
      - parameter discoveryVersion: The version of the Discovery service API to use for the query.

      - returns: An initialized `DialogNodeOutputGenericDialogNodeOutputResponseTypeSearchSkill`.
     */
    public init(
        responseType: String,
        query: String,
        queryType: String,
        filter: String? = nil,
        discoveryVersion: String? = nil
    )
    {
        self.responseType = responseType
        self.query = query
        self.queryType = queryType
        self.filter = filter
        self.discoveryVersion = discoveryVersion
    }

}
