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

/** DeleteDocumentResponse. */
public struct DeleteDocumentResponse {

    /// Status of the document. A deleted document has the status deleted.
    public enum Status: String {
        case deleted = "deleted"
    }

    /// The unique identifier of the document.
    public var documentID: String?

    /// Status of the document. A deleted document has the status deleted.
    public var status: String?

    /**
     Initialize a `DeleteDocumentResponse` with member variables.

     - parameter documentID: The unique identifier of the document.
     - parameter status: Status of the document. A deleted document has the status deleted.

     - returns: An initialized `DeleteDocumentResponse`.
    */
    public init(documentID: String? = nil, status: String? = nil) {
        self.documentID = documentID
        self.status = status
    }
}

extension DeleteDocumentResponse: Codable {

    private enum CodingKeys: String, CodingKey {
        case documentID = "document_id"
        case status = "status"
        static let allValues = [documentID, status]
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        documentID = try container.decodeIfPresent(String.self, forKey: .documentID)
        status = try container.decodeIfPresent(String.self, forKey: .status)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(documentID, forKey: .documentID)
        try container.encodeIfPresent(status, forKey: .status)
    }

}
