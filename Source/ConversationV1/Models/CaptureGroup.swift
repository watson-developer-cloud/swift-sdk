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

/** CaptureGroup. */
public struct CaptureGroup {

    /// A recognized capture group for the entity.
    public var group: String

    /// Zero-based character offsets that indicate where the entity value begins and ends in the input text.
    public var location: [Int]?

    /**
     Initialize a `CaptureGroup` with member variables.

     - parameter group: A recognized capture group for the entity.
     - parameter location: Zero-based character offsets that indicate where the entity value begins and ends in the input text.

     - returns: An initialized `CaptureGroup`.
    */
    public init(group: String, location: [Int]? = nil) {
        self.group = group
        self.location = location
    }
}

extension CaptureGroup: Codable {

    private enum CodingKeys: String, CodingKey {
        case group = "group"
        case location = "location"
        static let allValues = [group, location]
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        group = try container.decode(String.self, forKey: .group)
        location = try container.decodeIfPresent([Int].self, forKey: .location)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(group, forKey: .group)
        try container.encodeIfPresent(location, forKey: .location)
    }

}
