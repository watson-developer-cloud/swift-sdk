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
 An object that describes a response with response type `image`.

 Enums with an associated value of RuntimeResponseGenericRuntimeResponseTypeImage:
    RuntimeResponseGeneric
 */
public struct RuntimeResponseGenericRuntimeResponseTypeImage: Codable, Equatable {

    /**
     The type of response returned by the dialog node. The specified response type must be supported by the client
     application or channel.
     */
    public enum ResponseType: String {
        case image = "image"
    }

    /**
     The type of response returned by the dialog node. The specified response type must be supported by the client
     application or channel.
     */
    public var responseType: String

    /**
     The URL of the image.
     */
    public var source: String

    /**
     The title or introductory text to show before the response.
     */
    public var title: String?

    /**
     The description to show with the the response.
     */
    public var description: String?

    // Map each property name to the key that shall be used for encoding/decoding.
    private enum CodingKeys: String, CodingKey {
        case responseType = "response_type"
        case source = "source"
        case title = "title"
        case description = "description"
    }

    /**
      Initialize a `RuntimeResponseGenericRuntimeResponseTypeImage` with member variables.

      - parameter responseType: The type of response returned by the dialog node. The specified response type must be
        supported by the client application or channel.
      - parameter source: The URL of the image.
      - parameter title: The title or introductory text to show before the response.
      - parameter description: The description to show with the the response.

      - returns: An initialized `RuntimeResponseGenericRuntimeResponseTypeImage`.
     */
    public init(
        responseType: String,
        source: String,
        title: String? = nil,
        description: String? = nil
    )
    {
        self.responseType = responseType
        self.source = source
        self.title = title
        self.description = description
    }

}
