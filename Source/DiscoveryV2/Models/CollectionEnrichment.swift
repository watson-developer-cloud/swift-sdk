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
 An object describing an Enrichment for a collection.
 */
public struct CollectionEnrichment: Codable, Equatable {

    /**
     The unique identifier of this enrichment.
     */
    public var enrichmentID: String?

    /**
     An array of field names that the enrichment is applied to.
     */
    public var fields: [String]?

    // Map each property name to the key that shall be used for encoding/decoding.
    private enum CodingKeys: String, CodingKey {
        case enrichmentID = "enrichment_id"
        case fields = "fields"
    }

    /**
      Initialize a `CollectionEnrichment` with member variables.

      - parameter enrichmentID: The unique identifier of this enrichment.
      - parameter fields: An array of field names that the enrichment is applied to.

      - returns: An initialized `CollectionEnrichment`.
     */
    public init(
        enrichmentID: String? = nil,
        fields: [String]? = nil
    )
    {
        self.enrichmentID = enrichmentID
        self.fields = fields
    }

}
