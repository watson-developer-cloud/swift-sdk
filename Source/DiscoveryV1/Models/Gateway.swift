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
 Object describing a specific gateway.
 */
public struct Gateway: Codable, Equatable {

    /**
     The current status of the gateway. `connected` means the gateway is connected to the remotly installed gateway.
     `idle` means this gateway is not currently in use.
     */
    public enum Status: String {
        case connected = "connected"
        case idle = "idle"
    }

    /**
     The gateway ID of the gateway.
     */
    public var gatewayID: String?

    /**
     The user defined name of the gateway.
     */
    public var name: String?

    /**
     The current status of the gateway. `connected` means the gateway is connected to the remotly installed gateway.
     `idle` means this gateway is not currently in use.
     */
    public var status: String?

    /**
     The generated **token** for this gateway. The value of this field is used when configuring the remotly installed
     gateway.
     */
    public var token: String?

    /**
     The generated **token_id** for this gateway. The value of this field is used when configuring the remotly installed
     gateway.
     */
    public var tokenID: String?

    // Map each property name to the key that shall be used for encoding/decoding.
    private enum CodingKeys: String, CodingKey {
        case gatewayID = "gateway_id"
        case name = "name"
        case status = "status"
        case token = "token"
        case tokenID = "token_id"
    }

}
