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

/**
 An object that describes enrichments that are applied to the training data that is used by the document classifier.
 */
public struct DocumentClassifierEnrichment: Codable, Equatable {

    /**
     A unique identifier of the enrichment.
     */
    public var enrichmentID: String?

    /**
     An array of field names where the enrichment is applied.
     */
    public var fields: [String]

    // Map each property name to the key that shall be used for encoding/decoding.
    private enum CodingKeys: String, CodingKey {
        case enrichmentID = "enrichment_id"
        case fields = "fields"
    }

    /**
      Initialize a `DocumentClassifierEnrichment` with member variables.

      - parameter fields: An array of field names where the enrichment is applied.
      - parameter enrichmentID: A unique identifier of the enrichment.

      - returns: An initialized `DocumentClassifierEnrichment`.
     */
    public init(
        fields: [String],
        enrichmentID: String? = nil
    )
    {
        self.fields = fields
        self.enrichmentID = enrichmentID
    }

}
