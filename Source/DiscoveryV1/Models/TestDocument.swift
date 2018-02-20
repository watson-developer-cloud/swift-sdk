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

/** TestDocument. */
public struct TestDocument {

    /// The unique identifier for the configuration.
    public var configurationID: String?

    /// Status of the preview operation.
    public var status: String?

    /// The number of 10-kB chunks of field data that were enriched. This can be used to estimate the cost of running a real ingestion.
    public var enrichedFieldUnits: Int?

    /// Format of the test document.
    public var originalMediaType: String?

    /// An array of objects that describe each step in the preview process.
    public var snapshots: [DocumentSnapshot]?

    /// An array of notice messages about the preview operation.
    public var notices: [Notice]?

    /**
     Initialize a `TestDocument` with member variables.

     - parameter configurationID: The unique identifier for the configuration.
     - parameter status: Status of the preview operation.
     - parameter enrichedFieldUnits: The number of 10-kB chunks of field data that were enriched. This can be used to estimate the cost of running a real ingestion.
     - parameter originalMediaType: Format of the test document.
     - parameter snapshots: An array of objects that describe each step in the preview process.
     - parameter notices: An array of notice messages about the preview operation.

     - returns: An initialized `TestDocument`.
    */
    public init(configurationID: String? = nil, status: String? = nil, enrichedFieldUnits: Int? = nil, originalMediaType: String? = nil, snapshots: [DocumentSnapshot]? = nil, notices: [Notice]? = nil) {
        self.configurationID = configurationID
        self.status = status
        self.enrichedFieldUnits = enrichedFieldUnits
        self.originalMediaType = originalMediaType
        self.snapshots = snapshots
        self.notices = notices
    }
}

extension TestDocument: Codable {

    private enum CodingKeys: String, CodingKey {
        case configurationID = "configuration_id"
        case status = "status"
        case enrichedFieldUnits = "enriched_field_units"
        case originalMediaType = "original_media_type"
        case snapshots = "snapshots"
        case notices = "notices"
        static let allValues = [configurationID, status, enrichedFieldUnits, originalMediaType, snapshots, notices]
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        configurationID = try container.decodeIfPresent(String.self, forKey: .configurationID)
        status = try container.decodeIfPresent(String.self, forKey: .status)
        enrichedFieldUnits = try container.decodeIfPresent(Int.self, forKey: .enrichedFieldUnits)
        originalMediaType = try container.decodeIfPresent(String.self, forKey: .originalMediaType)
        snapshots = try container.decodeIfPresent([DocumentSnapshot].self, forKey: .snapshots)
        notices = try container.decodeIfPresent([Notice].self, forKey: .notices)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(configurationID, forKey: .configurationID)
        try container.encodeIfPresent(status, forKey: .status)
        try container.encodeIfPresent(enrichedFieldUnits, forKey: .enrichedFieldUnits)
        try container.encodeIfPresent(originalMediaType, forKey: .originalMediaType)
        try container.encodeIfPresent(snapshots, forKey: .snapshots)
        try container.encodeIfPresent(notices, forKey: .notices)
    }

}
