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

/** DocumentAccepted. */
public struct DocumentAccepted {

    /// Status of the document in the ingestion process.
    public enum Status: String {
        case processing = "processing"
    }

    /// The unique identifier of the ingested document.
    public var documentID: String?

    /// Status of the document in the ingestion process.
    public var status: String?

    /// Array of notices produced by the document-ingestion process.
    public var notices: [Notice]?

    /**
     Initialize a `DocumentAccepted` with member variables.

     - parameter documentID: The unique identifier of the ingested document.
     - parameter status: Status of the document in the ingestion process.
     - parameter notices: Array of notices produced by the document-ingestion process.

     - returns: An initialized `DocumentAccepted`.
    */
    public init(documentID: String? = nil, status: String? = nil, notices: [Notice]? = nil) {
        self.documentID = documentID
        self.status = status
        self.notices = notices
    }
}

extension DocumentAccepted: Codable {

    private enum CodingKeys: String, CodingKey {
        case documentID = "document_id"
        case status = "status"
        case notices = "notices"
        static let allValues = [documentID, status, notices]
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        documentID = try container.decodeIfPresent(String.self, forKey: .documentID)
        status = try container.decodeIfPresent(String.self, forKey: .status)
        notices = try container.decodeIfPresent([Notice].self, forKey: .notices)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(documentID, forKey: .documentID)
        try container.encodeIfPresent(status, forKey: .status)
        try container.encodeIfPresent(notices, forKey: .notices)
    }

}
