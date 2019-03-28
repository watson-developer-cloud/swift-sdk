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
 Details about an environment.
 */
public struct Environment: Codable, Equatable {

    /**
     Current status of the environment. `resizing` is displayed when a request to increase the environment size has been
     made, but is still in the process of being completed.
     */
    public enum Status: String {
        case active = "active"
        case pending = "pending"
        case maintenance = "maintenance"
        case resizing = "resizing"
    }

    /**
     Current size of the environment.
     */
    public enum Size: String {
        case lt = "LT"
        case xs = "XS"
        case s = "S"
        case ms = "MS"
        case m = "M"
        case ml = "ML"
        case l = "L"
        case xl = "XL"
        case xxl = "XXL"
        case xxxl = "XXXL"
    }

    /**
     Unique identifier for the environment.
     */
    public var environmentID: String?

    /**
     Name that identifies the environment.
     */
    public var name: String?

    /**
     Description of the environment.
     */
    public var description: String?

    /**
     Creation date of the environment, in the format `yyyy-MM-dd'T'HH:mm:ss.SSS'Z'`.
     */
    public var created: Date?

    /**
     Date of most recent environment update, in the format `yyyy-MM-dd'T'HH:mm:ss.SSS'Z'`.
     */
    public var updated: Date?

    /**
     Current status of the environment. `resizing` is displayed when a request to increase the environment size has been
     made, but is still in the process of being completed.
     */
    public var status: String?

    /**
     If `true`, the environment contains read-only collections that are maintained by IBM.
     */
    public var readOnly: Bool?

    /**
     Current size of the environment.
     */
    public var size: String?

    /**
     The new size requested for this environment. Only returned when the environment *status* is `resizing`.
     *Note:* Querying and indexing can still be performed during an environment upsize.
     */
    public var requestedSize: String?

    /**
     Details about the resource usage and capacity of the environment.
     */
    public var indexCapacity: IndexCapacity?

    /**
     Information about the Continuous Relevancy Training for this environment.
     */
    public var searchStatus: SearchStatus?

    // Map each property name to the key that shall be used for encoding/decoding.
    private enum CodingKeys: String, CodingKey {
        case environmentID = "environment_id"
        case name = "name"
        case description = "description"
        case created = "created"
        case updated = "updated"
        case status = "status"
        case readOnly = "read_only"
        case size = "size"
        case requestedSize = "requested_size"
        case indexCapacity = "index_capacity"
        case searchStatus = "search_status"
    }

}
