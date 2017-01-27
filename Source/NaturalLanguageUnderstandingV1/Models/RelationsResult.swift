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
import RestKit

public struct RelationsResult: JSONDecodable,JSONEncodable {
    /// Confidence score for the relation. Higher values indicate greater confidence.
    public let score: Double?
    /// The sentence that contains the relation
    public let sentence: String?
    /// The type of the relation
    public let type: String?
    public let arguments: [RelationArgument]?

    /**
     Initialize a `RelationsResult` with required member variables.

     - returns: An initialized `RelationsResult`.
    */
    public init() {
        self.score = nil
        self.sentence = nil
        self.type = nil
        self.arguments = nil
    }

    /**
    Initialize a `RelationsResult` with all member variables.

     - parameter score: Confidence score for the relation. Higher values indicate greater confidence.
     - parameter sentence: The sentence that contains the relation
     - parameter type: The type of the relation
     - parameter arguments: 

    - returns: An initialized `RelationsResult`.
    */
    public init(score: Double, sentence: String, type: String, arguments: [RelationArgument]) {
        self.score = score
        self.sentence = sentence
        self.type = type
        self.arguments = arguments
    }

    // MARK: JSONDecodable
    /// Used internally to initialize a `RelationsResult` model from JSON.
    public init(json: JSON) throws {
        score = try? json.getDouble(at: "score")
        sentence = try? json.getString(at: "sentence")
        type = try? json.getString(at: "type")
        arguments = try? json.decodedArray(at: "arguments", type: RelationArgument.self)
    }

    // MARK: JSONEncodable
    /// Used internally to serialize a `RelationsResult` model to JSON.
    public func toJSONObject() -> Any {
        var json = [String: Any]()
        if let score = score { json["score"] = score }
        if let sentence = sentence { json["sentence"] = sentence }
        if let type = type { json["type"] = type }
        if let arguments = arguments {
            json["arguments"] = arguments.map { argumentsElem in argumentsElem.toJSONObject() }
        }
        return json
    }
}
