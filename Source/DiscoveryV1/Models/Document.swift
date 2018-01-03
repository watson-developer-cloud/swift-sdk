/**
 * Copyright IBM Corporation 2016
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

/** A document to upload to a collection. */
public struct Document: JSONDecodable {

    /// Unique identifier of the ingested document.
    public let documentID: String

    /// The unique identifier of the collection's configuration.
    public let configurationID: String?

    /// The creation date of the document in the format yyyy-MM-dd'T'HH:mm
    /// :ss.SSS'Z'.
    public let created: String?

    /// The timestamp of when the document was last updated in the format
    /// yyyy-MM-dd'T'HH:mm:ss.SSS'Z'.
    public let updated: String?

    /// The status of the document in ingestion process.
    public let status: DocumentStatus

    /// The description of the document status.
    public let statusDescription: String?

    /// The array of notices produced by the document-ingestion process.
    public let notices: [Notice]?

    /// The raw JSON object used to construct this model.
    public let json: [String: Any]

    /// Used internally to initialize a `Document` model from JSON.
    public init(json: JSONWrapper) throws {
        documentID = try json.getString(at: "document_id")
        configurationID = try? json.getString(at: "configuration_id")
        created = try? json.getString(at: "created")
        updated = try? json.getString(at: "updated")
        guard let documentStatus = DocumentStatus(rawValue: try json.getString(at: "status")) else {
            throw JSONWrapper.Error.valueNotConvertible(value: json, to: DocumentStatus.self)
        }
        status = documentStatus
        statusDescription = try? json.getString(at: "status_description")
        notices = try? json.decodedArray(at: "notices", type: Notice.self)
        self.json = try json.getDictionaryObject()
    }

    /// Used internally to serialize a 'Document' model to JSON.
    public func toJSONObject() -> Any {
        return json
    }
}

/** Status of a document uploaded to a collection. */
public enum DocumentStatus: String {

    /// Available
    case available = "available"

    /// Availabe with notices
    case availableWithNotices = "available with notices"

    /// Deleted
    case deleted = "deleted"

    /// Failed
    case failed = "failed"

    /// Processing
    case processing = "processing"
}
