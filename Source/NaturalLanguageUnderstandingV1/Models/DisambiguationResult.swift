/**
 * Copyright IBM Corporation 2017
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

/** Disambiguation information for the entity. */
public struct DisambiguationResult {

    /// Common entity name.
    public var name: String?

    /// Link to the corresponding DBpedia resource.
    public var dbpediaResource: String?

    /// Entity subtype information.
    public var subtype: [String]?

    /**
     Initialize a `DisambiguationResult` with member variables.

     - parameter name: Common entity name.
     - parameter dbpediaResource: Link to the corresponding DBpedia resource.
     - parameter subtype: Entity subtype information.

     - returns: An initialized `DisambiguationResult`.
    */
    public init(name: String? = nil, dbpediaResource: String? = nil, subtype: [String]? = nil) {
        self.name = name
        self.dbpediaResource = dbpediaResource
        self.subtype = subtype
    }
}

extension DisambiguationResult: Codable {

    private enum CodingKeys: String, CodingKey {
        case name = "name"
        case dbpediaResource = "dbpedia_resource"
        case subtype = "subtype"
        static let allValues = [name, dbpediaResource, subtype]
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decodeIfPresent(String.self, forKey: .name)
        dbpediaResource = try container.decodeIfPresent(String.self, forKey: .dbpediaResource)
        subtype = try container.decodeIfPresent([String].self, forKey: .subtype)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(name, forKey: .name)
        try container.encodeIfPresent(dbpediaResource, forKey: .dbpediaResource)
        try container.encodeIfPresent(subtype, forKey: .subtype)
    }

}
