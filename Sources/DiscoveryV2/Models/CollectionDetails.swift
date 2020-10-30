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
 A collection for storing documents.
 */
public struct CollectionDetails: Codable, Equatable {

    /**
     The unique identifier of the collection.
     */
    public var collectionID: String?

    /**
     The name of the collection.
     */
    public var name: String

    /**
     A description of the collection.
     */
    public var description: String?

    /**
     The date that the collection was created.
     */
    public var created: Date?

    /**
     The language of the collection.
     */
    public var language: String?

    /**
     An array of enrichments that are applied to this collection.
     */
    public var enrichments: [CollectionEnrichment]?

    // Map each property name to the key that shall be used for encoding/decoding.
    private enum CodingKeys: String, CodingKey {
        case collectionID = "collection_id"
        case name = "name"
        case description = "description"
        case created = "created"
        case language = "language"
        case enrichments = "enrichments"
    }

    /**
      Initialize a `CollectionDetails` with member variables.

      - parameter name: The name of the collection.
      - parameter description: A description of the collection.
      - parameter language: The language of the collection.
      - parameter enrichments: An array of enrichments that are applied to this collection.

      - returns: An initialized `CollectionDetails`.
     */
    public init(
        name: String,
        description: String? = nil,
        language: String? = nil,
        enrichments: [CollectionEnrichment]? = nil
    )
    {
        self.name = name
        self.description = description
        self.language = language
        self.enrichments = enrichments
    }

}
