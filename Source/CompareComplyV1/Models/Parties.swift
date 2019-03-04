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
 A party and its corresponding role, including address and contact information if identified.
 */
public struct Parties: Codable, Equatable {

    /**
     A string that identifies the importance of the party.
     */
    public enum Importance: String {
        case primary = "Primary"
        case unknown = "Unknown"
    }

    /**
     A string identifying the party.
     */
    public var party: String?

    /**
     A string that identifies the importance of the party.
     */
    public var importance: String?

    /**
     A string identifying the party's role.
     */
    public var role: String?

    /**
     List of the party's address or addresses.
     */
    public var addresses: [Address]?

    /**
     List of the names and roles of contacts identified in the input document.
     */
    public var contacts: [Contact]?

    // Map each property name to the key that shall be used for encoding/decoding.
    private enum CodingKeys: String, CodingKey {
        case party = "party"
        case importance = "importance"
        case role = "role"
        case addresses = "addresses"
        case contacts = "contacts"
    }

}
