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

/** A notice produced for the collection. */
public struct Notice {

    /// Severity level of the notice.
    public enum Severity: String {
        case warning = "warning"
        case error = "error"
    }

    /// Identifies the notice. Many notices might have the same ID. This field exists so that user applications can programmatically identify a notice and take automatic corrective action.
    public var noticeID: String?

    /// The creation date of the collection in the format yyyy-MM-dd'T'HH:mm:ss.SSS'Z'.
    public var created: String?

    /// Unique identifier of the document.
    public var documentID: String?

    /// Unique identifier of the query used for relevance training.
    public var queryID: String?

    /// Severity level of the notice.
    public var severity: String?

    /// Ingestion or training step in which the notice occurred.
    public var step: String?

    /// The description of the notice.
    public var description: String?

    /**
     Initialize a `Notice` with member variables.

     - parameter noticeID: Identifies the notice. Many notices might have the same ID. This field exists so that user applications can programmatically identify a notice and take automatic corrective action.
     - parameter created: The creation date of the collection in the format yyyy-MM-dd'T'HH:mm:ss.SSS'Z'.
     - parameter documentID: Unique identifier of the document.
     - parameter queryID: Unique identifier of the query used for relevance training.
     - parameter severity: Severity level of the notice.
     - parameter step: Ingestion or training step in which the notice occurred.
     - parameter description: The description of the notice.

     - returns: An initialized `Notice`.
    */
    public init(noticeID: String? = nil, created: String? = nil, documentID: String? = nil, queryID: String? = nil, severity: String? = nil, step: String? = nil, description: String? = nil) {
        self.noticeID = noticeID
        self.created = created
        self.documentID = documentID
        self.queryID = queryID
        self.severity = severity
        self.step = step
        self.description = description
    }
}

extension Notice: Codable {

    private enum CodingKeys: String, CodingKey {
        case noticeID = "notice_id"
        case created = "created"
        case documentID = "document_id"
        case queryID = "query_id"
        case severity = "severity"
        case step = "step"
        case description = "description"
        static let allValues = [noticeID, created, documentID, queryID, severity, step, description]
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        noticeID = try container.decodeIfPresent(String.self, forKey: .noticeID)
        created = try container.decodeIfPresent(String.self, forKey: .created)
        documentID = try container.decodeIfPresent(String.self, forKey: .documentID)
        queryID = try container.decodeIfPresent(String.self, forKey: .queryID)
        severity = try container.decodeIfPresent(String.self, forKey: .severity)
        step = try container.decodeIfPresent(String.self, forKey: .step)
        description = try container.decodeIfPresent(String.self, forKey: .description)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(noticeID, forKey: .noticeID)
        try container.encodeIfPresent(created, forKey: .created)
        try container.encodeIfPresent(documentID, forKey: .documentID)
        try container.encodeIfPresent(queryID, forKey: .queryID)
        try container.encodeIfPresent(severity, forKey: .severity)
        try container.encodeIfPresent(step, forKey: .step)
        try container.encodeIfPresent(description, forKey: .description)
    }

}
