/**
 * (C) Copyright IBM Corp. 2019.
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
 Configuration for suggested refinements.
 */
public struct QueryLargeSuggestedRefinements: Codable, Equatable {

    /**
     Whether to perform suggested refinements.
     */
    public var enabled: Bool?

    /**
     Maximum number of suggested refinements texts to be returned. The default is `10`. The maximum is `100`.
     */
    public var count: Int?

    // Map each property name to the key that shall be used for encoding/decoding.
    private enum CodingKeys: String, CodingKey {
        case enabled = "enabled"
        case count = "count"
    }

    /**
     Initialize a `QueryLargeSuggestedRefinements` with member variables.

     - parameter enabled: Whether to perform suggested refinements.
     - parameter count: Maximum number of suggested refinements texts to be returned. The default is `10`. The
       maximum is `100`.

     - returns: An initialized `QueryLargeSuggestedRefinements`.
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
