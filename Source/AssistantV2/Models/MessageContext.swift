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

/** MessageContext. */
public struct MessageContext: Codable, Equatable {

    /**
     Information that is shared by all skills used by the Assistant.
     */
    public var global: MessageContextGlobal?

    /**
     Information specific to particular skills used by the Assistant.
     **Note:** Currently, only a single property named `main skill` is supported. This object contains variables that
     apply to the dialog skill used by the assistant.
     */
    public var skills: MessageContextSkills?

    // Map each property name to the key that shall be used for encoding/decoding.
    private enum CodingKeys: String, CodingKey {
        case global = "global"
        case skills = "skills"
    }

    /**
     Initialize a `MessageContext` with member variables.

     - parameter global: Information that is shared by all skills used by the Assistant.
     - parameter skills: Information specific to particular skills used by the Assistant.
       **Note:** Currently, only a single property named `main skill` is supported. This object contains variables that
       apply to the dialog skill used by the assistant.

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
