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

/** FontSetting. */
public struct FontSetting: Codable, Equatable {

    /**
     The HTML heading level that any content with the matching font will be converted to.
     */
    public var level: Int?

    /**
     The minimum size of the font to match.
     */
    public var minSize: Int?

    /**
     The maximum size of the font to match.
     */
    public var maxSize: Int?

    /**
     When `true`, the font is matched if it is bold.
     */
    public var bold: Bool?

    /**
     When `true`, the font is matched if it is italic.
     */
    public var italic: Bool?

    /**
     The name of the font.
     */
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

     - parameter level: The HTML heading level that any content with the matching font will be converted to.
     - parameter minSize: The minimum size of the font to match.
     - parameter maxSize: The maximum size of the font to match.
     - parameter bold: When `true`, the font is matched if it is bold.
     - parameter italic: When `true`, the font is matched if it is italic.
     - parameter name: The name of the font.

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
