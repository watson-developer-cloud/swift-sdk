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

/** Provides information about the face. */
public struct Face {

    public var age: FaceAge?

    public var gender: FaceGender?

    public var faceLocation: FaceLocation?

    public var identity: FaceIdentity?

    /**
     Initialize a `Face` with member variables.

     - parameter age:
     - parameter gender:
     - parameter faceLocation:
     - parameter identity:

     - returns: An initialized `Face`.
    */
    public init(age: FaceAge? = nil, gender: FaceGender? = nil, faceLocation: FaceLocation? = nil, identity: FaceIdentity? = nil) {
        self.age = age
        self.gender = gender
        self.faceLocation = faceLocation
        self.identity = identity
    }
}

extension Face: Codable {

    private enum CodingKeys: String, CodingKey {
        case age = "age"
        case gender = "gender"
        case faceLocation = "face_location"
        case identity = "identity"
        static let allValues = [age, gender, faceLocation, identity]
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        age = try container.decodeIfPresent(FaceAge.self, forKey: .age)
        gender = try container.decodeIfPresent(FaceGender.self, forKey: .gender)
        faceLocation = try container.decodeIfPresent(FaceLocation.self, forKey: .faceLocation)
        identity = try container.decodeIfPresent(FaceIdentity.self, forKey: .identity)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(age, forKey: .age)
        try container.encodeIfPresent(gender, forKey: .gender)
        try container.encodeIfPresent(faceLocation, forKey: .faceLocation)
        try container.encodeIfPresent(identity, forKey: .identity)
    }

}
