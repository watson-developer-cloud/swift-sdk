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
import RestKit

/** A notice produced by the ingestion process. */
public struct Notice: JSONDecodable {
    
    /// Unique identifier of the notice.
    public let noticeID: String
    
    /// The creation date of the collection in the format yyyy-MM-dd'T'HH:mm
    /// :ss.SSS'Z'.
    public let created: String
    
    /// Unique identifier of the ingested document.
    public let documentID: String
    
    /// Severity level of the notice.
    public let severity: NoticeSeverity
    
    /// Ingestion step in which the notice occurred.
    public let step: String
    
    /// The description of the notice.
    public let description: String
    
    /// JSON with details that might help troubleshoot the notice.
    public let details: [String : Any]
    
    /// Used internally to initialize a `Notice` model from JSON.
    public init(json: JSON) throws {
        noticeID = try json.getString(at: "notice_id")
        created = try json.getString(at: "created")
        documentID = try json.getString(at: "document_id")
        guard let noticeSeverity = NoticeSeverity(rawValue: try json.getString(at: "severity")) else {
            throw JSON.Error.valueNotConvertible(value: json, to: NoticeSeverity.self)
        }
        severity = noticeSeverity
        step = try json.getString(at: "step")
        description = try json.getString(at: "description")
        details = try json.getDictionary(at: "details")
    }
}

/** Severity of a notice. */
public enum NoticeSeverity: String {
    
    /// Warning
    case warning = "warning"
    
    /// Error
    case error = "error"
}
