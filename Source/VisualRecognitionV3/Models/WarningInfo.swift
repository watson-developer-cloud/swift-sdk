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

/** Information about something that went wrong. */
public struct WarningInfo {

    /// Codified warning string, such as `limit_reached`.
    public var warningID: String

    /// Information about the error.
    public var description: String

    /**
     Initialize a `WarningInfo` with member variables.

     - parameter warningID: Codified warning string, such as `limit_reached`.
     - parameter description: Information about the error.

     - returns: An initialized `WarningInfo`.
    */
    public init(warningID: String, description: String) {
        self.warningID = warningID
        self.description = description
    }
}

extension WarningInfo: Codable {

    private enum CodingKeys: String, CodingKey {
        case warningID = "warning_id"
        case description = "description"
        static let allValues = [warningID, description]
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        warningID = try container.decode(String.self, forKey: .warningID)
        description = try container.decode(String.self, forKey: .description)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(warningID, forKey: .warningID)
        try container.encode(description, forKey: .description)
    }

}
