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
 Contains information that can be shared by all skills within the Assistant.
 */
public struct MessageContextGlobal: Codable, Equatable {

    /**
     Properties that are shared by all skills used by the assistant.
     */
    public var system: MessageContextGlobalSystem?

    // Map each property name to the key that shall be used for encoding/decoding.
    private enum CodingKeys: String, CodingKey {
        case system = "system"
    }

    /**
     Initialize a `MessageContextGlobal` with member variables.

     - parameter system: Properties that are shared by all skills used by the assistant.

     - returns: An initialized `MessageContextGlobal`.
    */
    public init(
        system: MessageContextGlobalSystem? = nil
    )
    {
        self.system = system
    }

}
