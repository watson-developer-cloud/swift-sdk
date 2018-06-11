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

/** QueryRelationsRelationship. */
public struct QueryRelationsRelationship: Decodable {

    /**
     The identified relationship type.
     */
    public var type: String?

    /**
     The number of times the relationship is mentioned.
     */
    public var frequency: Int?

    /**
     Information about the relationship.
     */
    public var arguments: [QueryRelationsArgument]?

    /**
     List of different evidentiary items to support the result.
     */
    public var evidence: [QueryEvidence]?

    // Map each property name to the key that shall be used for encoding/decoding.
    private enum CodingKeys: String, CodingKey {
        case type = "type"
        case frequency = "frequency"
        case arguments = "arguments"
        case evidence = "evidence"
    }

}
