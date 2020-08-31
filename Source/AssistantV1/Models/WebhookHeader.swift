/**
 * (C) Copyright IBM Corp. 2019.
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
 A key/value pair defining an HTTP header and a value.
 */
public struct WebhookHeader: Codable, Equatable {

    /**
     The name of an HTTP header (for example, `Authorization`).
     */
    public var name: String

    /**
     The value of an HTTP header.
     */
    public var value: String

    // Map each property name to the key that shall be used for encoding/decoding.
    private enum CodingKeys: String, CodingKey {
        case name = "name"
        case value = "value"
    }

    /**
      Initialize a `WebhookHeader` with member variables.

      - parameter name: The name of an HTTP header (for example, `Authorization`).
      - parameter value: The value of an HTTP header.

      - returns: An initialized `WebhookHeader`.
     */
    public init(
        name: String,
        value: String
    )
    {
        self.name = name
        self.value = value
    }

}
