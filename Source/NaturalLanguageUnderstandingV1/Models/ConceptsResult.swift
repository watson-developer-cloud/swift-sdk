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
import RestKit

public struct ConceptsResult: JSONDecodable,JSONEncodable {
    /// Name of the concept
    public let name: String?
    /// Relevance score between 0 and 1. Higher scores indicate greater relevance
    public let relevance: Double?
    /// link to the corresponding DBpedia resource
    public let dbpediaResource: DBpediaResource?

    /**
     Initialize a `ConceptsResult` with required member variables.

     - returns: An initialized `ConceptsResult`.
    */
    public init() {
        self.name = nil
        self.relevance = nil
        self.dbpediaResource = nil
    }

    /**
    Initialize a `ConceptsResult` with all member variables.

     - parameter name: Name of the concept
     - parameter relevance: Relevance score between 0 and 1. Higher scores indicate greater relevance
     - parameter dbpediaResource: link to the corresponding DBpedia resource

    - returns: An initialized `ConceptsResult`.
    */
    public init(name: String, relevance: Double, dbpediaResource: DBpediaResource) {
        self.name = name
        self.relevance = relevance
        self.dbpediaResource = dbpediaResource
    }

    // MARK: JSONDecodable
    /// Used internally to initialize a `ConceptsResult` model from JSON.
    public init(json: JSON) throws {
        name = try? json.getString(at: "name")
        relevance = try? json.getDouble(at: "relevance")
        dbpediaResource = try? json.getJSON(at: "dbpedia_resource") as! DBpediaResource
    }

    // MARK: JSONEncodable
    /// Used internally to serialize a `ConceptsResult` model to JSON.
    public func toJSONObject() -> Any {
        var json = [String: Any]()
        if let name = name { json["name"] = name }
        if let relevance = relevance { json["relevance"] = relevance }
        if let dbpediaResource = dbpediaResource { json["dbpedia_resource"] = dbpediaResource }
        return json
    }
}
