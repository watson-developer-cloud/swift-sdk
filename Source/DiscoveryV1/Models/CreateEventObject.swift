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
 An object defining the event being created.
 */
internal struct CreateEventObject: Codable, Equatable {

    /**
     The event type to be created.
     */
    public enum TypeEnum: String {
        case click = "click"
    }

    /**
     The event type to be created.
     */
    public var type: String

    /**
     Query event data object.
     */
    public var data: EventData

    // Map each property name to the key that shall be used for encoding/decoding.
    private enum CodingKeys: String, CodingKey {
        case type = "type"
        case data = "data"
    }

    /**
     Initialize a `CreateEventObject` with member variables.

     - parameter type: The event type to be created.
     - parameter data: Query event data object.

     - returns: An initialized `CreateEventObject`.
    */
    public init(
        type: String,
        data: EventData
    )
    {
        self.type = type
        self.data = data
    }

}
