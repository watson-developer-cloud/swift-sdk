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
 An object that describes a response with response type `suggestion`.

 Enums with an associated value of RuntimeResponseGenericRuntimeResponseTypeSuggestion:
    RuntimeResponseGeneric
 */
public struct RuntimeResponseGenericRuntimeResponseTypeSuggestion: Codable, Equatable {

    /**
     The type of response returned by the dialog node. The specified response type must be supported by the client
     application or channel.
     */
    public enum ResponseType: String {
        case suggestion = "suggestion"
    }

    /**
     The type of response returned by the dialog node. The specified response type must be supported by the client
     application or channel.
     */
    public var responseType: String

    /**
     The title or introductory text to show before the response.
     */
    public var title: String

    /**
     An array of objects describing the possible matching dialog nodes from which the user can choose.
     */
    public var suggestions: [DialogSuggestion]

    // Map each property name to the key that shall be used for encoding/decoding.
    private enum CodingKeys: String, CodingKey {
        case responseType = "response_type"
        case title = "title"
        case suggestions = "suggestions"
    }

    /**
      Initialize a `RuntimeResponseGenericRuntimeResponseTypeSuggestion` with member variables.

      - parameter responseType: The type of response returned by the dialog node. The specified response type must be
        supported by the client application or channel.
      - parameter title: The title or introductory text to show before the response.
      - parameter suggestions: An array of objects describing the possible matching dialog nodes from which the user
        can choose.

      - returns: An initialized `RuntimeResponseGenericRuntimeResponseTypeSuggestion`.
     */
    public init(
        responseType: String,
        title: String,
        suggestions: [DialogSuggestion]
    )
    {
        self.responseType = responseType
        self.title = title
        self.suggestions = suggestions
    }

}
