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

/** WordStyle. */
public struct WordStyle: Codable, Equatable {

    /**
     HTML head level that content matching this style is tagged with.
     */
    public var level: Int?

    /**
     Array of word style names to convert.
     */
    public var names: [String]?

    // Map each property name to the key that shall be used for encoding/decoding.
    private enum CodingKeys: String, CodingKey {
        case level = "level"
        case names = "names"
    }

    /**
     Initialize a `WordStyle` with member variables.

     - parameter level: HTML head level that content matching this style is tagged with.
     - parameter names: Array of word style names to convert.

     - returns: An initialized `WordStyle`.
    */
    public init(
        level: Int? = nil,
        names: [String]? = nil
    )
    {
        self.level = level
        self.names = names
    }

}
