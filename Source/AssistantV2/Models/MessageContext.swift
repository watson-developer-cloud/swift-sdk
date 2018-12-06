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
 State information for the conversation.
 */
public struct MessageContext: Codable, Equatable {

    /**
     Contains information that can be shared by all skills within the Assistant.
     */
    public var global: MessageContextGlobal?

    /**
     Contains information specific to particular skills within the Assistant.
     */
    public var skills: MessageContextSkills?

    // Map each property name to the key that shall be used for encoding/decoding.
    private enum CodingKeys: String, CodingKey {
        case global = "global"
        case skills = "skills"
    }

    /**
     Initialize a `MessageContext` with member variables.

     - parameter global: Contains information that can be shared by all skills within the Assistant.
     - parameter skills: Contains information specific to particular skills within the Assistant.

     - returns: An initialized `MessageContext`.
    */
    public init(
        global: MessageContextGlobal? = nil,
        skills: MessageContextSkills? = nil
    )
    {
        self.global = global
        self.skills = skills
    }

}
