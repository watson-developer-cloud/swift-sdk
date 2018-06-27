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
 **Deprecated**: Summary of the memory usage statistics for this environment.
 */
public struct MemoryUsage: Decodable {

    /**
     **Deprecated**: Number of bytes used in the environment's memory capacity.
     */
    public var usedBytes: Int?

    /**
     **Deprecated**: Total number of bytes available in the environment's memory capacity.
     */
    public var totalBytes: Int?

    /**
     **Deprecated**: Amount of memory capacity used, in KB or GB format.
     */
    public var used: String?

    /**
     **Deprecated**: Total amount of the environment's memory capacity, in KB or GB format.
     */
    public var total: String?

    /**
     **Deprecated**: Percentage of the environment's memory capacity that is being used.
     */
    public var percentUsed: Double?

    // Map each property name to the key that shall be used for encoding/decoding.
    private enum CodingKeys: String, CodingKey {
        case usedBytes = "used_bytes"
        case totalBytes = "total_bytes"
        case used = "used"
        case total = "total"
        case percentUsed = "percent_used"
    }

}
