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

/** DeleteConfigurationResponse. */
public struct DeleteConfigurationResponse: Codable, Equatable {

    /**
     Status of the configuration. A deleted configuration has the status deleted.
     */
    public enum Status: String {
        case deleted = "deleted"
    }

    /**
     The unique identifier for the configuration.
     */
    public var configurationID: String

    /**
     Status of the configuration. A deleted configuration has the status deleted.
     */
    public var status: String

    /**
     An array of notice messages, if any.
     */
    public var notices: [Notice]?

    // Map each property name to the key that shall be used for encoding/decoding.
    private enum CodingKeys: String, CodingKey {
        case configurationID = "configuration_id"
        case status = "status"
        case notices = "notices"
    }

}
