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

/** An object with information about the deleted configuration. */
public struct DeletedConfiguration: JSONDecodable {

    /// Unique identifier for the deleted configuration.
    public let configurationID: String

    /// Status of the configuration. A status of `deleted` indicates that the configuration
    /// was successfully deleted.
    public let status: String

    /// An array of notice messages.
    public let noticeMessages: [NoticeMessage]?

    /// Used internally to initialize a `DeletedConfiguration` model from JSON.
    public init(json: JSONWrapper) throws {
        configurationID = try json.getString(at: "configuration_id")
        status = try json.getString(at: "status")
        noticeMessages = try? json.decodedArray(at: "notices")
    }
}

/** An object containing warnings from the service. */
public struct NoticeMessage: JSONDecodable {

    /// Text ID of the notice.
    public let noticeID: String

    /// Creation date of the configuration, in the format yyyy-MM-dd'T'HH:mm:ss.SSS'Z'.
    public let created: String

    /// Severity of the notice.
    public let severity: String

    /// Description of the notice.
    public let description: String

    /// Used internally to initialize a `NoticeMessage` model from JSON.
    public init(json: JSONWrapper) throws {
        noticeID = try json.getString(at: "notice_id")
        created = try json.getString(at: "created")
        severity = try json.getString(at: "severity")
        description = try json.getString(at: "description")
    }
}
