/**
 * Copyright IBM Corporation 2019
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
 Identification of a specific type.
 */
public struct TypeLabel: Codable, Equatable {

    /**
     A pair of `nature` and `party` objects. The `nature` object identifies the effect of the element on the identified
     `party`, and the `party` object identifies the affected party.
     */
    public var label: Label?

    /**
     One or more hash values that you can send to IBM to provide feedback or receive support.
     */
    public var provenanceIDs: [String]?

    // Map each property name to the key that shall be used for encoding/decoding.
    private enum CodingKeys: String, CodingKey {
        case label = "label"
        case provenanceIDs = "provenance_ids"
    }

    /**
     Initialize a `TypeLabel` with member variables.

     - parameter label: A pair of `nature` and `party` objects. The `nature` object identifies the effect of the
       element on the identified `party`, and the `party` object identifies the affected party.
     - parameter provenanceIDs: One or more hash values that you can send to IBM to provide feedback or receive
       support.

     - returns: An initialized `TypeLabel`.
    */
    public init(
        label: Label? = nil,
        provenanceIDs: [String]? = nil
    )
    {
        self.label = label
        self.provenanceIDs = provenanceIDs
    }

}
