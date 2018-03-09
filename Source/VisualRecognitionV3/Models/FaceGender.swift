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

/** Provides information about the gender of the face. If there are more than 10 faces in an image, the response might return the confidence score 0. */
public struct FaceGender {

    /// Gender identified by the face. For example, `MALE` or `FEMALE`.
    public var gender: String

    /// Confidence score for the property in the range of 0 to 1. A higher score indicates greater likelihood that the class is depicted in the image. The default threshold for returning scores from a classifier is 0.5.
    public var score: Double?

    /**
     Initialize a `FaceGender` with member variables.

     - parameter gender: Gender identified by the face. For example, `MALE` or `FEMALE`.
     - parameter score: Confidence score for the property in the range of 0 to 1. A higher score indicates greater likelihood that the class is depicted in the image. The default threshold for returning scores from a classifier is 0.5.

     - returns: An initialized `FaceGender`.
    */
    public init(gender: String, score: Double? = nil) {
        self.gender = gender
        self.score = score
    }
}

extension FaceGender: Codable {

    private enum CodingKeys: String, CodingKey {
        case gender = "gender"
        case score = "score"
        static let allValues = [gender, score]
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        gender = try container.decode(String.self, forKey: .gender)
        score = try container.decodeIfPresent(Double.self, forKey: .score)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(gender, forKey: .gender)
        try container.encodeIfPresent(score, forKey: .score)
    }

}
