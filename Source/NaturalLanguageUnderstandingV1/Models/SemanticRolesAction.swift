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

/** SemanticRolesAction. */
public struct SemanticRolesAction {

    /// Analyzed text that corresponds to the action.
    public var text: String?

    /// normalized version of the action.
    public var normalized: String?

    public var verb: SemanticRolesVerb?

    /**
     Initialize a `SemanticRolesAction` with member variables.

     - parameter text: Analyzed text that corresponds to the action.
     - parameter normalized: normalized version of the action.
     - parameter verb:

     - returns: An initialized `SemanticRolesAction`.
    */
    public init(text: String? = nil, normalized: String? = nil, verb: SemanticRolesVerb? = nil) {
        self.text = text
        self.normalized = normalized
        self.verb = verb
    }
}

extension SemanticRolesAction: Codable {

    private enum CodingKeys: String, CodingKey {
        case text = "text"
        case normalized = "normalized"
        case verb = "verb"
        static let allValues = [text, normalized, verb]
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        text = try container.decodeIfPresent(String.self, forKey: .text)
        normalized = try container.decodeIfPresent(String.self, forKey: .normalized)
        verb = try container.decodeIfPresent(SemanticRolesVerb.self, forKey: .verb)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(text, forKey: .text)
        try container.encodeIfPresent(normalized, forKey: .normalized)
        try container.encodeIfPresent(verb, forKey: .verb)
    }

}
