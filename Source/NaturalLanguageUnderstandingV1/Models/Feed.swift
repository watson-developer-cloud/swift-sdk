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

/** RSS or ATOM feed found on the webpage. */
public struct Feed {

    /// URL of the RSS or ATOM feed.
    public var link: String?

    /**
     Initialize a `Feed` with member variables.

     - parameter link: URL of the RSS or ATOM feed.

     - returns: An initialized `Feed`.
    */
    public init(link: String? = nil) {
        self.link = link
    }
}

extension Feed: Codable {

    private enum CodingKeys: String, CodingKey {
        case link = "link"
        static let allValues = [link]
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        link = try container.decodeIfPresent(String.self, forKey: .link)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(link, forKey: .link)
    }

}
