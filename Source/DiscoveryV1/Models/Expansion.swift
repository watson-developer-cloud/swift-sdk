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

/** An expansion definition. Each object respresents one set of expandable strings. For example, you could have expansions for the word `hot` in one object, and expansions for the word `cold` in another. */
public struct Expansion {

    /// A list of terms that will be expanded for this expansion. If specified, only the items in this list are expanded.
    public var inputTerms: [String]?

    /// A list of terms that this expansion will be expanded to. If specified without `input_terms`, it also functions as the input term list.
    public var expandedTerms: [String]

    /**
     Initialize a `Expansion` with member variables.

     - parameter expandedTerms: A list of terms that this expansion will be expanded to. If specified without `input_terms`, it also functions as the input term list.
     - parameter inputTerms: A list of terms that will be expanded for this expansion. If specified, only the items in this list are expanded.

     - returns: An initialized `Expansion`.
    */
    public init(expandedTerms: [String], inputTerms: [String]? = nil) {
        self.expandedTerms = expandedTerms
        self.inputTerms = inputTerms
    }
}

extension Expansion: Codable {

    private enum CodingKeys: String, CodingKey {
        case inputTerms = "input_terms"
        case expandedTerms = "expanded_terms"
        static let allValues = [inputTerms, expandedTerms]
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        inputTerms = try container.decodeIfPresent([String].self, forKey: .inputTerms)
        expandedTerms = try container.decode([String].self, forKey: .expandedTerms)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(inputTerms, forKey: .inputTerms)
        try container.encode(expandedTerms, forKey: .expandedTerms)
    }

}
