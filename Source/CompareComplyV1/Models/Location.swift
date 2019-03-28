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
 The numeric location of the identified element in the document, represented with two integers labeled `begin` and
 `end`.
 */
public struct Location: Codable, Equatable {

    /**
     The element's `begin` index.
     */
    public var begin: Int

    /**
     The element's `end` index.
     */
    public var end: Int

    // Map each property name to the key that shall be used for encoding/decoding.
    private enum CodingKeys: String, CodingKey {
        case begin = "begin"
        case end = "end"
    }

    /**
     Initialize a `Location` with member variables.

     - parameter begin: The element's `begin` index.
     - parameter end: The element's `end` index.

     - returns: An initialized `Location`.
    */
    public init(
        begin: Int,
        end: Int
    )
    {
        self.begin = begin
        self.end = end
    }

}
