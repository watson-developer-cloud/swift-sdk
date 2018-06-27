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
 Entity description and location within evidence field.
 */
public struct QueryEvidenceEntity: Decodable {

    /**
     The entity type for this entity. Possible types vary based on model used.
     */
    public var type: String?

    /**
     The original text of this entity as found in the evidence field.
     */
    public var text: String?

    /**
     The start location of the entity text in the identified field. This value is inclusive.
     */
    public var startOffset: Int?

    /**
     The end location of the entity text in the identified field. This value is exclusive.
     */
    public var endOffset: Int?

    // Map each property name to the key that shall be used for encoding/decoding.
    private enum CodingKeys: String, CodingKey {
        case type = "type"
        case text = "text"
        case startOffset = "start_offset"
        case endOffset = "end_offset"
    }

}
