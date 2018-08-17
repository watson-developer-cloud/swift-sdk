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

/**
 Details about an environment.
 */
public struct Environment: Decodable {

    /**
     Status of the environment.
     */
    public enum Status: String {
        case active = "active"
        case pending = "pending"
        case maintenance = "maintenance"
    }

    /**
     Size of the environment.
     */
    public enum Size: String {
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
    public var created: String?

    /**
     Date of most recent environment update, in the format `yyyy-MM-dd'T'HH:mm:ss.SSS'Z'`.
     */
    public var updated: String?

    /**
     Status of the environment.
     */
    public var status: String?

    /**
     If `true`, the environment contains read-only collections that are maintained by IBM.
     */
    public var readOnly: Bool?

    /**
     Size of the environment.
     */
    public var size: String?

    /**
     Details about the resource usage and capacity of the environment.
     */
    public var indexCapacity: IndexCapacity?

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
        case indexCapacity = "index_capacity"
    }

}
