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
import RestKit

/** QueryResult. */
public struct QueryResult: Codable, Equatable {

    /**
     The unique identifier of the document.
     */
    public var id: String?

    /**
     Metadata of the document.
     */
    public var metadata: [String: JSON]?

    /**
     The collection ID of the collection containing the document for this result.
     */
    public var collectionID: String?

    /**
     Metadata of a query result.
     */
    public var resultMetadata: QueryResultMetadata?

    /// Additional properties associated with this model.
    public var additionalProperties: [String: JSON]

    // Map each property name to the key that shall be used for encoding/decoding.
    private enum CodingKeys: String, CodingKey {
        case id = "id"
        case metadata = "metadata"
        case collectionID = "collection_id"
        case resultMetadata = "result_metadata"
        static let allValues = [id, metadata, collectionID, resultMetadata]
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decodeIfPresent(String.self, forKey: .id)
        metadata = try container.decodeIfPresent([String: JSON].self, forKey: .metadata)
        collectionID = try container.decodeIfPresent(String.self, forKey: .collectionID)
        resultMetadata = try container.decodeIfPresent(QueryResultMetadata.self, forKey: .resultMetadata)
        let dynamicContainer = try decoder.container(keyedBy: DynamicKeys.self)
        additionalProperties = try dynamicContainer.decode([String: JSON].self, excluding: CodingKeys.allValues)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(id, forKey: .id)
        try container.encodeIfPresent(metadata, forKey: .metadata)
        try container.encodeIfPresent(collectionID, forKey: .collectionID)
        try container.encodeIfPresent(resultMetadata, forKey: .resultMetadata)
        var dynamicContainer = encoder.container(keyedBy: DynamicKeys.self)
        try dynamicContainer.encodeIfPresent(additionalProperties)
    }

}
