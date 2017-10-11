/**
 * Copyright IBM Corporation 2017
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

/** SemanticRolesVerb. */
public struct SemanticRolesVerb {

    /// The keyword text.
    public var text: String?

    /// Verb tense.
    public var tense: String?

    /**
     Initialize a `SemanticRolesVerb` with member variables.

     - parameter text: The keyword text.
     - parameter tense: Verb tense.

     - returns: An initialized `SemanticRolesVerb`.
    */
    public init(text: String? = nil, tense: String? = nil) {
        self.text = text
        self.tense = tense
    }
}

extension SemanticRolesVerb: Codable {

    private enum CodingKeys: String, CodingKey {
        case text = "text"
        case tense = "tense"
        static let allValues = [text, tense]
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        text = try container.decodeIfPresent(String.self, forKey: .text)
        tense = try container.decodeIfPresent(String.self, forKey: .tense)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(text, forKey: .text)
        try container.encodeIfPresent(tense, forKey: .tense)
    }

}
