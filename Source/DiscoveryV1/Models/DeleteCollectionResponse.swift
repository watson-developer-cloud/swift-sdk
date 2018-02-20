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

/** DeleteCollectionResponse. */
public struct DeleteCollectionResponse {

    /// The status of the collection. The status of a successful deletion operation is `deleted`.
    public enum Status: String {
        case deleted = "deleted"
    }

    /// The unique identifier of the collection that is being deleted.
    public var collectionID: String

    /// The status of the collection. The status of a successful deletion operation is `deleted`.
    public var status: String

    /**
     Initialize a `DeleteCollectionResponse` with member variables.

     - parameter collectionID: The unique identifier of the collection that is being deleted.
     - parameter status: The status of the collection. The status of a successful deletion operation is `deleted`.

     - returns: An initialized `DeleteCollectionResponse`.
    */
    public init(collectionID: String, status: String) {
        self.collectionID = collectionID
        self.status = status
    }
}

extension DeleteCollectionResponse: Codable {

    private enum CodingKeys: String, CodingKey {
        case collectionID = "collection_id"
        case status = "status"
        static let allValues = [collectionID, status]
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        collectionID = try container.decode(String.self, forKey: .collectionID)
        status = try container.decode(String.self, forKey: .status)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(collectionID, forKey: .collectionID)
        try container.encode(status, forKey: .status)
    }

}
