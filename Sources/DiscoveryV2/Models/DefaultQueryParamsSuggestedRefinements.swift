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
 Object containing suggested refinement settings.
 */
public struct DefaultQueryParamsSuggestedRefinements: Codable, Equatable {

    /**
     When `true`, a suggested refinements for the query are returned by default.
     */
    public var enabled: Bool?

    /**
     The number of suggested refinements to return by default.
     */
    public var count: Int?

    // Map each property name to the key that shall be used for encoding/decoding.
    private enum CodingKeys: String, CodingKey {
        case enabled = "enabled"
        case count = "count"
    }

    /**
      Initialize a `DefaultQueryParamsSuggestedRefinements` with member variables.

      - parameter enabled: When `true`, a suggested refinements for the query are returned by default.
      - parameter count: The number of suggested refinements to return by default.

      - returns: An initialized `DefaultQueryParamsSuggestedRefinements`.
     */
    public init(
        enabled: Bool? = nil,
        count: Int? = nil
    )
    {
        self.enabled = enabled
        self.count = count
    }

}
