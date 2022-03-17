/**
 * (C) Copyright IBM Corp. 2022.
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
import IBMSwiftSDKCore

/**
 DialogNodeOutputGenericDialogNodeOutputResponseTypeVideo.

 Enums with an associated value of DialogNodeOutputGenericDialogNodeOutputResponseTypeVideo:
    DialogNodeOutputGeneric
 */
public struct DialogNodeOutputGenericDialogNodeOutputResponseTypeVideo: Codable, Equatable {

    /**
     The type of response returned by the dialog node. The specified response type must be supported by the client
     application or channel.
     */
    public var responseType: String

    /**
     The `https:` URL of the video.
     */
    public var source: String

    /**
     An optional title to show before the response.
     */
    public var title: String?

    /**
     An optional description to show with the response.
     */
    public var description: String?

    /**
     An array of objects specifying channels for which the response is intended. If **channels** is present, the
     response is intended for a built-in integration and should not be handled by an API client.
     */
    public var channels: [ResponseGenericChannel]?

    /**
     For internal use only.
     */
    public var channelOptions: [String: JSON]?

    /**
     Descriptive text that can be used for screen readers or other situations where the video cannot be seen.
     */
    public var altText: String?

    // Map each property name to the key that shall be used for encoding/decoding.
    private enum CodingKeys: String, CodingKey {
        case responseType = "response_type"
        case source = "source"
        case title = "title"
        case description = "description"
        case channels = "channels"
        case channelOptions = "channel_options"
        case altText = "alt_text"
    }

    /**
      Initialize a `DialogNodeOutputGenericDialogNodeOutputResponseTypeVideo` with member variables.

      - parameter responseType: The type of response returned by the dialog node. The specified response type must be
        supported by the client application or channel.
      - parameter source: The `https:` URL of the video.
      - parameter title: An optional title to show before the response.
      - parameter description: An optional description to show with the response.
      - parameter channels: An array of objects specifying channels for which the response is intended. If
        **channels** is present, the response is intended for a built-in integration and should not be handled by an API
        client.
      - parameter channelOptions: For internal use only.
      - parameter altText: Descriptive text that can be used for screen readers or other situations where the video
        cannot be seen.

      - returns: An initialized `DialogNodeOutputGenericDialogNodeOutputResponseTypeVideo`.
     */
    public init(
        responseType: String,
        source: String,
        title: String? = nil,
        description: String? = nil,
        channels: [ResponseGenericChannel]? = nil,
        channelOptions: [String: JSON]? = nil,
        altText: String? = nil
    )
    {
        self.responseType = responseType
        self.source = source
        self.title = title
        self.description = description
        self.channels = channels
        self.channelOptions = channelOptions
        self.altText = altText
    }

}
