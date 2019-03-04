/**
 * Copyright IBM Corporation 2019
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

/**
 Information about the gender of the face.
 */
public struct FaceGender: Codable, Equatable {

    /**
     Gender identified by the face. For example, `MALE` or `FEMALE`.
     */
    public var gender: String

    /**
     The word for "male" or "female" in the language defined by the **Accept-Language** request header.
     */
    public var genderLabel: String

    /**
     Confidence score in the range of 0 to 1. A higher score indicates greater confidence in the estimated value for the
     property.
     */
    public var score: Double

    // Map each property name to the key that shall be used for encoding/decoding.
    private enum CodingKeys: String, CodingKey {
        case gender = "gender"
        case genderLabel = "gender_label"
        case score = "score"
    }

}
