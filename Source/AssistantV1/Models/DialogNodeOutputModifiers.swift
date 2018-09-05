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
 Options that modify how specified output is handled.
 */
public struct DialogNodeOutputModifiers: Codable {

    /**
     Whether values in the output will overwrite output values in an array specified by previously executed dialog
     nodes. If this option is set to **false**, new values will be appended to previously specified values.
     */
    public var overwrite: Bool?

    // Map each property name to the key that shall be used for encoding/decoding.
    private enum CodingKeys: String, CodingKey {
        case overwrite = "overwrite"
    }

    /**
     Initialize a `DialogNodeOutputModifiers` with member variables.

     - parameter overwrite: Whether values in the output will overwrite output values in an array specified by
       previously executed dialog nodes. If this option is set to **false**, new values will be appended to previously
       specified values.

     - returns: An initialized `DialogNodeOutputModifiers`.
    */
    public init(
        overwrite: Bool? = nil
    )
    {
        self.overwrite = overwrite
    }

}
