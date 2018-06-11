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

/** RegisterStatus. */
public struct RegisterStatus: Decodable {

    /**
     The current status of the job:
     * `created` if the callback URL was successfully white-listed as a result of the call.
     * `already created` if the URL was already white-listed.
     */
    public enum Status: String {
        case created = "created"
        case alreadyCreated = "already created"
    }

    /**
     The current status of the job:
     * `created` if the callback URL was successfully white-listed as a result of the call.
     * `already created` if the URL was already white-listed.
     */
    public var status: String

    /**
     The callback URL that is successfully registered.
     */
    public var url: String

    // Map each property name to the key that shall be used for encoding/decoding.
    private enum CodingKeys: String, CodingKey {
        case status = "status"
        case url = "url"
    }

}
