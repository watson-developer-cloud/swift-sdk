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
import RestKit

/**
 Disambiguation information for the entity.
 */
public struct EntitiesResultDisambiguation: Codable, Equatable {

    /**
     Common entity name.
     */
    public var name: String?

    /**
     Link to the corresponding DBpedia resource.
     */
    public var dbpediaResource: [String: JSON]?

    /**
     Entity subtype information.
     */
    public var subtype: [String]?

    // Map each property name to the key that shall be used for encoding/decoding.
    private enum CodingKeys: String, CodingKey {
        case name = "name"
        case dbpediaResource = "dbpedia_resource"
        case subtype = "subtype"
    }

}
