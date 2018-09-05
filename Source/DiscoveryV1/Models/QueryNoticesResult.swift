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

/** QueryNoticesResult. */
public struct QueryNoticesResult: Decodable {

    /**
     The type of the original source file.
     */
    public enum FileType: String {
        case pdf = "pdf"
        case html = "html"
        case word = "word"
        case json = "json"
    }

    /**
     The unique identifier of the document.
     */
    public var id: String?

    /**
     *Deprecated* This field is now part of the **result_metadata** object.
     */
    public var score: Double?

    /**
     Metadata of the document.
     */
    public var metadata: [String: JSON]?

    /**
     The collection ID of the collection containing the document for this result.
     */
    public var collectionID: String?

    /**
     Metadata of the query result.
     */
    public var resultMetadata: QueryResultMetadata?

    /**
     The internal status code returned by the ingestion subsystem indicating the overall result of ingesting the source
     document.
     */
    public var code: Int?

    /**
     Name of the original source file (if available).
     */
    public var filename: String?

    /**
     The type of the original source file.
     */
    public var fileType: String?

    /**
     The SHA-1 hash of the original source file (formatted as a hexadecimal string).
     */
    public var sha1: String?

    /**
     Array of notices for the document.
     */
    public var notices: [Notice]?

    /// Additional properties associated with this model.
    public var additionalProperties: [String: JSON]

    // Map each property name to the key that shall be used for encoding/decoding.
    private enum CodingKeys: String, CodingKey {
        case id = "id"
        case score = "score"
        case metadata = "metadata"
        case collectionID = "collection_id"
        case resultMetadata = "result_metadata"
        case code = "code"
        case filename = "filename"
        case fileType = "file_type"
        case sha1 = "sha1"
        case notices = "notices"
        static let allValues = [id, score, metadata, collectionID, resultMetadata, code, filename, fileType, sha1, notices]
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decodeIfPresent(String.self, forKey: .id)
        score = try container.decodeIfPresent(Double.self, forKey: .score)
        metadata = try container.decodeIfPresent([String: JSON].self, forKey: .metadata)
        collectionID = try container.decodeIfPresent(String.self, forKey: .collectionID)
        resultMetadata = try container.decodeIfPresent(QueryResultMetadata.self, forKey: .resultMetadata)
        code = try container.decodeIfPresent(Int.self, forKey: .code)
        filename = try container.decodeIfPresent(String.self, forKey: .filename)
        fileType = try container.decodeIfPresent(String.self, forKey: .fileType)
        sha1 = try container.decodeIfPresent(String.self, forKey: .sha1)
        notices = try container.decodeIfPresent([Notice].self, forKey: .notices)
        let dynamicContainer = try decoder.container(keyedBy: DynamicKeys.self)
        additionalProperties = try dynamicContainer.decode([String: JSON].self, excluding: CodingKeys.allValues)
    }

}
