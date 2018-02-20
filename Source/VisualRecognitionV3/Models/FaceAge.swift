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

/** Provides age information about a face. If there are more than 10 faces in an image, the response might return the confidence score `0g. */
public struct FaceAge {

    /// Estimated minimum age.
    public var min: Int?

    /// Estimated maximum age.
    public var max: Int?

    /// Confidence score for the property in the range of 0 to 1. A higher score indicates greater likelihood that the class is depicted in the image. The default threshold for returning scores from a classifier is 0.5.
    public var score: Double?

    /**
     Initialize a `FaceAge` with member variables.

     - parameter min: Estimated minimum age.
     - parameter max: Estimated maximum age.
     - parameter score: Confidence score for the property in the range of 0 to 1. A higher score indicates greater likelihood that the class is depicted in the image. The default threshold for returning scores from a classifier is 0.5.

     - returns: An initialized `FaceAge`.
    */
    public init(min: Int? = nil, max: Int? = nil, score: Double? = nil) {
        self.min = min
        self.max = max
        self.score = score
    }
}

extension FaceAge: Codable {

    private enum CodingKeys: String, CodingKey {
        case min = "min"
        case max = "max"
        case score = "score"
        static let allValues = [min, max, score]
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        min = try container.decodeIfPresent(Int.self, forKey: .min)
        max = try container.decodeIfPresent(Int.self, forKey: .max)
        score = try container.decodeIfPresent(Double.self, forKey: .score)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(min, forKey: .min)
        try container.encodeIfPresent(max, forKey: .max)
        try container.encodeIfPresent(score, forKey: .score)
    }

}
