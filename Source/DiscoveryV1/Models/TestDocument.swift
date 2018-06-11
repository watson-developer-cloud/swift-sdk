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
public struct TestDocument: Decodable {

    /**
     The unique identifier for the configuration.
     */
    public var configurationID: String?

    /**
     Status of the preview operation.
     */
    public var status: String?

    /**
     The number of 10-kB chunks of field data that were enriched. This can be used to estimate the cost of running a
     real ingestion.
     */
    public var enrichedFieldUnits: Int?

    /**
     Format of the test document.
     */
    public var originalMediaType: String?

    /**
     An array of objects that describe each step in the preview process.
     */
    public var snapshots: [DocumentSnapshot]?

    /**
     An array of notice messages about the preview operation.
     */
    public var notices: [Notice]?

    // Map each property name to the key that shall be used for encoding/decoding.
    private enum CodingKeys: String, CodingKey {
        case configurationID = "configuration_id"
        case status = "status"
        case enrichedFieldUnits = "enriched_field_units"
        case originalMediaType = "original_media_type"
        case snapshots = "snapshots"
        case notices = "notices"
    }

}
