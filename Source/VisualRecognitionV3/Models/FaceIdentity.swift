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

/** Provides information about a celebrity who is detected in the image. Not returned when a celebrity is not detected. */
public struct FaceIdentity {

    /// Name of the person.
    public var name: String

    /// Confidence score for the property in the range of 0 to 1. A higher score indicates greater likelihood that the
    /// class is depicted in the image. The default threshold for returning scores from a classifier is 0.5.
    public var score: Double?

    /// Knowledge graph of the property. For example, `People/Leaders/Presidents/USA/Barack Obama`. Included only if identified.
    public var typeHierarchy: String?

    /**
     Initialize a `FaceIdentity` with member variables.

     - parameter name: Name of the person.
     - parameter score: Confidence score for the property in the range of 0 to 1. A higher score indicates greater likelihood
       that the class is depicted in the image. The default threshold for returning scores from a classifier is 0.5.
     - parameter typeHierarchy: Knowledge graph of the property. For example, `People/Leaders/Presidents/USA/Barack Obama`.
       Included only if identified.

     - returns: An initialized `FaceIdentity`.
    */
    public init(name: String, score: Double? = nil, typeHierarchy: String? = nil) {
        self.name = name
        self.score = score
        self.typeHierarchy = typeHierarchy
    }
}

extension FaceIdentity: Codable {

    private enum CodingKeys: String, CodingKey {
        case name = "name"
        case score = "score"
        case typeHierarchy = "type_hierarchy"
        static let allValues = [name, score, typeHierarchy]
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decode(String.self, forKey: .name)
        score = try container.decodeIfPresent(Double.self, forKey: .score)
        typeHierarchy = try container.decodeIfPresent(String.self, forKey: .typeHierarchy)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encodeIfPresent(score, forKey: .score)
        try container.encodeIfPresent(typeHierarchy, forKey: .typeHierarchy)
    }

}
