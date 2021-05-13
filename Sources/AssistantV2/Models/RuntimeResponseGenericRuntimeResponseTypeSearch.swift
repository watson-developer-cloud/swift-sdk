/**
 * (C) Copyright IBM Corp. 2020, 2021.
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
 RuntimeResponseGenericRuntimeResponseTypeSearch.

 Enums with an associated value of RuntimeResponseGenericRuntimeResponseTypeSearch:
    RuntimeResponseGeneric
 */
public struct RuntimeResponseGenericRuntimeResponseTypeSearch: Codable, Equatable {

    /**
     The type of response returned by the dialog node. The specified response type must be supported by the client
     application or channel.
     */
    public var responseType: String

    /**
     The title or introductory text to show before the response. This text is defined in the search skill configuration.
     */
    public var header: String

    /**
     An array of objects that contains the search results to be displayed in the initial response to the user.
     */
    public var primaryResults: [SearchResult]

    /**
     An array of objects that contains additional search results that can be displayed to the user upon request.
     */
    public var additionalResults: [SearchResult]

    /**
     An array of objects specifying channels for which the response is intended. If **channels** is present, the
     response is intended for a built-in integration and should not be handled by an API client.
     */
    public var channels: [ResponseGenericChannel]?

    // Map each property name to the key that shall be used for encoding/decoding.
    private enum CodingKeys: String, CodingKey {
        case responseType = "response_type"
        case header = "header"
        case primaryResults = "primary_results"
        case additionalResults = "additional_results"
        case channels = "channels"
    }

}
