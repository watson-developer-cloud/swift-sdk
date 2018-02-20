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

/** QueryRelationsResponse. */
public struct QueryRelationsResponse {

    public var relations: [QueryRelationsRelationship]?

    /**
     Initialize a `QueryRelationsResponse` with member variables.

     - parameter relations:

     - returns: An initialized `QueryRelationsResponse`.
    */
    public init(relations: [QueryRelationsRelationship]? = nil) {
        self.relations = relations
    }
}

extension QueryRelationsResponse: Codable {

    private enum CodingKeys: String, CodingKey {
        case relations = "relations"
        static let allValues = [relations]
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        relations = try container.decodeIfPresent([QueryRelationsRelationship].self, forKey: .relations)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(relations, forKey: .relations)
    }

}
