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

/** FontSetting. */
public struct FontSetting: Codable, Equatable {

    public var level: Int?

    public var minSize: Int?

    public var maxSize: Int?

    public var bold: Bool?

    public var italic: Bool?

    public var name: String?

    // Map each property name to the key that shall be used for encoding/decoding.
    private enum CodingKeys: String, CodingKey {
        case level = "level"
        case minSize = "min_size"
        case maxSize = "max_size"
        case bold = "bold"
        case italic = "italic"
        case name = "name"
    }

    /**
     Initialize a `FontSetting` with member variables.

     - parameter level:
     - parameter minSize:
     - parameter maxSize:
     - parameter bold:
     - parameter italic:
     - parameter name:

     - returns: An initialized `FontSetting`.
    */
    public init(
        level: Int? = nil,
        minSize: Int? = nil,
        maxSize: Int? = nil,
        bold: Bool? = nil,
        italic: Bool? = nil,
        name: String? = nil
    )
    {
        self.level = level
        self.minSize = minSize
        self.maxSize = maxSize
        self.bold = bold
        self.italic = italic
        self.name = name
    }

}
