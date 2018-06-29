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

/**
 The general concepts referenced or alluded to in the specified content.
 */
public struct ConceptsResult: Decodable {

    /**
     Name of the concept.
     */
    public var text: String?

    /**
     Relevance score between 0 and 1. Higher scores indicate greater relevance.
     */
    public var relevance: Double?

    /**
     Link to the corresponding DBpedia resource.
     */
    public var dbpediaResource: String?

    // Map each property name to the key that shall be used for encoding/decoding.
    private enum CodingKeys: String, CodingKey {
        case text = "text"
        case relevance = "relevance"
        case dbpediaResource = "dbpedia_resource"
    }

}
