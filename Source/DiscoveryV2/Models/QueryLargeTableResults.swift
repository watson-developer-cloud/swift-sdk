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
 Configuration for table retrieval.
 */
public struct QueryLargeTableResults: Codable, Equatable {

    /**
     Whether to enable table retrieval.
     */
    public var enabled: Bool?

    /**
     Maximum number of tables to return.
     */
    public var count: Int?

    // Map each property name to the key that shall be used for encoding/decoding.
    private enum CodingKeys: String, CodingKey {
        case enabled = "enabled"
        case count = "count"
    }

    /**
     Initialize a `QueryLargeTableResults` with member variables.

     - parameter enabled: Whether to enable table retrieval.
     - parameter count: Maximum number of tables to return.

     - returns: An initialized `QueryLargeTableResults`.
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
