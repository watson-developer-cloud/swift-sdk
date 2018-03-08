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

/** Content. */
public struct Content {

    /// An array of `ContentItem` objects that provides the text that is to be analyzed.
    public var contentItems: [ContentItem]

    /**
     Initialize a `Content` with member variables.

     - parameter contentItems: An array of `ContentItem` objects that provides the text that is to be analyzed.

     - returns: An initialized `Content`.
    */
    public init(contentItems: [ContentItem]) {
        self.contentItems = contentItems
    }
}

extension Content: Codable {

    private enum CodingKeys: String, CodingKey {
        case contentItems = "contentItems"
        static let allValues = [contentItems]
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        contentItems = try container.decode([ContentItem].self, forKey: .contentItems)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(contentItems, forKey: .contentItems)
    }

}
