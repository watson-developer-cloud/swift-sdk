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

/** ListCollectionsResponse. */
public struct ListCollectionsResponse {

    /// An array containing information about each collection in the environment.
    public var collections: [Collection]?

    /**
     Initialize a `ListCollectionsResponse` with member variables.

     - parameter collections: An array containing information about each collection in the environment.

     - returns: An initialized `ListCollectionsResponse`.
    */
    public init(collections: [Collection]? = nil) {
        self.collections = collections
    }
}

extension ListCollectionsResponse: Codable {

    private enum CodingKeys: String, CodingKey {
        case collections = "collections"
        static let allValues = [collections]
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        collections = try container.decodeIfPresent([Collection].self, forKey: .collections)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(collections, forKey: .collections)
    }

}
