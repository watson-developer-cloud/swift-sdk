/**
 * (C) Copyright IBM Corp. 2020, 2022.
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
import IBMSwiftSDKCore

/**
 MessageContextStateless.
 */
public struct MessageContextStateless: Codable, Equatable {

    /**
     Session context data that is shared by all skills used by the assistant.
     */
    public var global: MessageContextGlobalStateless?

    /**
     Information specific to particular skills used by the assistant.
     **Note:** Currently, only a single child property is supported, containing variables that apply to the dialog skill
     used by the assistant.
     */
    public var skills: [String: MessageContextSkill]?

    /**
     An object containing context data that is specific to particular integrations. For more information, see the
     [documentation](https://cloud.ibm.com/docs/assistant?topic=assistant-dialog-integrations).
     */
    public var integrations: [String: JSON]?

    // Map each property name to the key that shall be used for encoding/decoding.
    private enum CodingKeys: String, CodingKey {
        case global = "global"
        case skills = "skills"
        case integrations = "integrations"
    }

    /**
      Initialize a `MessageContextStateless` with member variables.

      - parameter global: Session context data that is shared by all skills used by the assistant.
      - parameter skills: Information specific to particular skills used by the assistant.
        **Note:** Currently, only a single child property is supported, containing variables that apply to the dialog
        skill used by the assistant.
      - parameter integrations: An object containing context data that is specific to particular integrations. For
        more information, see the
        [documentation](https://cloud.ibm.com/docs/assistant?topic=assistant-dialog-integrations).

      - returns: An initialized `MessageContextStateless`.
     */
    public init(
        global: MessageContextGlobalStateless? = nil,
        skills: [String: MessageContextSkill]? = nil,
        integrations: [String: JSON]? = nil
    )
    {
        self.global = global
        self.skills = skills
        self.integrations = integrations
    }

}
