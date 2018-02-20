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

/** QueryResult. */
public struct QueryResult {

    /// The unique identifier of the document.
    public var id: String?

    /// *Deprecated* This field is now part of the `result_metadata` object.
    public var score: Double?

    /// Metadata of the document.
    public var metadata: [String: JSON]?

    /// The collection ID of the collection containing the document for this result.
    public var collectionID: String?

    public var resultMetadata: QueryResultResultMetadata?

    /// Additional properties associated with this model.
    public var additionalProperties: [String: JSON]

    /**
     Initialize a `QueryResult` with member variables.

     - parameter id: The unique identifier of the document.
     - parameter score: *Deprecated* This field is now part of the `result_metadata` object.
     - parameter metadata: Metadata of the document.
     - parameter collectionID: The collection ID of the collection containing the document for this result.
     - parameter resultMetadata:

     - returns: An initialized `QueryResult`.
    */
    public init(id: String? = nil, score: Double? = nil, metadata: [String: JSON]? = nil, collectionID: String? = nil, resultMetadata: QueryResultResultMetadata? = nil, additionalProperties: [String: JSON] = [:]) {
        self.id = id
        self.score = score
        self.metadata = metadata
        self.collectionID = collectionID
        self.resultMetadata = resultMetadata
        self.additionalProperties = additionalProperties
    }
}

extension QueryResult: Codable {

    private enum CodingKeys: String, CodingKey {
        case id = "id"
        case score = "score"
        case metadata = "metadata"
        case collectionID = "collection_id"
        case resultMetadata = "result_metadata"
        static let allValues = [id, score, metadata, collectionID, resultMetadata]
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decodeIfPresent(String.self, forKey: .id)
        score = try container.decodeIfPresent(Double.self, forKey: .score)
        metadata = try container.decodeIfPresent([String: JSON].self, forKey: .metadata)
        collectionID = try container.decodeIfPresent(String.self, forKey: .collectionID)
        resultMetadata = try container.decodeIfPresent(QueryResultResultMetadata.self, forKey: .resultMetadata)
        let dynamicContainer = try decoder.container(keyedBy: DynamicKeys.self)
        additionalProperties = try dynamicContainer.decode([String: JSON].self, excluding: CodingKeys.allValues)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(id, forKey: .id)
        try container.encodeIfPresent(score, forKey: .score)
        try container.encodeIfPresent(metadata, forKey: .metadata)
        try container.encodeIfPresent(collectionID, forKey: .collectionID)
        try container.encodeIfPresent(resultMetadata, forKey: .resultMetadata)
        var dynamicContainer = encoder.container(keyedBy: DynamicKeys.self)
        try dynamicContainer.encodeIfPresent(additionalProperties)
    }

}
