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

/** Status information about a submitted document. */
public struct DocumentStatus {

    /// Status of the document in the ingestion process.
    public enum Status: String {
        case available = "available"
        case availableWithNotices = "available with notices"
        case failed = "failed"
        case processing = "processing"
    }

    /// The type of the original source file.
    public enum FileType: String {
        case pdf = "pdf"
        case html = "html"
        case word = "word"
        case json = "json"
    }

    /// The unique identifier of the document.
    public var documentID: String

    /// The unique identifier for the configuration.
    public var configurationID: String

    /// The creation date of the document in the format yyyy-MM-dd'T'HH:mm:ss.SSS'Z'.
    public var created: String

    /// Date of the most recent document update, in the format yyyy-MM-dd'T'HH:mm:ss.SSS'Z'.
    public var updated: String

    /// Status of the document in the ingestion process.
    public var status: String

    /// Description of the document status.
    public var statusDescription: String

    /// Name of the original source file (if available).
    public var filename: String?

    /// The type of the original source file.
    public var fileType: String?

    /// The SHA-1 hash of the original source file (formatted as a hexadecimal string).
    public var sha1: String?

    /// Array of notices produced by the document-ingestion process.
    public var notices: [Notice]

    /**
     Initialize a `DocumentStatus` with member variables.

     - parameter documentID: The unique identifier of the document.
     - parameter configurationID: The unique identifier for the configuration.
     - parameter created: The creation date of the document in the format yyyy-MM-dd'T'HH:mm:ss.SSS'Z'.
     - parameter updated: Date of the most recent document update, in the format yyyy-MM-dd'T'HH:mm:ss.SSS'Z'.
     - parameter status: Status of the document in the ingestion process.
     - parameter statusDescription: Description of the document status.
     - parameter notices: Array of notices produced by the document-ingestion process.
     - parameter filename: Name of the original source file (if available).
     - parameter fileType: The type of the original source file.
     - parameter sha1: The SHA-1 hash of the original source file (formatted as a hexadecimal string).

     - returns: An initialized `DocumentStatus`.
    */
    public init(documentID: String, configurationID: String, created: String, updated: String, status: String, statusDescription: String, notices: [Notice], filename: String? = nil, fileType: String? = nil, sha1: String? = nil) {
        self.documentID = documentID
        self.configurationID = configurationID
        self.created = created
        self.updated = updated
        self.status = status
        self.statusDescription = statusDescription
        self.notices = notices
        self.filename = filename
        self.fileType = fileType
        self.sha1 = sha1
    }
}

extension DocumentStatus: Codable {

    private enum CodingKeys: String, CodingKey {
        case documentID = "document_id"
        case configurationID = "configuration_id"
        case created = "created"
        case updated = "updated"
        case status = "status"
        case statusDescription = "status_description"
        case filename = "filename"
        case fileType = "file_type"
        case sha1 = "sha1"
        case notices = "notices"
        static let allValues = [documentID, configurationID, created, updated, status, statusDescription, filename, fileType, sha1, notices]
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        documentID = try container.decode(String.self, forKey: .documentID)
        configurationID = try container.decode(String.self, forKey: .configurationID)
        created = try container.decode(String.self, forKey: .created)
        updated = try container.decode(String.self, forKey: .updated)
        status = try container.decode(String.self, forKey: .status)
        statusDescription = try container.decode(String.self, forKey: .statusDescription)
        filename = try container.decodeIfPresent(String.self, forKey: .filename)
        fileType = try container.decodeIfPresent(String.self, forKey: .fileType)
        sha1 = try container.decodeIfPresent(String.self, forKey: .sha1)
        notices = try container.decode([Notice].self, forKey: .notices)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(documentID, forKey: .documentID)
        try container.encode(configurationID, forKey: .configurationID)
        try container.encode(created, forKey: .created)
        try container.encode(updated, forKey: .updated)
        try container.encode(status, forKey: .status)
        try container.encode(statusDescription, forKey: .statusDescription)
        try container.encodeIfPresent(filename, forKey: .filename)
        try container.encodeIfPresent(fileType, forKey: .fileType)
        try container.encodeIfPresent(sha1, forKey: .sha1)
        try container.encode(notices, forKey: .notices)
    }

}
