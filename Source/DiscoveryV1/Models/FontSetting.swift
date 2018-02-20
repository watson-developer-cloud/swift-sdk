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
public struct FontSetting {

    public var level: Int?

    public var minSize: Int?

    public var maxSize: Int?

    public var bold: Bool?

    public var italic: Bool?

    public var name: String?

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
    public init(level: Int? = nil, minSize: Int? = nil, maxSize: Int? = nil, bold: Bool? = nil, italic: Bool? = nil, name: String? = nil) {
        self.level = level
        self.minSize = minSize
        self.maxSize = maxSize
        self.bold = bold
        self.italic = italic
        self.name = name
    }
}

extension FontSetting: Codable {

    private enum CodingKeys: String, CodingKey {
        case level = "level"
        case minSize = "min_size"
        case maxSize = "max_size"
        case bold = "bold"
        case italic = "italic"
        case name = "name"
        static let allValues = [level, minSize, maxSize, bold, italic, name]
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        level = try container.decodeIfPresent(Int.self, forKey: .level)
        minSize = try container.decodeIfPresent(Int.self, forKey: .minSize)
        maxSize = try container.decodeIfPresent(Int.self, forKey: .maxSize)
        bold = try container.decodeIfPresent(Bool.self, forKey: .bold)
        italic = try container.decodeIfPresent(Bool.self, forKey: .italic)
        name = try container.decodeIfPresent(String.self, forKey: .name)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(level, forKey: .level)
        try container.encodeIfPresent(minSize, forKey: .minSize)
        try container.encodeIfPresent(maxSize, forKey: .maxSize)
        try container.encodeIfPresent(bold, forKey: .bold)
        try container.encodeIfPresent(italic, forKey: .italic)
        try container.encodeIfPresent(name, forKey: .name)
    }

}
