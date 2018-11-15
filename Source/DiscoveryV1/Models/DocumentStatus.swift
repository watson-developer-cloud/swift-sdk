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

/**
 Status information about a submitted document.
 */
public struct DocumentStatus: Codable, Equatable {

    /**
     Status of the document in the ingestion process.
     */
    public enum Status: String {
        case available = "available"
        case availableWithNotices = "available with notices"
        case failed = "failed"
        case processing = "processing"
    }

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
    public var documentID: String

    /**
     The unique identifier for the configuration.
     */
    public var configurationID: String?

    /**
     The creation date of the document in the format yyyy-MM-dd'T'HH:mm:ss.SSS'Z'.
     */
    public var created: Date?

    /**
     Date of the most recent document update, in the format yyyy-MM-dd'T'HH:mm:ss.SSS'Z'.
     */
    public var updated: Date?

    /**
     Status of the document in the ingestion process.
     */
    public var status: String

    /**
     Description of the document status.
     */
    public var statusDescription: String

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
     Array of notices produced by the document-ingestion process.
     */
    public var notices: [Notice]

    // Map each property name to the key that shall be used for encoding/decoding.
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
    }

}
