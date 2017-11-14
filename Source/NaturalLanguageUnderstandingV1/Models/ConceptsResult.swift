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

/** The general concepts referenced or alluded to in the specified content. */
public struct ConceptsResult {

    /// Name of the concept.
    public var text: String?

    /// Relevance score between 0 and 1. Higher scores indicate greater relevance.
    public var relevance: Double?

    /// Link to the corresponding DBpedia resource.
    public var dbpediaResource: String?

    /**
     Initialize a `ConceptsResult` with member variables.

     - parameter text: Name of the concept.
     - parameter relevance: Relevance score between 0 and 1. Higher scores indicate greater relevance.
     - parameter dbpediaResource: Link to the corresponding DBpedia resource.

     - returns: An initialized `ConceptsResult`.
    */
    public init(text: String? = nil, relevance: Double? = nil, dbpediaResource: String? = nil) {
        self.text = text
        self.relevance = relevance
        self.dbpediaResource = dbpediaResource
    }
}

extension ConceptsResult: Codable {

    private enum CodingKeys: String, CodingKey {
        case text = "text"
        case relevance = "relevance"
        case dbpediaResource = "dbpedia_resource"
        static let allValues = [text, relevance, dbpediaResource]
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        text = try container.decodeIfPresent(String.self, forKey: .text)
        relevance = try container.decodeIfPresent(Double.self, forKey: .relevance)
        dbpediaResource = try container.decodeIfPresent(String.self, forKey: .dbpediaResource)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(text, forKey: .text)
        try container.encodeIfPresent(relevance, forKey: .relevance)
        try container.encodeIfPresent(dbpediaResource, forKey: .dbpediaResource)
    }

}
