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
import IBMSwiftSDKCore

/**
 Result document for the specified query.
 */
public struct QueryResult: Codable, Equatable {

    /**
     The unique identifier of the document.
     */
    public var documentID: String

    /**
     Metadata of the document.
     */
    public var metadata: [String: JSON]?

    /**
     Metadata of a query result.
     */
    public var resultMetadata: QueryResultMetadata

    /**
     Passages returned by Discovery.
     */
    public var documentPassages: [QueryResultPassage]?

    /// Additional properties associated with this model.
    public var additionalProperties: [String: JSON]

    // Map each property name to the key that shall be used for encoding/decoding.
    private enum CodingKeys: String, CodingKey {
        case documentID = "document_id"
        case metadata = "metadata"
        case resultMetadata = "result_metadata"
        case documentPassages = "document_passages"
        static let allValues = [documentID, metadata, resultMetadata, documentPassages]
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        documentID = try container.decode(String.self, forKey: .documentID)
        metadata = try container.decodeIfPresent([String: JSON].self, forKey: .metadata)
        resultMetadata = try container.decode(QueryResultMetadata.self, forKey: .resultMetadata)
        documentPassages = try container.decodeIfPresent([QueryResultPassage].self, forKey: .documentPassages)
        let dynamicContainer = try decoder.container(keyedBy: DynamicKeys.self)
        additionalProperties = try dynamicContainer.decode([String: JSON].self, excluding: CodingKeys.allValues)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(documentID, forKey: .documentID)
        try container.encodeIfPresent(metadata, forKey: .metadata)
        try container.encode(resultMetadata, forKey: .resultMetadata)
        try container.encodeIfPresent(documentPassages, forKey: .documentPassages)
        var dynamicContainer = encoder.container(keyedBy: DynamicKeys.self)
        try dynamicContainer.encodeIfPresent(additionalProperties)
    }

}
