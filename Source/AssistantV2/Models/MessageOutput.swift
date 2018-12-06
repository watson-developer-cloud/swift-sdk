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
 Assistant output to be rendered or processed by the client.
 */
public struct MessageOutput: Codable, Equatable {

    /**
     Output intended for any channel. It is the responsibility of the client application to implement the supported
     response types.
     */
    public var generic: [DialogRuntimeResponseGeneric]?

    /**
     An array of intents recognized in the user input, sorted in descending order of confidence.
     */
    public var intents: [RuntimeIntent]?

    /**
     An array of entities identified in the user input.
     */
    public var entities: [RuntimeEntity]?

    /**
     An array of objects describing any actions requested by the dialog node.
     */
    public var actions: [DialogNodeAction]?

    /**
     Additional detailed information about a message response and how it was generated.
     */
    public var debug: MessageOutputDebug?

    // Map each property name to the key that shall be used for encoding/decoding.
    private enum CodingKeys: String, CodingKey {
        case generic = "generic"
        case intents = "intents"
        case entities = "entities"
        case actions = "actions"
        case debug = "debug"
    }

}
