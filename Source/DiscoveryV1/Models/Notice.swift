/**
 * Copyright IBM Corporation 2019
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
 A notice produced for the collection.
 */
public struct Notice: Codable, Equatable {

    /**
     Severity level of the notice.
     */
    public enum Severity: String {
        case warning = "warning"
        case error = "error"
    }

    /**
     Identifies the notice. Many notices might have the same ID. This field exists so that user applications can
     programmatically identify a notice and take automatic corrective action. Typical notice IDs include:
     `index_failed`, `index_failed_too_many_requests`, `index_failed_incompatible_field`,
     `index_failed_cluster_unavailable`, `ingestion_timeout`, `ingestion_error`, `bad_request`, `internal_error`,
     `missing_model`, `unsupported_model`, `smart_document_understanding_failed_incompatible_field`,
     `smart_document_understanding_failed_internal_error`, `smart_document_understanding_failed_internal_error`,
     `smart_document_understanding_failed_warning`, `smart_document_understanding_page_error`,
     `smart_document_understanding_page_warning`. **Note:** This is not a complete list, other values might be returned.
     */
    public var noticeID: String?

    /**
     The creation date of the collection in the format yyyy-MM-dd'T'HH:mm:ss.SSS'Z'.
     */
    public var created: Date?

    /**
     Unique identifier of the document.
     */
    public var documentID: String?

    /**
     Unique identifier of the query used for relevance training.
     */
    public var queryID: String?

    /**
     Severity level of the notice.
     */
    public var severity: String?

    /**
     Ingestion or training step in which the notice occurred. Typical step values include: `classify_elements`,
     `smartDocumentUnderstanding`, `ingestion`, `indexing`, `convert`. **Note:** This is not a complete list, other
     values might be returned.
     */
    public var step: String?

    /**
     The description of the notice.
     */
    public var description: String?

    // Map each property name to the key that shall be used for encoding/decoding.
    private enum CodingKeys: String, CodingKey {
        case noticeID = "notice_id"
        case created = "created"
        case documentID = "document_id"
        case queryID = "query_id"
        case severity = "severity"
        case step = "step"
        case description = "description"
    }

}
