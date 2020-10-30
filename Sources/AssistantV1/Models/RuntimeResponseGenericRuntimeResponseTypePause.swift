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

 Enums with an associated value of RuntimeResponseGenericRuntimeResponseTypePause:
    RuntimeResponseGeneric
 */
public struct RuntimeResponseGenericRuntimeResponseTypePause: Codable, Equatable {

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
     How long to pause, in milliseconds.
     */
    public var time: Int

    /**
     Whether to send a "user is typing" event during the pause.
     */
    public var typing: Bool?

    // Map each property name to the key that shall be used for encoding/decoding.
    private enum CodingKeys: String, CodingKey {
        case responseType = "response_type"
        case time = "time"
        case typing = "typing"
    }

    /**
      Initialize a `RuntimeResponseGenericRuntimeResponseTypePause` with member variables.

      - parameter responseType: The type of response returned by the dialog node. The specified response type must be
        supported by the client application or channel.
      - parameter time: How long to pause, in milliseconds.
      - parameter typing: Whether to send a "user is typing" event during the pause.

      - returns: An initialized `RuntimeResponseGenericRuntimeResponseTypePause`.
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
