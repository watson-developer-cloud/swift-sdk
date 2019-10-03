/**
 * (C) Copyright IBM Corp. 2019.
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
 Details about an object in the collection.
 */
public struct ObjectDetail: Codable, Equatable {

    /**
     The label for the object.
     */
    public var object: String

    /**
     Defines the location of the bounding box around the object.
     */
    public var location: Location

    /**
     Confidence score for the object in the range of 0 to 1. A higher score indicates greater likelihood that the object
     is depicted at this location in the image.
     */
    public var score: Double

    // Map each property name to the key that shall be used for encoding/decoding.
    private enum CodingKeys: String, CodingKey {
        case object = "object"
        case location = "location"
        case score = "score"
    }

}
