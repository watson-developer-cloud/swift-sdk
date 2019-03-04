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
 Contains information specific to a particular skill used by the Assistant.
 */
public struct MessageContextSkill: Codable, Equatable {

    /**
     Arbitrary variables that can be read and written by a particular skill.
     */
    public var userDefined: String?

    // Map each property name to the key that shall be used for encoding/decoding.
    private enum CodingKeys: String, CodingKey {
        case userDefined = "user_defined"
    }

    /**
     Initialize a `MessageContextSkill` with member variables.

     - parameter userDefined: Arbitrary variables that can be read and written by a particular skill.

     - returns: An initialized `MessageContextSkill`.
    */
    public init(
        userDefined: String? = nil
    )
    {
        self.userDefined = userDefined
    }

}
