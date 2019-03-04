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
 A pair of `nature` and `party` objects. The `nature` object identifies the effect of the element on the identified
 `party`, and the `party` object identifies the affected party.
 */
public struct Label: Codable, Equatable {

    /**
     The identified `nature` of the element.
     */
    public var nature: String

    /**
     The identified `party` of the element.
     */
    public var party: String

    // Map each property name to the key that shall be used for encoding/decoding.
    private enum CodingKeys: String, CodingKey {
        case nature = "nature"
        case party = "party"
    }

    /**
     Initialize a `Label` with member variables.

     - parameter nature: The identified `nature` of the element.
     - parameter party: The identified `party` of the element.

     - returns: An initialized `Label`.
    */
    public init(
        nature: String,
        party: String
    )
    {
        self.nature = nature
        self.party = party
    }

}
