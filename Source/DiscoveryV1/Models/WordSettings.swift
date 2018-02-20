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

/** A list of Word conversion settings. */
public struct WordSettings {

    public var heading: WordHeadingDetection?

    /**
     Initialize a `WordSettings` with member variables.

     - parameter heading:

     - returns: An initialized `WordSettings`.
    */
    public init(heading: WordHeadingDetection? = nil) {
        self.heading = heading
    }
}

extension WordSettings: Codable {

    private enum CodingKeys: String, CodingKey {
        case heading = "heading"
        static let allValues = [heading]
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        heading = try container.decodeIfPresent(WordHeadingDetection.self, forKey: .heading)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(heading, forKey: .heading)
    }

}
