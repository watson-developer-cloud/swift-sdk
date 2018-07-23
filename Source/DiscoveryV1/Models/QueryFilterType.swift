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

/** QueryFilterType. */
public struct QueryFilterType: Encodable {

    /**
     A comma-separated list of types to exclude.
     */
    public var exclude: [String]?

    /**
     A comma-separated list of types to include. All other types are excluded.
     */
    public var include: [String]?

    // Map each property name to the key that shall be used for encoding/decoding.
    private enum CodingKeys: String, CodingKey {
        case exclude = "exclude"
        case include = "include"
    }

    /**
     Initialize a `QueryFilterType` with member variables.

     - parameter exclude: A comma-separated list of types to exclude.
     - parameter include: A comma-separated list of types to include. All other types are excluded.

     - returns: An initialized `QueryFilterType`.
    */
    public init(
        exclude: [String]? = nil,
        include: [String]? = nil
    )
    {
        self.exclude = exclude
        self.include = include
    }

}
