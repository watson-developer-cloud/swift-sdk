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

/**
 Age information about a face.
 */
public struct FaceAge: Codable, Equatable {

    /**
     Estimated minimum age.
     */
    public var min: Int?

    /**
     Estimated maximum age.
     */
    public var max: Int?

    /**
     Confidence score in the range of 0 to 1. A higher score indicates greater confidence in the estimated value for the
     property.
     */
    public var score: Double

    // Map each property name to the key that shall be used for encoding/decoding.
    private enum CodingKeys: String, CodingKey {
        case min = "min"
        case max = "max"
        case score = "score"
    }

}
