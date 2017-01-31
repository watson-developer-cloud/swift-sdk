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

/** The general concepts referenced or alluded to in the specified content. */
public struct ConceptsResult: JSONDecodable {
    
    /// Name of the concept.
    public let name: String?
    
    /// Relevance score between 0 and 1. Higher scores indicate greater relevance.
    public let relevance: Double?
    
    /// Link to the corresponding DBpedia resource.
    public let dbpediaResource: String?

    /// Used internally to initialize a `ConceptsResult` model from JSON.
    public init(json: JSON) throws {
        name = try? json.getString(at: "text")
        relevance = try? json.getDouble(at: "relevance")
        dbpediaResource = try? json.getString(at: "dbpedia_resource")
    }
}
