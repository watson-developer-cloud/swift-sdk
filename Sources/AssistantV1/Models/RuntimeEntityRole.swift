/**
 * (C) Copyright IBM Corp. 2020.
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
 An object describing the role played by a system entity that is specifies the beginning or end of a range recognized in
 the user input. This property is included only if the new system entities are enabled for the workspace.
 */
public struct RuntimeEntityRole: Codable, Equatable {

    /**
     The relationship of the entity to the range.
     */
    public enum TypeEnum: String {
        case dateFrom = "date_from"
        case dateTo = "date_to"
        case numberFrom = "number_from"
        case numberTo = "number_to"
        case timeFrom = "time_from"
        case timeTo = "time_to"
    }

    /**
     The relationship of the entity to the range.
     */
    public var type: String?

    // Map each property name to the key that shall be used for encoding/decoding.
    private enum CodingKeys: String, CodingKey {
        case type = "type"
    }

    /**
      Initialize a `RuntimeEntityRole` with member variables.

      - parameter type: The relationship of the entity to the range.

      - returns: An initialized `RuntimeEntityRole`.
     */
    public init(
        type: String? = nil
    )
    {
        self.type = type
    }

}
