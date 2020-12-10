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
 Default settings configuration for passage search options.
 */
public struct DefaultQueryParamsPassages: Codable, Equatable {

    /**
     When `true`, a passage search is performed by default.
     */
    public var enabled: Bool?

    /**
     The number of passages to return.
     */
    public var count: Int?

    /**
     An array of field names to perform the passage search on.
     */
    public var fields: [String]?

    /**
     The approximate number of characters that each returned passage will contain.
     */
    public var characters: Int?

    /**
     When `true` the number of passages that can be returned from a single document is restricted to the
     *max_per_document* value.
     */
    public var perDocument: Bool?

    /**
     The default maximum number of passages that can be taken from a single document as the result of a passage query.
     */
    public var maxPerDocument: Int?

    // Map each property name to the key that shall be used for encoding/decoding.
    private enum CodingKeys: String, CodingKey {
        case enabled = "enabled"
        case count = "count"
        case fields = "fields"
        case characters = "characters"
        case perDocument = "per_document"
        case maxPerDocument = "max_per_document"
    }

    /**
      Initialize a `DefaultQueryParamsPassages` with member variables.

      - parameter enabled: When `true`, a passage search is performed by default.
      - parameter count: The number of passages to return.
      - parameter fields: An array of field names to perform the passage search on.
      - parameter characters: The approximate number of characters that each returned passage will contain.
      - parameter perDocument: When `true` the number of passages that can be returned from a single document is
        restricted to the *max_per_document* value.
      - parameter maxPerDocument: The default maximum number of passages that can be taken from a single document as
        the result of a passage query.

      - returns: An initialized `DefaultQueryParamsPassages`.
     */
    public init(
        enabled: Bool? = nil,
        count: Int? = nil,
        fields: [String]? = nil,
        characters: Int? = nil,
        perDocument: Bool? = nil,
        maxPerDocument: Int? = nil
    )
    {
        self.enabled = enabled
        self.count = count
        self.fields = fields
        self.characters = characters
        self.perDocument = perDocument
        self.maxPerDocument = maxPerDocument
    }

}
