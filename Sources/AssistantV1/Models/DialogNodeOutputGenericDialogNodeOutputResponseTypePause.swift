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
 An object that describes a response with response type `pause`.

 Enums with an associated value of DialogNodeOutputGenericDialogNodeOutputResponseTypePause:
    DialogNodeOutputGeneric
 */
public struct DialogNodeOutputGenericDialogNodeOutputResponseTypePause: Codable, Equatable {

    /**
     The type of response returned by the dialog node. The specified response type must be supported by the client
     application or channel.
     */
    public enum ResponseType: String {
        case pause = "pause"
    }

    /**
     The type of response returned by the dialog node. The specified response type must be supported by the client
     application or channel.
     */
    public var responseType: String

    /**
     How long to pause, in milliseconds. The valid values are from 0 to 10000.
     */
    public var time: Int

    /**
     Whether to send a "user is typing" event during the pause. Ignored if the channel does not support this event.
     */
    public var typing: Bool?

    // Map each property name to the key that shall be used for encoding/decoding.
    private enum CodingKeys: String, CodingKey {
        case responseType = "response_type"
        case time = "time"
        case typing = "typing"
    }

    /**
      Initialize a `DialogNodeOutputGenericDialogNodeOutputResponseTypePause` with member variables.

      - parameter responseType: The type of response returned by the dialog node. The specified response type must be
        supported by the client application or channel.
      - parameter time: How long to pause, in milliseconds. The valid values are from 0 to 10000.
      - parameter typing: Whether to send a "user is typing" event during the pause. Ignored if the channel does not
        support this event.

      - returns: An initialized `DialogNodeOutputGenericDialogNodeOutputResponseTypePause`.
     */
    public init(
        responseType: String,
        time: Int,
        typing: Bool? = nil
    )
    {
        self.responseType = responseType
        self.time = time
        self.typing = typing
    }

}
