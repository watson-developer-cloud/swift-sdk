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

/** WordHeadingDetection. */
public struct WordHeadingDetection {

    public var fonts: [FontSetting]?

    public var styles: [WordStyle]?

    /**
     Initialize a `WordHeadingDetection` with member variables.

     - parameter fonts:
     - parameter styles:

     - returns: An initialized `WordHeadingDetection`.
    */
    public init(fonts: [FontSetting]? = nil, styles: [WordStyle]? = nil) {
        self.fonts = fonts
        self.styles = styles
    }
}

extension WordHeadingDetection: Codable {

    private enum CodingKeys: String, CodingKey {
        case fonts = "fonts"
        case styles = "styles"
        static let allValues = [fonts, styles]
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        fonts = try container.decodeIfPresent([FontSetting].self, forKey: .fonts)
        styles = try container.decodeIfPresent([WordStyle].self, forKey: .styles)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(fonts, forKey: .fonts)
        try container.encodeIfPresent(styles, forKey: .styles)
    }

}
