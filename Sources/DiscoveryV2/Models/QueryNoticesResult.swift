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
public struct QueryNoticesResult: Codable, Equatable {

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
    public var documentID: String?

    /**
     Metadata of the document.
     */
    public var metadata: [String: JSON]?

    /**
     Metadata of a query result.
     */
    public var resultMetadata: QueryResultMetadata?

    /**
     Passages returned by Discovery.
     */
    public var documentPassages: [QueryResultPassage]?

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
        case documentID = "document_id"
        case metadata = "metadata"
        case resultMetadata = "result_metadata"
        case documentPassages = "document_passages"
        case code = "code"
        case filename = "filename"
        case fileType = "file_type"
        case sha1 = "sha1"
        case notices = "notices"
        static let allValues = [documentID, metadata, resultMetadata, documentPassages, code, filename, fileType, sha1, notices]
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        documentID = try container.decodeIfPresent(String.self, forKey: .documentID)
        metadata = try container.decodeIfPresent([String: JSON].self, forKey: .metadata)
        resultMetadata = try container.decodeIfPresent(QueryResultMetadata.self, forKey: .resultMetadata)
        documentPassages = try container.decodeIfPresent([QueryResultPassage].self, forKey: .documentPassages)
        code = try container.decodeIfPresent(Int.self, forKey: .code)
        filename = try container.decodeIfPresent(String.self, forKey: .filename)
        fileType = try container.decodeIfPresent(String.self, forKey: .fileType)
        sha1 = try container.decodeIfPresent(String.self, forKey: .sha1)
        notices = try container.decodeIfPresent([Notice].self, forKey: .notices)
        let dynamicContainer = try decoder.container(keyedBy: DynamicKeys.self)
        additionalProperties = try dynamicContainer.decode([String: JSON].self, excluding: CodingKeys.allValues)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(documentID, forKey: .documentID)
        try container.encodeIfPresent(metadata, forKey: .metadata)
        try container.encodeIfPresent(resultMetadata, forKey: .resultMetadata)
        try container.encodeIfPresent(documentPassages, forKey: .documentPassages)
        try container.encodeIfPresent(code, forKey: .code)
        try container.encodeIfPresent(filename, forKey: .filename)
        try container.encodeIfPresent(fileType, forKey: .fileType)
        try container.encodeIfPresent(sha1, forKey: .sha1)
        try container.encodeIfPresent(notices, forKey: .notices)
        var dynamicContainer = encoder.container(keyedBy: DynamicKeys.self)
        try dynamicContainer.encodeIfPresent(additionalProperties)
    }

}
