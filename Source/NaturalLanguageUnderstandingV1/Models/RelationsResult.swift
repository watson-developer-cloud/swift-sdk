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

/** The relations between entities found in the content. */
public struct RelationsResult {

    /// Confidence score for the relation. Higher values indicate greater confidence.
    public var score: Double?

    /// The sentence that contains the relation.
    public var sentence: String?

    /// The type of the relation.
    public var type: String?

    /// The extracted relation objects from the text.
    public var arguments: [RelationArgument]?

    /**
     Initialize a `RelationsResult` with member variables.

     - parameter score: Confidence score for the relation. Higher values indicate greater confidence.
     - parameter sentence: The sentence that contains the relation.
     - parameter type: The type of the relation.
     - parameter arguments: The extracted relation objects from the text.

     - returns: An initialized `RelationsResult`.
    */
    public init(score: Double? = nil, sentence: String? = nil, type: String? = nil, arguments: [RelationArgument]? = nil) {
        self.score = score
        self.sentence = sentence
        self.type = type
        self.arguments = arguments
    }
}

extension RelationsResult: Codable {

    private enum CodingKeys: String, CodingKey {
        case score = "score"
        case sentence = "sentence"
        case type = "type"
        case arguments = "arguments"
        static let allValues = [score, sentence, type, arguments]
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        score = try container.decodeIfPresent(Double.self, forKey: .score)
        sentence = try container.decodeIfPresent(String.self, forKey: .sentence)
        type = try container.decodeIfPresent(String.self, forKey: .type)
        arguments = try container.decodeIfPresent([RelationArgument].self, forKey: .arguments)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(score, forKey: .score)
        try container.encodeIfPresent(sentence, forKey: .sentence)
        try container.encodeIfPresent(type, forKey: .type)
        try container.encodeIfPresent(arguments, forKey: .arguments)
    }

}
