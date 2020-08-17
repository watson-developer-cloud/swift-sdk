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
 An object containing a new name and description for an enrichment.
 */
internal struct UpdateEnrichment: Codable, Equatable {

    /**
     A new name for the enrichment.
     */
    public var name: String

    /**
     A new description for the enrichment.
     */
    public var description: String?

    // Map each property name to the key that shall be used for encoding/decoding.
    private enum CodingKeys: String, CodingKey {
        case name = "name"
        case description = "description"
    }

    /**
      Initialize a `UpdateEnrichment` with member variables.

      - parameter name: A new name for the enrichment.
      - parameter description: A new description for the enrichment.

      - returns: An initialized `UpdateEnrichment`.
     */
    public init(
        name: String,
        description: String? = nil
    )
    {
        self.name = name
        self.description = description
    }

}
