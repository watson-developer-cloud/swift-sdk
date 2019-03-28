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
 Workspace settings related to the Watson Assistant tool.
 */
public struct WorkspaceSystemSettingsTooling: Codable, Equatable {

    /**
     Whether the dialog JSON editor displays text responses within the `output.generic` object.
     */
    public var storeGenericResponses: Bool?

    // Map each property name to the key that shall be used for encoding/decoding.
    private enum CodingKeys: String, CodingKey {
        case storeGenericResponses = "store_generic_responses"
    }

    /**
     Initialize a `WorkspaceSystemSettingsTooling` with member variables.

     - parameter storeGenericResponses: Whether the dialog JSON editor displays text responses within the
       `output.generic` object.

     - returns: An initialized `WorkspaceSystemSettingsTooling`.
    */
    public init(
        storeGenericResponses: Bool? = nil
    )
    {
        self.storeGenericResponses = storeGenericResponses
    }

}
